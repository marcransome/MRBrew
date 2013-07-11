//
//  MRBrew.m
//  MRBrew
//
//  Copyright (c) 2013 Marc Ransome <marc.ransome@fidgetbox.co.uk>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

#import "MRBrew.h"
#import "MRBrewDelegate.h"
#import "MRBrewOperation.h"
#import "MRBrewFormula.h"

extern NSString* const MRBrewOperationUpdateIdentifier;
extern NSString* const MRBrewOperationListIdentifier;
extern NSString* const MRBrewOperationSearchIdentifier;
extern NSString* const MRBrewOperationInstallIdentifier;
extern NSString* const MRBrewOperationInfoIdentifier;
extern NSString* const MRBrewOperationRemoveIdentifier;
extern NSString* const MRBrewOperationOptionsIdentifier;

static NSString* const MRBrewTaskIdentifier = @"MRBrewTaskIdentifier";
static NSString* const MRBrewOperationIdentifier = @"MRBrewOperationIdentifier";
static NSString* const MRBrewErrorDomain = @"co.uk.fidgetbox.MRBrew";

static NSString* MRBrewPath = @"/usr/local/bin/brew";

static NSMutableArray *taskArray;
static NSLock *taskArrayLock;
static NSOperationQueue *backgroundQueue;

@implementation MRBrew

+ (void)initialize
{
    taskArray = [[NSMutableArray alloc] init];
    taskArrayLock = [[NSLock alloc] init];
    backgroundQueue = [[NSOperationQueue alloc] init];
}

+ (NSString *)brewPath
{
    return MRBrewPath;
}

+ (void)setBrewPath:(NSString *)path
{
    MRBrewPath = path;
}

+ (void)performOperation:(MRBrewOperation *)operation delegate:(id<MRBrewDelegate>)delegate
{    
    // construct command-line arguments for brew command
    NSMutableArray *arguments = [NSMutableArray arrayWithObject:[operation operation]];
    if ([operation parameters])
        [arguments addObjectsFromArray:[operation parameters]];
    if ([operation formula])
        [arguments addObject:[[operation formula] name]];
    
    // add a new task to the task array
    NSTask *currentTask = [[NSTask alloc] init];
    NSMutableDictionary *taskWithOperation = [NSMutableDictionary dictionary];
    [taskWithOperation setObject:currentTask forKey:MRBrewTaskIdentifier];
    [taskWithOperation setObject:operation forKey:MRBrewOperationIdentifier];
    
    [taskArrayLock lock];
    [taskArray addObject:taskWithOperation];
    [taskArrayLock unlock];

    // create a file handle for extracting task output
    NSPipe *outputPipe = [NSPipe pipe];
    NSFileHandle *readHandle = [outputPipe fileHandleForReading];
    
    // configure and launch a brew task instance
    [currentTask setLaunchPath:@"/usr/local/bin/brew"];
    [currentTask setArguments:arguments];
    [currentTask setStandardOutput:outputPipe];
    [currentTask launch];
    
    [backgroundQueue addOperationWithBlock:^{        
        NSData *readData;
        
        if ([[operation operation] isEqualToString:MRBrewOperationInstallIdentifier]) {
            // delegate callback for line output from brew
            if ([delegate respondsToSelector:@selector(brewOperation:didGenerateOutput:)]) {
                while ((readData = [readHandle availableData]) && [readData length] > 0) {
                    NSString *output = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
                    if (![output isEqualToString:@"\n"]) {                    
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [delegate brewOperation:operation didGenerateOutput:output];
                        }];
                    }
                }
            }

            [currentTask waitUntilExit];
        }
        else {
            NSData *data = [[outputPipe fileHandleForReading] readDataToEndOfFile];
            NSString *stringOutput = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            [currentTask waitUntilExit];
            
            if ([stringOutput length] > 0 && ![stringOutput isEqualToString:@"\n"]) {
                    if ([delegate respondsToSelector:@selector(brewOperation:didGenerateOutput:)]) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [delegate brewOperation:operation didGenerateOutput:stringOutput];
                    }];
                }
            }
        }
        
        if ([currentTask terminationStatus] == 0)
        {
            if ([delegate respondsToSelector:@selector(brewOperationDidFinish:)]) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [delegate brewOperationDidFinish:operation];
                }];
            }
        }
        else {
            NSInteger errorCode = [currentTask terminationStatus] == MRBrewErrorCancelled ? MRBrewErrorCancelled : MRBrewErrorUnknown;
            NSError *error = [NSError errorWithDomain:MRBrewErrorDomain code:errorCode userInfo:nil];
            
            if ([delegate respondsToSelector:@selector(brewOperation:didFailWithError:)]) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [delegate brewOperation:operation didFailWithError:error];
                }];
            }
        }

        [taskArrayLock lock];
        [taskArray removeObject:taskWithOperation];
        [taskArrayLock unlock];
    }];
}

+ (void)cancelAllOperations
{
    [taskArrayLock lock];
    
    if ([taskArray count] > 0) {
        for (NSDictionary *task in taskArray) {
            [[task objectForKey:MRBrewTaskIdentifier] interrupt];
        }
    }
    
    [taskArrayLock unlock];
}

+ (void)cancelOperation:(MRBrewOperation *)operation
{
    [taskArrayLock lock];
    
    if ([taskArray count] > 0) {
        for (NSDictionary *task in taskArray) {
            if ([[task objectForKey:MRBrewOperationIdentifier] isEqual:operation]) {
                [[task objectForKey:MRBrewTaskIdentifier] interrupt];
            }
        }
    }
    
    [taskArrayLock unlock];
}

+ (void)cancelAllOperationsOfType:(MRBrewOperationType)operationType
{
    [taskArrayLock lock];
    
    if ([taskArray count] > 0) {   
        NSString *operationString;
        switch (operationType) {
            case MRBrewOperationInfo:
                operationString = MRBrewOperationInfoIdentifier;
                break;
            case MRBrewOperationList:
                operationString = MRBrewOperationListIdentifier;
                break;
            case MRBrewOperationInstall:
                operationString = MRBrewOperationInstallIdentifier;
                break;
            case MRBrewOperationOptions:
                operationString = MRBrewOperationOptionsIdentifier;
                break;
            case MRBrewOperationRemove:
                operationString = MRBrewOperationRemoveIdentifier;
                break;
            case MRBrewOperationSearch:
                operationString = MRBrewOperationSearchIdentifier;
                break;
            case MRBrewOperationUpdate:
                operationString = MRBrewOperationUpdateIdentifier;
                break;
        }

        for (NSDictionary *task in taskArray) {
            if ([[[task objectForKey:MRBrewOperationIdentifier] operation] isEqualToString: operationString])
            [[task objectForKey:MRBrewTaskIdentifier] interrupt];
        }
    }
    
    [taskArrayLock unlock];
}

@end
