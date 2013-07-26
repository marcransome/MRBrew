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

#import "MRBrewFormulaTests.h"
#import "MRBRewFormula.h"

@implementation MRBrewFormulaTests

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

- (void)testSingleFormulaEquality
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];

    STAssertTrue([formula1 isEqualToFormula:formula1], @"Comparison of a formula with itself should be equal.");
}

- (void)testIdenticalFormulaeEquality
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"formula"];
    
    STAssertTrue([formula1 isEqualToFormula:formula2], @"Formulae that have the same properties should be equal.");
}

- (void)testDifferentFormulaeEqualityForNameProperty
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"different"];
    
    STAssertFalse([formula1 isEqualToFormula:formula2], @"Formulae with differing name property should not be equal.");
}

- (void)testDifferentFormulaeEqualityForUpdatedProperty
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"formula"];
    [formula2 setIsUpdated:YES];
    
    STAssertFalse([formula1 isEqualToFormula:formula2], @"Formulae with differing updated property should not be equal.");
}

- (void)testDifferentFormulaeEqualityForNewProperty
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"formula"];
    [formula2 setIsNew:YES];
    
    STAssertFalse([formula1 isEqualToFormula:formula2], @"Formulae with differing new property should not be equal.");
}

- (void)testDifferentFormulaeEqualityForInstalledProperty
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"formula"];
    [formula2 setIsInstalled:YES];
    
    STAssertFalse([formula1 isEqualToFormula:formula2], @"Formulae with differing installed property should not be equal.");
}

@end
