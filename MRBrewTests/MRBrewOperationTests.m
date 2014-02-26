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
#import "MRBrewConstants.h"

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

#pragma mark Type Initialisation

- (void)testOperationCreatedWithTypeHasCorrectNameProperty
{
    NSArray *params = @[@"param-one", @"param-two"];
    MRBrewOperation *operation = [MRBrewOperation operationWithType:MRBrewOperationSearch formula:_formula parameters:params];
    
    XCTAssertEqual([operation name], MRBrewOperationSearchIdentifier, @"Operation 'name' property should equal the value of the type constant specified in factory method call.");
}

- (void)testOperationCreatedWithTypeHasCorrectFormulaProperty
{
    NSArray *params = @[@"param-one", @"param-two"];
    MRBrewOperation *operation = [MRBrewOperation operationWithType:MRBrewOperationSearch formula:_formula parameters:params];
    
    XCTAssertEqual([operation formula], _formula, @"Operation 'formula' property should equal the formula object specified in factory method call.");
}

- (void)testOperationCreatedWithTypeHasCorrectParametersProperty
{
    NSArray *params = @[@"param-one", @"param-two"];
    MRBrewOperation *operation = [MRBrewOperation operationWithType:MRBrewOperationSearch formula:_formula parameters:params];
    
    XCTAssertEqual([operation parameters], params, @"Operation 'parameters' property should equal the parameters object specified in factory method call.");
}

#pragma mark Update Operation Initialisation

- (void)testUpdateOperationHasCorrectNameProperty
{
    MRBrewOperation *operation = [MRBrewOperation updateOperation];
    
    XCTAssertEqual([operation name], MRBrewOperationUpdateIdentifier, @"Operation 'name' property should match value of MRBrewOperationUpdateIdentifier constant.");
}

- (void)testUpdateOperationHasNilFormulaProperty
{
    MRBrewOperation *operation = [MRBrewOperation updateOperation];
    
    XCTAssertNil([operation formula], @"Operation 'formula' property should be nil.");
}

