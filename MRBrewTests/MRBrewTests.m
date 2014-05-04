//
//  MRBrewTests.m
//  MRBrewTests
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

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MRBrew.h"
#import "MRBrew+Private.h"
#import "MRBrewWorker.h"
#import "MRBrewFormula.h"
#import "MRBrewOperation.h"
#import "MRBrewConstants.h"

@interface MRBrewTests : XCTestCase

@end

@implementation MRBrewTests

static NSString * const MRBrewTestsDefaultBrewPath = @"/usr/local/bin/brew";

#pragma mark - Setup

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

#pragma mark - Initialisation

- (void)testSharedBrewNotNil
{
    // execute
    MRBrew *brew = [MRBrew sharedBrew];
    
    // verify
    XCTAssertNotNil(brew, @"Should not return nil.");
}

- (void)testSharedBrewReturnsSameInstance
{
    // execute
    MRBrew *brew1 = [MRBrew sharedBrew];
    MRBrew *brew2 = [MRBrew sharedBrew];
    
    // verify
    XCTAssertEqualObjects(brew1, brew2, @"Should return the same instance.");
}

#pragma mark - Brew Path Tests

- (void)testDefaultBrewPath
{
    // execute
    NSString *brewPath = [[MRBrew sharedBrew] brewPath];
    
    // verify
    XCTAssertTrue([brewPath isEqualToString:MRBrewTestsDefaultBrewPath], @"Should equal default brew path.");
}

- (void)testBrewPathWhenSetToNil
{
    // execute
    [[MRBrew sharedBrew] setBrewPath:nil];
    
    // verify
    XCTAssertTrue([[[MRBrew sharedBrew] brewPath] isEqualToString:MRBrewTestsDefaultBrewPath], @"Should equal default brew path.");
    
    // cleanup
    [[MRBrew sharedBrew] setBrewPath:MRBrewTestsDefaultBrewPath];
}

- (void)testSetBrewPath
{
    // setup
    NSString *testPath = @"/test/path";
    
    // execute
    [[MRBrew sharedBrew] setBrewPath:testPath];
    
    // verify
    XCTAssertTrue([[[MRBrew sharedBrew] brewPath] isEqualToString:testPath], @"Should equal new brew path %@.", testPath);
    
    // cleanup
    [[MRBrew sharedBrew] setBrewPath:MRBrewTestsDefaultBrewPath];
}

- (void)testCancelAllOperationsWillCancelAllWorkersInBackgroundQueue
{
    // setup
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[queue expect] cancelAllOperations];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperations];
    
    // verify
    [queue verify];
}

- (void)testCancelOperationWillCancelAssociatedWorkerInBackgroundQueue
{
    // setup
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturnValue:@YES] isEqualToOperation:[OCMArg any]];
    
    id worker = [OCMockObject mockForClass:[MRBrewWorker class]];
    [[[worker stub] andReturn:operation] operation];
    [[worker expect] cancel];
    
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:@[worker]] operations];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelOperation:operation];
    
    // verify
    [worker verify];
}

- (void)testCancelOperationWillNotCancelUnrelatedWorkerInBackgroundQueue
{
    // setup
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturnValue:@NO] isEqualToOperation:[OCMArg any]];
    
    id worker = [OCMockObject mockForClass:[MRBrewWorker class]];
    [[[worker stub] andReturn:operation] operation];
    
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:@[worker]] operations];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelOperation:operation];
    
    // verify
    [worker verify];
}

- (void)testOperationCountReturnsExpectedCount
{
    // setup
    NSUInteger fakeCount = 2;
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturnValue:OCMOCK_VALUE(fakeCount)] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    NSUInteger operationCount = [[MRBrew sharedBrew] operationCount];
    
    // verify
    XCTAssertTrue(operationCount == fakeCount, @"Should return the count of operations currently in the queue.");
}

- (void)testOperationCountQueriesCountOfOperationQueue
{
    // setup
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[queue expect] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] operationCount];
    
    // verify
    [queue verify];
}

- (void)testSetConcurrentOperationsWillSetBackgroundQueueToMaxConcurrentOperationCount
{
    // setup
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[queue expect] setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] setConcurrentOperations:YES];
    
    // verify
    [queue verify];
}

- (void)testSetConcurrentOperationsWillSetBackgroundQueueToMaxOfOneOperation
{
    // setup
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[queue expect] setMaxConcurrentOperationCount:1];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] setConcurrentOperations:NO];
    
    // verify
    [queue verify];
}

- (void)testPerformOperationDelegateAddsWorkerToQueue
{
    // setup
    id formula = [OCMockObject mockForClass:[MRBrewFormula class]];
    [[[formula stub] andReturn:@"formula-name"] name];
    [[[formula stub] andReturn:formula] copyWithZone:[OCMArg anyPointer]];
    
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationSearchIdentifier] name];
    [[[operation stub] andReturn:@[]] parameters];
    [[[operation stub] andReturn:formula] formula];
    [[[operation stub] andReturn:operation] copyWithZone:[OCMArg anyPointer]];
    
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[queue expect] addOperation:[OCMArg any]];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] performOperation:operation delegate:nil];
    
    // verify
    [queue verify];
}

- (void)testEnvironmentVariablesAreRetained
{
    // setup
    NSDictionary *environment = @{@"test_variable":@"test_value", @"test_variable2":@"test_value2"};
    
    // execute
    [[MRBrew sharedBrew] setEnvironment:environment];
    
    // verify
    XCTAssertEqual([[MRBrew sharedBrew] environment], environment, @"Should return a dictionary equal to that which was previously set.");
    
    // cleanup
    [[MRBrew sharedBrew] setEnvironment:nil];
}

@end
