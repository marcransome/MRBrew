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

#pragma mark Type Initialisation

- (void)testOperationCreatedWithTypeHasCorrectNameProperty
{
    // setup
    NSArray *params = @[@"param-one", @"param-two"];
    
    // execute
    MRBrewOperation *operation = [MRBrewOperation operationWithType:MRBrewOperationSearch formula:_formula parameters:params];
    
    // verify
    XCTAssertEqual([operation name], MRBrewOperationSearchIdentifier, @"Operation 'name' property should equal the value of the type constant specified in factory method call.");
}

- (void)testOperationCreatedWithTypeHasCorrectFormulaProperty
{
    // setup
    NSArray *params = @[@"param-one", @"param-two"];
    
    // execute
    MRBrewOperation *operation = [MRBrewOperation operationWithType:MRBrewOperationSearch formula:_formula parameters:params];
    
    // verify
    XCTAssertEqual([operation formula], _formula, @"Operation 'formula' property should equal the formula object specified in factory method call.");
}

- (void)testOperationCreatedWithTypeHasCorrectParametersProperty
{
    // setup
    NSArray *params = @[@"param-one", @"param-two"];
    
    // execute
    MRBrewOperation *operation = [MRBrewOperation operationWithType:MRBrewOperationSearch formula:_formula parameters:params];
    
    // verify
    XCTAssertEqual([operation parameters], params, @"Operation 'parameters' property should equal the parameters object specified in factory method call.");
}

#pragma mark Update Operation Initialisation

- (void)testUpdateOperationHasCorrectNameProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation updateOperation];
    
    // execute & verify
    XCTAssertEqual([operation name], MRBrewOperationUpdateIdentifier, @"Operation 'name' property should match value of MRBrewOperationUpdateIdentifier constant.");
}

- (void)testUpdateOperationHasNilFormulaProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation updateOperation];
    
    // execute & verify
    XCTAssertNil([operation formula], @"Operation 'formula' property should be nil.");
}

- (void)testUpdateOperationHasNilParametersProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation updateOperation];
    
    // execute & verify
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark List Operation Initialisation

- (void)testListOperationHasCorrectNameProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation listOperation];
    
    // execute & verify
    XCTAssertEqual([operation name], MRBrewOperationListIdentifier, @"Operation 'name' property should match value of MRBrewOperationListIdentifier constant.");
}

- (void)testListOperationHasNilFormulaProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation listOperation];
    
    // execute & verify
    XCTAssertNil([operation formula], @"Operation 'formula' property should be nil.");
}

- (void)testListOperationHasNilParametersProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation listOperation];
    
    // execute & verify
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark Search Operation Initialisation

- (void)testSearchOperationHasCorrectNameProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation searchOperation];
    
    // execute & verify
    XCTAssertEqual([operation name], MRBrewOperationSearchIdentifier, @"Operation 'name' property should match value of MRBrewOperationSearchIdentifier constant.");
}

- (void)testSearchOperationHasNilFormulaProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation searchOperation];
    
    // execute & verify
    XCTAssertNil([operation formula], @"Operation 'formula' property should be nil.");
}

- (void)testSearchOperationHasNilParametersProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation searchOperation];
    
    // execute & verify
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

- (void)testSearchOperationWithFormulaHasCorrectNameProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation searchOperation:_formula];
    
    // execute & verify
    XCTAssertEqual([operation name], MRBrewOperationSearchIdentifier, @"Operation 'name' property should match value of MRBrewOperationSearchIdentifier constant.");
}

- (void)testSearchOperationWithFormulaHasCorrectFormulaProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation searchOperation:_formula];
    
    // execute & verify
    XCTAssertEqual([operation formula], _formula, @"Operation 'formula' property should equal the formula object specified in factory method call.");
}

- (void)testSearchOperationWithFormulaHasNilParametersProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation searchOperation:_formula];
    
    // execute & verify
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark Install Operation Initialisation

