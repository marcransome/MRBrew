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
#import "MRBrewDelegate.h"

@interface MRBrewWorkerTests : XCTestCase <MRBrewDelegate> {
    BOOL _delegateReceivedDidFinishCallback;
    BOOL _delegateReceivedDidFailWithErrorCallback;
    BOOL _delegateReceivedDidGenerateOutputCallback;
}

@end

@implementation MRBrewWorkerTests

- (void)setUp
{
    [super setUp];
    _delegateReceivedDidFinishCallback = NO;
    _delegateReceivedDidFailWithErrorCallback = NO;
    _delegateReceivedDidGenerateOutputCallback = NO;
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
    id fakeTask = [OCMockObject mockForClass:[NSTask class]];
    [[[fakeTask stub] andReturnValue:OCMOCK_VALUE(0)] terminationStatus];
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
    XCTAssertTrue(_delegateReceivedDidFinishCallback, @"Delegate should receive brewOperationDidFinish: callback when task termination status is 0.");
    XCTAssertFalse(_delegateReceivedDidFailWithErrorCallback, @"Delegate should not receive brewOperation:didFailWithError: callback when task termination status is 0.");
}

- (void)testDelegateReceivesFailedWithErrorCallbackWhenTaskTerminatesAbnormally
{
    // setup
    MRBrewWorker *worker = [[MRBrewWorker alloc] init];
    id fakeTask = [OCMockObject mockForClass:[NSTask class]];
    [[[fakeTask stub] andReturnValue:OCMOCK_VALUE(99)] terminationStatus];
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
    XCTAssertTrue(_delegateReceivedDidFailWithErrorCallback, @"Delegate should receive brewOperation:didFailWithError: callback when task termination status is 0.");
    XCTAssertFalse(_delegateReceivedDidFinishCallback, @"Delegate should not receive brewOperationDidFinish: callback when task termination status is 0.");
    XCTAssertFalse(_delegateReceivedDidFinishCallback, @"Delegate should receive brewOperationDidFinish: callback when task termination status is 0.");
}

- (void)brewOperationDidFinish:(MRBrewOperation *)operation
{
    _delegateReceivedDidFinishCallback = YES;
}

- (void)brewOperation:(MRBrewOperation *)operation didFailWithError:(NSError *)error
{
    _delegateReceivedDidFailWithErrorCallback = YES;
}

- (void)brewOperation:(MRBrewOperation *)operation didGenerateOutput:(NSString *)output
{
    _delegateReceivedDidGenerateOutputCallback = YES;
}

@end
