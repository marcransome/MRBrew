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

#import "MRBrewOperationTests.h"
#import "MRBrewOperation.h"
#import "MRBrewFormula.h"

@implementation MRBrewOperationTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSingleOperationEquality
{
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:nil parameters:@[]];
    
    XCTAssertTrue([operation1 isEqualToOperation:operation1], @"Comparison of a operation with itself should be equal.");
}

- (void)testIdenticalOperationsEquality
{
    MRBrewFormula *formula = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:formula parameters:@[]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation" formula:formula parameters:@[]];
    
    XCTAssertTrue([operation1 isEqualToOperation:operation2], @"Operations that have the same properties should be equal.");
}

- (void)testDifferentOperationsEqualityForNameProperty
{
    MRBrewFormula *formula = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:formula parameters:@[]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"different" formula:formula parameters:@[]];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations with different name property should not be equal.");
}

- (void)testDifferentOperationsEqualityForFormulaProperty
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"different"];
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:formula1 parameters:@[]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation" formula:formula2 parameters:@[]];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations with different formula property should not be equal.");
}

- (void)testDifferentOperationsEqualityForFormulaPropertyOneNilValue
{
    MRBrewFormula *formula = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:formula parameters:@[]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation" formula:nil parameters:@[]];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations with different formula property should not be equal.");
}

- (void)testDifferentOperationsEqualityForParametersProperty
{
    MRBrewFormula *formula = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:formula parameters:@[]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation" formula:formula parameters:@[@"different"]];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations with different parameters property should not be equal.");
}

- (void)testDifferentOperationsEqualityForParametersPropertyOneNilValue
{
    MRBrewFormula *formula = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:formula parameters:@[]];
    MRBrewOperation *operation2 = [MRBrewOperation operationWithName:@"operation" formula:formula parameters:nil];
    
    XCTAssertFalse([operation1 isEqualToOperation:operation2], @"Operations with different parameters property should not be equal.");
}

- (void)testOperationForEqualityWithNil
{
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:nil parameters:nil];
    
    XCTAssertFalse([operation1 isEqualToOperation:nil], @"Operations can never be equal to nil.");
}

- (void)testOperationForEqualityWithObjectOfAnotherClass
{
    MRBrewOperation *operation1 = [MRBrewOperation operationWithName:@"operation" formula:nil parameters:nil];
    id string = @"string";
    
    XCTAssertFalse([operation1 isEqualToOperation:string], @"Operations can never be equal to objects of another class.");
}

@end