- (void)testInstallOperationWithFormulaHasCorrectNameProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation installOperation:_formula];
    
    // execute & verify
    XCTAssertEqual([operation name], MRBrewOperationInstallIdentifier, @"Operation 'name' property should match value of MRBrewOperationInstallIdentifier constant.");
}

- (void)testInstallOperationWithFormulaHasCorrectFormulaProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation installOperation:_formula];
    
    // execute & verify
    XCTAssertEqual([operation formula], _formula, @"Operation 'formula' property should equal the formula object specified in factory method call.");
}

- (void)testInstallOperationWithFormulaHasNilParametersProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation installOperation:_formula];
    
    // execute & verify
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark Info Operation Initialisation

- (void)testInfoOperationWithFormulaHasCorrectNameProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation infoOperation:_formula];
    
    // execute & verify
    XCTAssertEqual([operation name], MRBrewOperationInfoIdentifier, @"Operation 'name' property should match value of MRBrewOperationInfoIdentifier constant.");
}

- (void)testInfoOperationWithFormulaHasCorrectFormulaProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation infoOperation:_formula];
    
    // execute & verify
    XCTAssertEqual([operation formula], _formula, @"Operation 'formula' property should equal the formula object specified in factory method call.");
}

- (void)testInfoOperationWithFormulaHasNilParametersProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation infoOperation:_formula];
    
    // execute & verify
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark Remove Operation Initialisation

- (void)testRemoveOperationWithFormulaHasCorrectNameProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation removeOperation:_formula];
    
    // execute & verify
    XCTAssertEqual([operation name], MRBrewOperationRemoveIdentifier, @"Operation 'name' property should match value of MRBrewOperationRemoveIdentifier constant.");
}

- (void)testRemoveOperationWithFormulaHasCorrectFormulaProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation removeOperation:_formula];
    
    // execute & verify
    XCTAssertEqual([operation formula], _formula, @"Operation 'formula' property should equal the formula object specified in factory method call.");
}

- (void)testRemoveOperationWithFormulaHasNilParametersProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation removeOperation:_formula];
    
    // execute & verify
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark Options Operation Initialisation

- (void)testOptionsOperationWithFormulaHasCorrectNameProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation optionsOperation:_formula];
    
    // execute & verify
    XCTAssertEqual([operation name], MRBrewOperationOptionsIdentifier, @"Operation 'name' property should match value of MRBrewOperationOptionsIdentifier constant.");
}

- (void)testOptionsOperationWithFormulaHasCorrectFormulaProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation optionsOperation:_formula];
    
    // execute & verify
    XCTAssertEqual([operation formula], _formula, @"Operation 'formula' property should equal the formula object specified in factory method call.");
}

- (void)testOptionsOperationWithFormulaHasNilParametersProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation optionsOperation:_formula];
    
    // execute & verify
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark Outdated Operation Initialisation

- (void)testOutdatedOperationHasCorrectNameProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation outdatedOperation];
    
    // execute & verify
    XCTAssertEqual([operation name], MRBrewOperationOutdatedIdentifier, @"Operation 'name' property should match value of MRBrewOperationOutdatedIdentifier constant.");
}

- (void)testOutdatedOperationHasNilFormulaProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation outdatedOperation];
    
    // execute & verify
    XCTAssertNil([operation formula], @"Operation 'formula' property should be nil.");
}

- (void)testOutdatedOperationHasNilParametersProperty
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation outdatedOperation];
    
    // execute & verify
    XCTAssertNil([operation parameters], @"Operation 'parameters' property should be nil.");
}

#pragma mark - Equality Tests

- (void)testEqualityOfSingleOperation
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    
    // execute & verify
    XCTAssertTrue([operation isEqualToOperation:operation], @"Operation should be equal to itself.");
}

- (void)testEqualityOfIdenticalOperations
{
    [[[_formula stub] andReturnValue:@YES] isEqualToFormula:[OCMArg any]];
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    
    // execute & verify
    XCTAssertTrue([operation1 isEqualToOperation:operation2], @"Operations that have identical properties should be equal.");
}

