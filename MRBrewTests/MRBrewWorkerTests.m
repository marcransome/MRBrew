//
//  MRBrewWorkerTests.m
//  MRBrew
//
//  Copyright (c) 2014 Marc Ransome <marc.ransome@fidgetbox.co.uk>
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

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MRBrewWorker.h"
#import "MRBrewWorker+Private.h"
#import "MRBrew.h"
#import "MRBrewDelegate.h"
#import "MRBrewWorkerTaskConstants.h"

@interface MRBrewWorkerTests : XCTestCase <MRBrewDelegate> {
    BOOL _delegateReceivedDidFinishCallback;
    BOOL _delegateReceivedDidFailWithErrorCallback;
    NSInteger _delegateReceivedErrorCode;
    MRBrewOperation *_delegateReceivedOperation;
}

@end

@implementation MRBrewWorkerTests

- (void)setUp
{
    [super setUp];
    _delegateReceivedDidFinishCallback = NO;
    _delegateReceivedDidFailWithErrorCallback = NO;
    _delegateReceivedErrorCode = MRBrewErrorNone;
    _delegateReceivedOperation = nil;
    
    [[MRBrew sharedBrew] setEnvironment:nil];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDelegateReceivesFinishCallbackWhenTaskTerminatesNormally
{
    // setup
    MRBrewWorker *worker = [[MRBrewWorker alloc] init];
    
    id fakeOperation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[fakeOperation stub] andReturn:fakeOperation] copyWithZone:[OCMArg anyPointer]];
    [worker setOperation:fakeOperation];
    
    id fakeTask = [OCMockObject mockForClass:[NSTask class]];
    [[[fakeTask stub] andReturnValue:OCMOCK_VALUE(MRBrewWorkerTaskExitedNormally)] terminationStatus];
    [[[fakeTask stub] andReturn:nil] standardOutput];
    [worker setTask:fakeTask];
    [worker setDelegate:self];
    
    NSDate *callbackTimeout = [NSDate dateWithTimeIntervalSinceNow:5];
    
    // execute
    [NSThread detachNewThreadSelector:@selector(taskExited:) toTarget:worker withObject:nil];
    
    while (!_delegateReceivedDidFinishCallback && [callbackTimeout timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    }
    
    // verify
    XCTAssertTrue(_delegateReceivedDidFinishCallback, @"Delegate should receive brewOperationDidFinish: callback when task termination status signals success.");
    XCTAssertEqual(_delegateReceivedOperation, fakeOperation, @"Delegate should receive reference to operation object held by worker instance.");
}

- (void)testDelegateReceivesFailedWithErrorCallbackWhenTaskTerminatesAbnormally
{
    // setup
    int unknownExitStatus = 99;
    MRBrewWorker *worker = [[MRBrewWorker alloc] init];
    
    id fakeOperation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[fakeOperation stub] andReturn:fakeOperation] copyWithZone:[OCMArg anyPointer]];
    [worker setOperation:fakeOperation];
    
    id fakeTask = [OCMockObject mockForClass:[NSTask class]];
    [[[fakeTask stub] andReturnValue:OCMOCK_VALUE(unknownExitStatus)] terminationStatus];
    [[[fakeTask stub] andReturn:nil] standardOutput];
    [worker setTask:fakeTask];
    [worker setDelegate:self];
    
    NSDate *callbackTimeout = [NSDate dateWithTimeIntervalSinceNow:5];
    
    // execute
    [NSThread detachNewThreadSelector:@selector(taskExited:) toTarget:worker withObject:nil];
    
    while (!_delegateReceivedDidFailWithErrorCallback && [callbackTimeout timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    }
    
    // verify
    XCTAssertTrue(_delegateReceivedDidFailWithErrorCallback, @"Delegate should receive brewOperation:didFailWithError: callback when task terminates with unknown status code.");
    XCTAssertTrue(_delegateReceivedErrorCode == MRBrewErrorUnknown, @"Delegate should received correct error code when task exits for unknown reason.");
    XCTAssertEqual(_delegateReceivedOperation, fakeOperation, @"Delegate should receive reference to operation object held by worker instance.");
}

