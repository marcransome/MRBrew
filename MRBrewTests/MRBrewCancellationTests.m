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
    NSMutableArray *_fakeWorkers;
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
   [_fakeWorkers removeAllObjects];
   _fakeWorkers = nil;
    
    [super tearDown];
}

- (void)createFakeWorkersWithSingleMatchingOperation:(NSString *)matchingIdentifier
{
    // create fake operation objects for each identifier
    NSMutableArray *fakeOperations = [NSMutableArray array];
    for (NSString *identifier in _operationIdentifiers) {
        
        // the fake operation object whose -name property equals the matchingIdentifier
        // parameter should return YES to isEqualToOperation:, identifying itself as
        // the only object that should be cancelled, all other objects return NO
        BOOL returnValue = (identifier == matchingIdentifier);
        
        id fakeOperation = [OCMockObject mockForClass:[MRBrewOperation class]];
        [[[fakeOperation stub] andReturn:identifier] name];
        [[[fakeOperation stub] andReturnValue:OCMOCK_VALUE(returnValue)] isEqualToOperation:[OCMArg any]];
        [fakeOperations addObject:fakeOperation];
    }
    
    // create fake worker objects for each operation object
    _fakeWorkers = [NSMutableArray array];
    for (id operation in fakeOperations) {
        id fakeWorker = [OCMockObject mockForClass:[MRBrewWorker class]];
        [[[fakeWorker stub] andReturn:operation] operation];
        
        // -cancel should only be called on the worker whose operation object
        // has a name property equal to the matchingIdentifier parameter -- this
        // is the operation we expect to be cancelled
        if ([[fakeWorker operation] name] == matchingIdentifier) {
            [[fakeWorker expect] cancel];
        }
        
        [_fakeWorkers addObject:fakeWorker];
    }
}

// here we ensure that our helper method for creating fake worker objects does
// indeed create the correct number of objects, this is crucial as the for loop
// in each remaining test will otherwise iterate 'nil' and cause the tests to pass
- (void)testFakeWorkerCreation
{
    // execute
    [self createFakeWorkersWithSingleMatchingOperation:MRBrewOperationInfoIdentifier];
    
    // verify
    XCTAssertTrue([_fakeWorkers count] == [_operationIdentifiers count], @"The number of fake worker objects should equal the number of identifiers.");
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyInfoOperations
{
    // setup
    [self createFakeWorkersWithSingleMatchingOperation:MRBrewOperationInfoIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_fakeWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_fakeWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationInfo];
    
    // verify
    for (id worker in _fakeWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyListOperations
{
    // setup
    [self createFakeWorkersWithSingleMatchingOperation:MRBrewOperationListIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_fakeWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_fakeWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationList];
    
    // verify
    for (id worker in _fakeWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyInstallOperations
{
    // setup
    [self createFakeWorkersWithSingleMatchingOperation:MRBrewOperationInstallIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_fakeWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_fakeWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationInstall];
    
    // verify
    for (id worker in _fakeWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyOptionsOperations
{
    // setup
    [self createFakeWorkersWithSingleMatchingOperation:MRBrewOperationOptionsIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_fakeWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_fakeWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationOptions];
    
    // verify
    for (id worker in _fakeWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyOutdatedOperations
{
    // setup
    [self createFakeWorkersWithSingleMatchingOperation:MRBrewOperationOutdatedIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_fakeWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_fakeWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationOutdated];
    
    // verify
    for (id worker in _fakeWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyRemoveOperations
{
    // setup
    [self createFakeWorkersWithSingleMatchingOperation:MRBrewOperationRemoveIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_fakeWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_fakeWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationRemove];
    
    // verify
    for (id worker in _fakeWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlySearchOperations
{
    // setup
    [self createFakeWorkersWithSingleMatchingOperation:MRBrewOperationSearchIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_fakeWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_fakeWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationSearch];
    
    // verify
    for (id worker in _fakeWorkers) {
        [worker verify];
    }
}

- (void)testCancelAllOperationsOfTypeCancelsOnlyUpdateOperations
{
    // setup
    [self createFakeWorkersWithSingleMatchingOperation:MRBrewOperationUpdateIdentifier];
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[[queue stub] andReturn:_fakeWorkers] operations];
    [[[queue stub] andReturnValue:OCMOCK_VALUE([_fakeWorkers count])] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    // execute
    [[MRBrew sharedBrew] cancelAllOperationsOfType:MRBrewOperationUpdate];
    
    // verify
    for (id worker in _fakeWorkers) {
        [worker verify];
    }
}

@end
