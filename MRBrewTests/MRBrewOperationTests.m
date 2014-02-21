//
//  MRBrewOperationTests.m
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

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MRBrewOperation.h"
#import "MRBrewFormula.h"

@interface MRBrewOperationTests : XCTestCase
{
    id _stubFormulaNeverEqualToItself;
    id _stubFormulaAlwaysEqualToItself;
}
@end

@implementation MRBrewOperationTests

#pragma mark - Setup

- (void)setUp
{
    [super setUp];
    
    _stubFormulaNeverEqualToItself = [OCMockObject mockForClass:[MRBrewFormula class]];
    [[[_stubFormulaNeverEqualToItself stub] andReturnValue:@NO] isEqualToFormula:[OCMArg any]];
    [[[_stubFormulaNeverEqualToItself stub] andReturn:_stubFormulaNeverEqualToItself] copy];
    
    _stubFormulaAlwaysEqualToItself = [OCMockObject mockForClass:[MRBrewFormula class]];
    [[[_stubFormulaAlwaysEqualToItself stub] andReturnValue:@YES] isEqualToFormula:[OCMArg any]];
    [[[_stubFormulaAlwaysEqualToItself stub] andReturn:_stubFormulaAlwaysEqualToItself] copy];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

#pragma mark - Equality Tests

- (void)testSingleOperationEquality
{
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation" formula:nil parameters:@[]];
    
    XCTAssertTrue([operation isEqualToOperation:operation], @"Comparison of a operation with itself should be equal.");
}

- (void)testIdenticalOperationsEquality
{
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:_stubFormulaAlwaysEqualToItself parameters:@[]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation" formula:_stubFormulaAlwaysEqualToItself parameters:@[]];
    
    XCTAssertTrue([operation1 isEqualToOperation:operation2], @"Operations that have the same properties should be equal.");
}

- (void)testDifferentOperationsEqualityForNameProperty
{
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:_stubFormulaAlwaysEqualToItself parameters:@[]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"different" formula:_stubFormulaAlwaysEqualToItself parameters:@[]];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations with different name property should not be equal.");
}

- (void)testDifferentOperationsEqualityForFormulaProperty
{
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:_stubFormulaNeverEqualToItself parameters:@[]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation" formula:_stubFormulaNeverEqualToItself parameters:@[]];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations with different formula property should not be equal.");
}

- (void)testDifferentOperationsEqualityForFormulaPropertyOneNilValue
{
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:_stubFormulaAlwaysEqualToItself parameters:@[]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation" formula:nil parameters:@[]];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations with different formula property should not be equal.");
}

- (void)testDifferentOperationsEqualityForParametersProperty
{
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:_stubFormulaAlwaysEqualToItself parameters:@[]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation" formula:_stubFormulaAlwaysEqualToItself parameters:@[@"different"]];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations with different parameters property should not be equal.");
}

- (void)testDifferentOperationsEqualityForParametersPropertyOneNilValue
{
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:_stubFormulaAlwaysEqualToItself parameters:@[]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation" formula:_stubFormulaAlwaysEqualToItself parameters:nil];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations with different parameters property should not be equal.");
}

- (void)testOperationForEqualityWithNil
{
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation" formula:nil parameters:nil];
    
    XCTAssertFalse([operation isEqualToOperation:nil], @"Operations can never be equal to nil.");
}

- (void)testOperationForEqualityWithObjectOfAnotherClass
{
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation" formula:nil parameters:nil];
    id string = @"string";
    
    XCTAssertFalse([operation isEqualToOperation:string], @"Operations can never be equal to objects of another class.");
}

#pragma mark - Description

- (void)testOperationDescriptionWithFormulaAndParameters
{
    id formula = [OCMockObject mockForClass:[MRBrewFormula class]];
    [[[formula stub] andReturn:@"formula-name"] name];
    [[[formula stub] andReturn:formula] copy];
    
    NSArray *parameters = @[@"param-one", @"param-two"];
    
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:formula parameters:parameters];
    XCTAssertTrue([[operation description] isEqualToString:@"operation-name param-one param-two formula-name"], @"Should contain operation name, each parameter in the correct order, then the formula name.");
}

- (void)testOperationDescriptionWithFormulaAndNilParameters
{
    id formula = [OCMockObject mockForClass:[MRBrewFormula class]];
    [[[formula stub] andReturn:@"formula-name"] name];
    [[[formula stub] andReturn:formula] copy];
    
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:formula parameters:nil];
    XCTAssertTrue([[operation description] isEqualToString:@"operation-name formula-name"], @"Should contain operation name then formula name.");
}

- (void)testOperationDescriptionWithParametersAndNilFormula
{
    NSArray *parameters = @[@"param-one", @"param-two"];
    
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:nil parameters:parameters];
    XCTAssertTrue([[operation description] isEqualToString:@"operation-name param-one param-two"], @"Should contain operation name then each parameter in the correct order.");
}

- (void)testOperationDescriptionWithNilFormulaAndNilParameters
{
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:nil parameters:nil];
    XCTAssertTrue([[operation description] isEqualToString:@"operation-name"], @"Should contain operation name.");
}

@end
