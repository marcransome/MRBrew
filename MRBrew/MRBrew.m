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
#import "MRBrewFormula.h"
#import "MRBrewConstants.h"
#import "MRBrewWorker.h"

#ifndef __has_feature
    #define __has_feature(x) 0 // for compatibility with non-clang compilers
#endif

#if !__has_feature(objc_arc)
    #error MRBrew must be built with ARC.
#endif

static NSString * MRDefaultBrewPath = @"/usr/local/bin/brew";

@interface MRBrew ()
{
    NSString *_brewPath;
    NSOperationQueue *_backgroundQueue;
}

@end

@implementation MRBrew

#pragma mark - Lifecycle

+ (instancetype)sharedBrew
{
    static MRBrew *brew = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        brew = [[MRBrew alloc] init];
    });
    
    return brew;
}

- (instancetype)init
{
    if (self = [super init]) {
        _backgroundQueue = [[NSOperationQueue alloc] init];
        _brewPath = MRDefaultBrewPath;
    }
    
    return self;
}

#pragma mark - Brew Path

- (NSString *)brewPath
{
    return _brewPath;
}

- (void)setBrewPath:(NSString *)path
{
    if (path)
        _brewPath = [path copy];
    else
        _brewPath = @"/usr/local/bin/brew";
}

#pragma mark - Operation Methods

- (void)performOperation:(MRBrewOperation *)operation delegate:(id<MRBrewDelegate>)delegate
{    
    // construct command-line arguments for brew command
    NSMutableArray *arguments = [NSMutableArray array];
    if ([operation name])
        [arguments addObject:[operation name]];
    if ([operation parameters])
        [arguments addObjectsFromArray:[operation parameters]];
    if ([operation formula])
        [arguments addObject:[[operation formula] name]];
    
    MRBrewWorker *worker = [[MRBrewWorker alloc] init];
    [worker setArguments:arguments];
    [worker setOperation:operation];
    [worker setDelegate:delegate];
    [_backgroundQueue addOperation:worker];
}

- (void)cancelAllOperations
{
    [_backgroundQueue cancelAllOperations];
}

- (void)cancelOperation:(MRBrewOperation *)operation
{
    for (MRBrewWorker *worker in [_backgroundQueue operations]) {
        if ([[worker operation] isEqualToOperation:operation]) {
            [worker cancel];
            break;
        }
    }
}

- (void)cancelAllOperationsOfType:(MRBrewOperationType)type
{
    if ([_backgroundQueue operationCount] > 0) {
        NSString *operationName;
        switch (type) {
            case MRBrewOperationInfo:
                operationName = MRBrewOperationInfoIdentifier;
                break;
            case MRBrewOperationList:
                operationName = MRBrewOperationListIdentifier;
                break;
            case MRBrewOperationInstall:
                operationName = MRBrewOperationInstallIdentifier;
                break;
            case MRBrewOperationOptions:
                operationName = MRBrewOperationOptionsIdentifier;
                break;
            case MRBrewOperationRemove:
                operationName = MRBrewOperationRemoveIdentifier;
                break;
            case MRBrewOperationSearch:
                operationName = MRBrewOperationSearchIdentifier;
                break;
            case MRBrewOperationUpdate:
                operationName = MRBrewOperationUpdateIdentifier;
                break;
            case MRBrewOperationOutdated:
                operationName = MRBrewOperationOutdatedIdentifier;
                break;
        }
        
        for (MRBrewWorker *worker in [_backgroundQueue operations]) {
            if ([[[worker operation] name] isEqualToString:operationName]) {
                [worker cancel];
            }
        }
    }
}

- (void)setConcurrentOperations:(BOOL)concurrency
{
    if (concurrency) {
        [_backgroundQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    }
    else {
        [_backgroundQueue setMaxConcurrentOperationCount:1];
    }
}

- (NSUInteger)operationCount
{
    return [_backgroundQueue operationCount];
}

@end
