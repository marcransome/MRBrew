//
//  MRBrewWorker.m
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

#import "MRBrewWorker.h"
#import "MRBrew.h"
#import "MRBrewOperation.h"
#import "MRBrewConstants.h"
#import "MRBrewDelegate.h"

static NSString* const MRBrewErrorDomain = @"uk.co.fidgetbox.MRBrew";

@interface  MRBrewWorker ()
{
    NSTask *_task;
    BOOL _executing;
    BOOL _finished;
    BOOL _taskExited;
    BOOL _waitingForTaskToExit;
}

@end

@implementation MRBrewWorker

- (id)init
{
    if (self = [super init]) {
        _task = [[NSTask alloc] init];
    }
    
    return self;
}

- (void)start
{
    if ([self isCancelled]) {
        [self changeFinishedState:YES];
        return;
    }
    
    [self changeExecutingState:YES];
    
    // configure and launch a brew task instance
    [_task setLaunchPath:[MRBrew brewPath]];
    [_task setArguments:_arguments];
    [_task setStandardOutput:[NSPipe pipe]];
    
    // register for task termination notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskExited:) name:NSTaskDidTerminateNotification object:_task];

    // read handler for asynchronous brew output
    [[[_task standardOutput] fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([_delegate respondsToSelector:@selector(brewOperation:didGenerateOutput:)]) {
            if (![output isEqualToString:@"\n"]) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [_delegate brewOperation:_operation didGenerateOutput:output];
                }];
            }
        }
    }];
    
    [_task launch];
    
    // spin run loop periodically while operation is alive, allowing for task
    // termination notification, and test for cancellation
    while (!self.isFinished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        
        if ([self isCancelled] && !_waitingForTaskToExit) {
            _waitingForTaskToExit = YES;
            [_task interrupt];
        }
    }
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return _executing;
}

- (BOOL)isFinished
{
    return _finished;
}

- (void)changeFinishedState:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)changeExecutingState:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)taskExited:(NSNotification *)notification
{
    NSUInteger cancelledOperation = 130;
    
    if ([_task terminationStatus] == 0)
    {
        // delegate callback for operation completion
        if ([_delegate respondsToSelector:@selector(brewOperationDidFinish:)]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [_delegate brewOperationDidFinish:_operation];
            }];
        }
    }
    else if ([_task terminationStatus] != cancelledOperation) {
        // delegate callback for operation failure
        NSInteger errorCode = MRBrewErrorUnknown;
        NSError *error = [NSError errorWithDomain:MRBrewErrorDomain code:errorCode userInfo:nil];
        if ([_delegate respondsToSelector:@selector(brewOperation:didFailWithError:)]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [_delegate brewOperation:_operation didFailWithError:error];
            }];
        }
    }

    // stop reading and cleanup file handle's structures
    [[[_task standardOutput] fileHandleForReading] setReadabilityHandler:nil];
    
    // update operation state
    [self changeExecutingState:NO];
    [self changeFinishedState:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSTaskDidTerminateNotification object:_task];
}

@end