- (void)testEqualityOfOperationsWithDifferentNameProperty
{
    // setup
    [[[_formula stub] andReturnValue:@YES] isEqualToFormula:[OCMArg any]];
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"different-name" formula:_formula parameters:@[@"param-one"]];
    
    // execute & verify
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations that have a different 'name' property should not be equal.");
}

- (void)testEqualityOfOperationsWithDifferentFormulaProperty
{
    // setup
    [[[_formula stub] andReturnValue:@NO] isEqualToFormula:[OCMArg any]];
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    
    // execute & verify
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations that have a different 'formula' property should not be equal.");
}

- (void)testEqualityOfOperationsWithDifferentFormulaPropertyWhereOneIsNil
{
    // setup
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation-name" formula:nil parameters:@[@"param-one"]];
    
    // execute & verify
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations that have a different 'formula' property should not be equal.");
}

- (void)testEqualityOfOperationsWithDifferentParametersProperty
{
    // setup
    [[[_formula stub] andReturnValue:@YES] isEqualToFormula:[OCMArg any]];
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"different-param"]];
    
    // execute & verify
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations that have a different 'parameters' property should not be equal.");
}

- (void)testEqualityOfOperationsWithDifferentParametersPropertyWhereOneIsNil
{
    // setup
    [[[_formula stub] andReturnValue:@YES] isEqualToFormula:[OCMArg any]];
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one"]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:nil];
    
    // execute & verify
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations that have a different 'parameters' property should not be equal.");
}

- (void)testEqualityOfOperationWithNil
{
    // setup
    MRBrewOperation *operation = [[MRBrewOperation alloc] init];
    
    // execute & verify
    XCTAssertFalse([operation isEqualToOperation:nil], @"Operations should never be equal to nil.");
}

- (void)testEqualityOfOperationWithObjectOfAnotherClass
{
    // setup
    MRBrewOperation *operation = [[MRBrewOperation alloc] init];
    id string = @"string";
    
    // execute & verify
    XCTAssertFalse([operation isEqualToOperation:string], @"Operations should never be equal to objects of another class.");
}

#pragma mark - Description

- (void)testOperationDescriptionWithFormulaAndParameters
{
    // setup
    NSArray *parameters = @[@"param-one", @"param-two"];
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:parameters];
    
    // execute & verify
    XCTAssertTrue([[operation description] isEqualToString:@"operation-name param-one param-two formula-name"], @"Should contain operation name, each parameter in the correct order, then the formula name.");
}

- (void)testOperationDescriptionWithFormulaAndNilParameters
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:nil];
    
    // execute & verify
    XCTAssertTrue([[operation description] isEqualToString:@"operation-name formula-name"], @"Should contain operation name then formula name.");
}

- (void)testOperationDescriptionWithParametersAndNilFormula
{
    // setup
    NSArray *parameters = @[@"param-one", @"param-two"];
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:nil parameters:parameters];
    
    // execute & verify
    XCTAssertTrue([[operation description] isEqualToString:@"operation-name param-one param-two"], @"Should contain operation name then each parameter in the correct order.");
}

- (void)testOperationDescriptionWithNilFormulaAndNilParameters
{
    // setup
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:nil parameters:nil];
    
    // execute & verify
    XCTAssertTrue([[operation description] isEqualToString:@"operation-name"], @"Should contain operation name.");
}

#pragma mark - Copying

-(void)testCopiedOperationIsEqualToOriginalOperation
{
    // setup
    [[[_formula stub] andReturnValue:@YES] isEqualToFormula:[OCMArg any]];
    MRBrewOperation *operation = [MRBrewOperation operationWithName:@"operation-name" formula:_formula parameters:@[@"param-one", @"param-two"]];
    MRBrewOperation *copy = [operation copy];
    
    // execute & verify
    XCTAssertTrue([copy isEqualToOperation:operation], @"Operation copy should be identical to original operation.");
}

@end
