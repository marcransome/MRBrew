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
    id _formula;
}

@end

@implementation MRBrewOperationTests

#pragma mark - Setup

- (void)setUp
{
    [super setUp];
    
    _formula = [OCMockObject mockForClass:[MRBrewFormula class]];
    [[[_formula stub] andReturn:@"formula-name"] name];
    [[[_formula stub] andReturn:_formula] copy];
    [[[_formula stub] andReturn:_formula] copyWithZone:[OCMArg anyPointer]];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

#pragma mark - Initialisation

- (void)testClassOfOperation
{
    MRBrewOperation *operation = [[MRBrewOperation alloc] init];
    Class operationClass = [MRBrewOperation class];
    
    XCTAssertTrue([operation isKindOfClass:operationClass], @"Operation should be kind of class %@.", NSStringFromClass(operationClass));
}

#pragma mark - Equality Tests

- (void)testEqualityOfSingleOperation
{
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    
    XCTAssertTrue([operation isEqualToOperation:operation], @"Operation should be equal to itself.");
}

- (void)testEqualityOfIdenticalOperations
{
    [[[_formula stub] andReturnValue:@YES] isEqualToFormula:[OCMArg any]];

    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    
    XCTAssertTrue([operation1 isEqualToOperation:operation2], @"Operations that have identical properties should be equal.");
}

- (void)testEqualityOfOperationsWithDifferentNameProperty
{
    [[[_formula stub] andReturnValue:@YES] isEqualToFormula:[OCMArg any]];
    
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"different-name" formula:_formula parameters:@[@"param-one"]];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations that have a different 'name' property should not be equal.");
}

- (void)testEqualityOfOperationsWithDifferentFormulaProperty
{
    [[[_formula stub] andReturnValue:@NO] isEqualToFormula:[OCMArg any]];
    
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations that have a different 'formula' property should not be equal.");
}

- (void)testEqualityOfOperationsWithDifferentParametersProperty
{
    [[[_formula stub] andReturnValue:@YES] isEqualToFormula:[OCMArg any]];
    
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"different-param"]];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations that have a different 'parameters' property should not be equal.");
}

- (void)testEqualityOfOperationWithNil
{
    MRBrewOperation *operation = [[MRBrewOperation alloc] init];
    
    XCTAssertFalse([operation isEqualToOperation:nil], @"Operations should never be equal to nil.");
}

- (void)testEqualityOfOperationWithObjectOfAnotherClass
{
    MRBrewOperation *operation = [[MRBrewOperation alloc] init];
    id string = @"string";
    
    XCTAssertFalse([operation isEqualToOperation:string], @"Operations should never be equal to objects of another class.");
}

#pragma mark - Description

- (void)testOperationDescriptionWithFormulaAndParameters
{
    NSArray *parameters = @[@"param-one", @"param-two"];
    
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:parameters];
    XCTAssertTrue([[operation description] isEqualToString:@"operation-name param-one param-two formula-name"], @"Should contain operation name, each parameter in the correct order, then the formula name.");
}

- (void)testOperationDescriptionWithFormulaAndNilParameters
{
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:nil];
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

#pragma mark - Copying

-(void)testCopiedOperationIsEqualToOriginalOperation
{
    [[[_formula stub] andReturnValue:@YES] isEqualToFormula:[OCMArg any]];
    
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one", @"param-two"]];
    MRBrewOperation *copy = [operation copy];
    
    XCTAssertTrue([copy isEqualToOperation:operation], @"Operation copy should be identical to original operation.");
}

@end
