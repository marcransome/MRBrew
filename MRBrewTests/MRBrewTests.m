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
    MRBrew *brew = [MRBrew sharedBrew];
    XCTAssertNotNil(brew, @"Should not return nil.");
}

- (void)testSharedBrewReturnsSameInstance
{
    MRBrew *brew1 = [MRBrew sharedBrew];
    MRBrew *brew2 = [MRBrew sharedBrew];
    XCTAssertEqualObjects(brew1, brew2, @"Should return the same instance.");
}

#pragma mark - Brew Path Tests

- (void)testDefaultBrewPath
{
    NSString *brewPath = [[MRBrew sharedBrew] brewPath];
    XCTAssertTrue([brewPath isEqualToString:MRBrewTestsDefaultBrewPath], @"Should equal default brew path.");
}

- (void)testBrewPathWhenSetToNil
{
    [[MRBrew sharedBrew] setBrewPath:nil];
    XCTAssertTrue([[[MRBrew sharedBrew] brewPath] isEqualToString:MRBrewTestsDefaultBrewPath], @"Should equal default brew path.");
    
    [[MRBrew sharedBrew] setBrewPath:MRBrewTestsDefaultBrewPath];
}

- (void)testSetBrewPath
{
    NSString *testPath = @"/test/path";
    [[MRBrew sharedBrew] setBrewPath:testPath];
    XCTAssertTrue([[[MRBrew sharedBrew] brewPath] isEqualToString:testPath], @"Should equal new brew path %@.", testPath);
    
    [[MRBrew sharedBrew] setBrewPath:MRBrewTestsDefaultBrewPath];
}

- (void)testCancellingAllOperations
{
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[queue expect] cancelAllOperations];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    [[MRBrew sharedBrew] cancelAllOperations];
    
    [queue verify];
}

- (void)testOperationCount
{
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[queue expect] operationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    [[MRBrew sharedBrew] operationCount];
    
    [queue verify];
}

- (void)testSetConcurrentOperationsWillSetBackgroundQueueToMaxConcurrentOperationCount
{
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[queue expect] setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    [[MRBrew sharedBrew] setConcurrentOperations:YES];
    
    [queue verify];
}

- (void)testSetConcurrentOperationsWillSetBackgroundQueueToMaxOfOneOperation
{
    id queue = [OCMockObject mockForClass:[NSOperationQueue class]];
    [[queue expect] setMaxConcurrentOperationCount:1];
    [[MRBrew sharedBrew] setBackgroundQueue:queue];
    
    [[MRBrew sharedBrew] setConcurrentOperations:NO];
    
    [queue verify];
}

- (void)testPerformOperationDelegateAddsWorkerToQueue
{
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
    
    [[MRBrew sharedBrew] performOperation:operation delegate:nil];
    
    [queue verify];
}

@end