- (void)testUpdateOperationHasNilParametersProperty
{
    MRBrewOperation *operation = [MRBrewOperation updateOperation];
    
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark List Operation Initialisation

- (void)testListOperationHasCorrectNameProperty
{
    MRBrewOperation *operation = [MRBrewOperation listOperation];
    
    XCTAssertEqual([operation name], MRBrewOperationListIdentifier, @"Operation 'name' property should match value of MRBrewOperationListIdentifier constant.");
}

- (void)testListOperationHasNilFormulaProperty
{
    MRBrewOperation *operation = [MRBrewOperation listOperation];
    
    XCTAssertNil([operation formula], @"Operation 'formula' property should be nil.");
}

- (void)testListOperationHasNilParametersProperty
{
    MRBrewOperation *operation = [MRBrewOperation listOperation];
    
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark Search Operation Initialisation

- (void)testSearchOperationHasCorrectNameProperty
{
    MRBrewOperation *operation = [MRBrewOperation searchOperation];
    
    XCTAssertEqual([operation name], MRBrewOperationSearchIdentifier, @"Operation 'name' property should match value of MRBrewOperationSearchIdentifier constant.");
}

- (void)testSearchOperationHasNilFormulaProperty
{
    MRBrewOperation *operation = [MRBrewOperation searchOperation];
    
    XCTAssertNil([operation formula], @"Operation 'formula' property should be nil.");
}

- (void)testSearchOperationHasNilParametersProperty
{
    MRBrewOperation *operation = [MRBrewOperation searchOperation];
    
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

- (void)testSearchOperationWithFormulaHasCorrectNameProperty
{
    MRBrewOperation *operation = [MRBrewOperation searchOperation:_formula];
    
    XCTAssertEqual([operation name], MRBrewOperationSearchIdentifier, @"Operation 'name' property should match value of MRBrewOperationSearchIdentifier constant.");
}

- (void)testSearchOperationWithFormulaHasCorrectFormulaProperty
{
    MRBrewOperation *operation = [MRBrewOperation searchOperation:_formula];
    
    XCTAssertEqual([operation formula], _formula, @"Operation 'formula' property should equal the formula object specified in factory method call.");
}

- (void)testSearchOperationWithFormulaHasNilParametersProperty
{
    MRBrewOperation *operation = [MRBrewOperation searchOperation:_formula];
    
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark Install Operation Initialisation

- (void)testInstallOperationWithFormulaHasCorrectNameProperty
{
    MRBrewOperation *operation = [MRBrewOperation installOperation:_formula];
    
    XCTAssertEqual([operation name], MRBrewOperationInstallIdentifier, @"Operation 'name' property should match value of MRBrewOperationInstallIdentifier constant.");
}

- (void)testInstallOperationWithFormulaHasCorrectFormulaProperty
{
    MRBrewOperation *operation = [MRBrewOperation installOperation:_formula];
    
    XCTAssertEqual([operation formula], _formula, @"Operation 'formula' property should equal the formula object specified in factory method call.");
}

- (void)testInstallOperationWithFormulaHasNilParametersProperty
{
    MRBrewOperation *operation = [MRBrewOperation installOperation:_formula];
    
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark Info Operation Initialisation

- (void)testInfoOperationWithFormulaHasCorrectNameProperty
{
    MRBrewOperation *operation = [MRBrewOperation infoOperation:_formula];
    
    XCTAssertEqual([operation name], MRBrewOperationInfoIdentifier, @"Operation 'name' property should match value of MRBrewOperationInfoIdentifier constant.");
}

- (void)testInfoOperationWithFormulaHasCorrectFormulaProperty
{
    MRBrewOperation *operation = [MRBrewOperation infoOperation:_formula];
    
    XCTAssertEqual([operation formula], _formula, @"Operation 'formula' property should equal the formula object specified in factory method call.");
}

- (void)testInfoOperationWithFormulaHasNilParametersProperty
{
    MRBrewOperation *operation = [MRBrewOperation infoOperation:_formula];
    
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark Remove Operation Initialisation

- (void)testRemoveOperationWithFormulaHasCorrectNameProperty
{
    MRBrewOperation *operation = [MRBrewOperation removeOperation:_formula];
    
    XCTAssertEqual([operation name], MRBrewOperationRemoveIdentifier, @"Operation 'name' property should match value of MRBrewOperationRemoveIdentifier constant.");
}

- (void)testRemoveOperationWithFormulaHasCorrectFormulaProperty
{
    MRBrewOperation *operation = [MRBrewOperation removeOperation:_formula];
    
    XCTAssertEqual([operation formula], _formula, @"Operation 'formula' property should equal the formula object specified in factory method call.");
}

- (void)testRemoveOperationWithFormulaHasNilParametersProperty
{
    MRBrewOperation *operation = [MRBrewOperation removeOperation:_formula];
    
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark Options Operation Initialisation

- (void)testOptionsOperationWithFormulaHasCorrectNameProperty
{
    MRBrewOperation *operation = [MRBrewOperation optionsOperation:_formula];
    
    XCTAssertEqual([operation name], MRBrewOperationOptionsIdentifier, @"Operation 'name' property should match value of MRBrewOperationOptionsIdentifier constant.");
}

- (void)testOptionsOperationWithFormulaHasCorrectFormulaProperty
{
    MRBrewOperation *operation = [MRBrewOperation optionsOperation:_formula];
    
    XCTAssertEqual([operation formula], _formula, @"Operation 'formula' property should equal the formula object specified in factory method call.");
}

- (void)testOptionsOperationWithFormulaHasNilParametersProperty
{
    MRBrewOperation *operation = [MRBrewOperation optionsOperation:_formula];
    
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark Outdated Operation Initialisation

- (void)testOutdatedOperationHasCorrectNameProperty
{
    MRBrewOperation *operation = [MRBrewOperation outdatedOperation];
    
    XCTAssertEqual([operation name], MRBrewOperationOutdatedIdentifier, @"Operation 'name' property should match value of MRBrewOperationOutdatedIdentifier constant.");
}

- (void)testOutdatedOperationHasNilFormulaProperty
{
    MRBrewOperation *operation = [MRBrewOperation outdatedOperation];
    
    XCTAssertNil([operation formula], @"Operation 'formula' property should be nil.");
}

- (void)testOutdatedOperationHasNilParametersProperty
{
    MRBrewOperation *operation = [MRBrewOperation outdatedOperation];
    
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
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

- (void)testEqualityOfOperationsWithDifferentFormulaPropertyWhereOneIsNil
{
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation-name" formula:nil parameters:@[@"param-one"]];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations that have a different 'formula' property should not be equal.");
}

- (void)testEqualityOfOperationsWithDifferentParametersProperty
{
    [[[_formula stub] andReturnValue:@YES] isEqualToFormula:[OCMArg any]];
    
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"different-param"]];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations that have a different 'parameters' property should not be equal.");
}

- (void)testEqualityOfOperationsWithDifferentParametersPropertyWhereOneIsNil
{
    [[[_formula stub] andReturnValue:@YES] isEqualToFormula:[OCMArg any]];
    
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:nil];
    
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