- (void)testDelegateReceivesFailedWithErrorCallbackWhenTaskIsCancelled
{
    // setup
    MRBrewWorker *worker = [[MRBrewWorker alloc] init];
    
    id fakeOperation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[fakeOperation stub] andReturn:fakeOperation] copyWithZone:[OCMArg anyPointer]];
    [worker setOperation:fakeOperation];
    
    id fakeTask = [OCMockObject mockForClass:[NSTask class]];
    [[[fakeTask stub] andReturnValue:OCMOCK_VALUE(MRBrewWorkerTaskCancelled)] terminationStatus];
    [[[fakeTask stub] andReturn:nil] standardOutput];
    [worker setTask:fakeTask];
    [worker setDelegate:self];
    
    NSDate *callbackTimeout = [NSDate dateWithTimeIntervalSinceNow:5];
    
    // execute
    [NSThread detachNewThreadSelector:@selector(taskExited:) toTarget:worker withObject:nil];
    
    while (!_delegateReceivedDidFailWithErrorCallback && [callbackTimeout timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    }
    
    // verify
    XCTAssertTrue(_delegateReceivedDidFailWithErrorCallback, @"Delegate should receive brewOperation:didFailWithError: callback when task terminates after manual cancellation.");
    XCTAssertTrue(_delegateReceivedErrorCode == MRBrewErrorOperationCancelled, @"Delegate should received correct error code when manually cancelled.");
    XCTAssertEqual(_delegateReceivedOperation, fakeOperation, @"Delegate should receive reference to operation object held by worker instance.");
}

- (void)testWorkerReturnsFastIfCancelledLeavingTaskUntouched
{
    // setup
    id fakeTask = [OCMockObject mockForClass:[NSTask class]];
    MRBrewWorker *worker = [[MRBrewWorker alloc] init];
    [worker setTask:fakeTask];
    [worker cancel];
    
    // throw exception to avoid endless loop while spinning runloop for task termination notification
    [[[fakeTask stub] andThrow:[NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil]] launch];
    
    // execute
    [worker start];
    
    // verify
    [fakeTask verify];
}

- (void)testTaskEnvironmentIsSetupCorrectly
{
    // setup
    NSArray *arguments = @[@"arg1", @"arg2"];
    MRBrewWorker *worker = [[MRBrewWorker alloc] init];
    [worker setArguments:arguments];
    
    id fakeTask = [OCMockObject niceMockForClass:[NSTask class]];
    [[fakeTask expect] setLaunchPath:[[MRBrew sharedBrew] brewPath]];
    [[fakeTask expect] setArguments:arguments];
    [[fakeTask expect] setStandardOutput:[OCMArg any]];
    
    [worker setTask:fakeTask];
    
    // throw exception to avoid endless loop while spinning runloop for task termination notification
    [[[fakeTask stub] andThrow:[NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil]] launch];
    
    // execute
    [worker start];
    
    // verify
    [fakeTask verify];
}

- (void)testTaskEnvironmentIsSetIfBrewEnvironmentIsSet
{
    // setup
    NSDictionary *environment = @{@"key": @"object"};
    
    id fakeTask = [OCMockObject niceMockForClass:[NSTask class]];
    [[fakeTask expect] setEnvironment:environment];
    
    // throw exception to avoid endless loop while spinning runloop for task termination notification
    [[[fakeTask stub] andThrow:[NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil]] launch];

    MRBrewWorker *worker = [[MRBrewWorker alloc] init];
    [worker setTask:fakeTask];
    
    [[MRBrew sharedBrew] setEnvironment:environment];
    
    // execute
    [worker start];

    // verify
    [fakeTask verify];
}

- (void)testTaskEnvironmentIsNotSetIfBrewEnvironmentIsNotSet
{
    // setup
    id fakeTask = [OCMockObject niceMockForClass:[NSTask class]];
    [[fakeTask reject] setEnvironment:[OCMArg any]];
    
    // throw exception to avoid endless loop while spinning runloop for task termination notification
    [[[fakeTask stub] andThrow:[NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil]] launch];
    
    MRBrewWorker *worker = [[MRBrewWorker alloc] init];
    [worker setTask:fakeTask];
    
    // execute
    [worker start];
    
    // verify
    [fakeTask verify];
}

- (void)testBrewWorkerWillExecuteAsynchronouslyForCurrentThread
{
    // setup
    MRBrewWorker *worker = [[MRBrewWorker alloc] init];
    
    // verify
    XCTAssertTrue([worker isConcurrent], @"Should return true, indicating asynchronous execution with respect to current thread.");
}

// MRBrewDelegate methods
- (void)brewOperationDidFinish:(MRBrewOperation *)operation
{
    _delegateReceivedDidFinishCallback = YES;
    _delegateReceivedOperation = operation;
}

- (void)brewOperation:(MRBrewOperation *)operation didFailWithError:(NSError *)error
{
    _delegateReceivedDidFailWithErrorCallback = YES;
    _delegateReceivedErrorCode = [error code];
    _delegateReceivedOperation = operation;
}

- (void)brewOperation:(MRBrewOperation *)operation didGenerateOutput:(NSString *)output
{
    _delegateReceivedOperation = operation;
}

@end
