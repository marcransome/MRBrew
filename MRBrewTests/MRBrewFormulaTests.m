//
//  MRBrewFormulaTests.m
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
#import "MRBRewFormula.h"

@interface MRBrewFormulaTests : XCTestCase

@end

@implementation MRBrewFormulaTests

# pragma mark - Setup

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

# pragma mark - Equality Tests

- (void)testSingleFormulaEquality
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];

    XCTAssertTrue([formula1 isEqualToFormula:formula1], @"Comparison of a formula with itself should be equal.");
}

- (void)testIdenticalFormulaeEquality
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"formula"];
    
    XCTAssertTrue([formula1 isEqualToFormula:formula2], @"Formulae that have the same properties should be equal.");
}

- (void)testDifferentFormulaeEqualityForNameProperty
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"different"];
    
    XCTAssertFalse([formula1 isEqualToFormula:formula2], @"Formulae with different name property should not be equal.");
}

- (void)testDifferentFormulaeEqualityForUpdatedProperty
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"formula"];
    [formula2 setIsUpdated:YES];
    
    XCTAssertFalse([formula1 isEqualToFormula:formula2], @"Formulae with different updated property should not be equal.");
}

- (void)testDifferentFormulaeEqualityForNewProperty
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"formula"];
    [formula2 setIsNew:YES];
    
    XCTAssertFalse([formula1 isEqualToFormula:formula2], @"Formulae with different new property should not be equal.");
}

- (void)testDifferentFormulaeEqualityForInstalledProperty
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"formula"];
    [formula2 setIsInstalled:YES];
    
    XCTAssertFalse([formula1 isEqualToFormula:formula2], @"Formulae with different installed property should not be equal.");
}

- (void)testFormulaForEqualityWithNil
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];

    XCTAssertFalse([formula1 isEqualToFormula:nil], @"Formulae can never be equal to nil.");
}

- (void)testFormulaForEqualityWithObjectOfAnotherClass
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];
    id string = @"string";
    
    XCTAssertFalse([formula1 isEqualToFormula:string], @"Formulae can never be equal to objects of another class.");
}

@end
