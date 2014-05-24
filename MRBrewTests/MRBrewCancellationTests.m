//
//  MRBrewCancellationTests.m
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
#import "MRBrewOperation.h"
#import "MRBrewConstants.h"
#import "MRBrewWorker.h"
#import "MRBrew.h"
#import "MRBrew+Private.h"

@interface MRBrewCancellationTests : XCTestCase {
    NSMutableArray *_mockWorkers;
    NSArray *_operationIdentifiers;
}

@end

@implementation MRBrewCancellationTests

- (void)setUp
{
    [super setUp];

    _operationIdentifiers = @[MRBrewOperationInfoIdentifier,
                              MRBrewOperationListIdentifier,
                              MRBrewOperationInstallIdentifier,
                              MRBrewOperationOptionsIdentifier,
                              MRBrewOperationOutdatedIdentifier,
                              MRBrewOperationRemoveIdentifier,
                              MRBrewOperationSearchIdentifier,
                              MRBrewOperationUpdateIdentifier];
}

- (void)tearDown
{
   [_mockWorkers removeAllObjects];
   _mockWorkers = nil;
    
    [super tearDown];
}

- (void)createMockWorkersWithSingleMatchingOperation:(NSString *)matchingIdentifier
{
    // create mock operation objects for each identifier
    NSMutableArray *mockOperations = [NSMutableArray array];
    for (NSString *identifier in _operationIdentifiers) {
        
        // the mock operation object whose -name property equals the matchingIdentifier
        // parameter should return YES to isEqualToOperation:, identifying itself as
        // the only object that should be cancelled, all other objects return NO
        BOOL returnValue = (identifier == matchingIdentifier);
        
        id mockOperation = [OCMockObject mockForClass:[MRBrewOperation class]];
        [[[mockOperation stub] andReturn:identifier] name];
        [[[mockOperation stub] andReturnValue:OCMOCK_VALUE(returnValue)] isEqualToOperation:[OCMArg any]];
        [mockOperations addObject:mockOperation];
    }
    
    // create mock worker objects for each operation object
    _mockWorkers = [NSMutableArray array];
    for (id operation in mockOperations) {
        id mockWorker = [OCMockObject mockForClass:[MRBrewWorker class]];
        [[[mockWorker stub] andReturn:operation] operation];
        
        // -cancel should only be called on the worker whose operation object
        // has a name property equal to the matchingIdentifier parameter -- this
        // is the operation we expect to be cancelled
        if ([[mockWorker operation] name] == matchingIdentifier) {
            [[mockWorker expect] cancel];
        }
        
        [_mockWorkers addObject:mockWorker];
    }
}

// here we ensure that our helper method for creating mock worker objects does
// indeed create the correct number of objects, this is crucial as the for loop
// in each remaining test will otherwise iterate 'nil' and cause the tests to pass
- (void)testmockWorkerCreation
{
    // execute
    [self createMockWorkersWithSingleMatchingOperation:MRBrewOperationInfoIdentifier];
    
    // verify
    XCTAssertTrue([_mockWorkers count] == [_operationIdentifiers count], @"The number of mock worker objects should equal the number of identifiers.");
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyInfoOperations
{
    // setup
    [self createMockWorkersWithSingleMatchingOperation:MRBrewOperationInfoIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_mockWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_mockWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationInfo];
    
    // verify
    for (id worker in _mockWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyListOperations
{
    // setup
    [self createMockWorkersWithSingleMatchingOperation:MRBrewOperationListIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_mockWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_mockWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationList];
    
    // verify
    for (id worker in _mockWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyInstallOperations
{
    // setup
    [self createMockWorkersWithSingleMatchingOperation:MRBrewOperationInstallIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_mockWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_mockWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationInstall];
    
    // verify
    for (id worker in _mockWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyOptionsOperations
{
    // setup
    [self createMockWorkersWithSingleMatchingOperation:MRBrewOperationOptionsIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_mockWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_mockWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationOptions];
    
    // verify
    for (id worker in _mockWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyOutdatedOperations
{
    // setup
    [self createMockWorkersWithSingleMatchingOperation:MRBrewOperationOutdatedIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_mockWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_mockWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationOutdated];
    
    // verify
    for (id worker in _mockWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyRemoveOperations
{
    // setup
    [self createMockWorkersWithSingleMatchingOperation:MRBrewOperationRemoveIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_mockWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_mockWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationRemove];
    
    // verify
    for (id worker in _mockWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlySearchOperations
{
    // setup
    [self createMockWorkersWithSingleMatchingOperation:MRBrewOperationSearchIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_mockWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_mockWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationSearch];
    
    // verify
    for (id worker in _mockWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyUpdateOperations
{
    // setup
    [self createMockWorkersWithSingleMatchingOperation:MRBrewOperationUpdateIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_mockWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_mockWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationUpdate];
    
    // verify
    for (id worker in _mockWorkers) {
        [worker verify];
    }
}

@end
