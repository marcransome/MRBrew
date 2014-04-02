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

#pragma mark - Initialisation

- (void)testFormulaCreatedWithInitMethodHasCorrectProperties
{
    // setup
    NSString *formulaName = @"formula-name";
    
    // execute
    MRBrewFormula *formula = [[MRBrewFormula alloc] initWithName:formulaName];
    
    // verify
    XCTAssertEqual([formula name], formulaName, @"Formula 'name' property should equal the name object specified in factory method call.");
    XCTAssertEqual([formula name], formulaName, @"Formula 'new' property should equal NO.");
    XCTAssertEqual([formula name], formulaName, @"Formula 'updated' property should equal NO.");
    XCTAssertEqual([formula name], formulaName, @"Formula 'installed' property should equal NO.");
}

#pragma mark Factory Method Initialisation

- (void)testFormulaCreatedWithFactoryMethodHasCorrectNameProperty
{
    // setup
    NSString *formulaName = @"formula-name";
    
    // execute
    MRBrewFormula *formula = [MRBrewFormula formulaWithName:formulaName isNew:NO isUpdated:NO isInstalled:NO];
    
    // verify
    XCTAssertEqual([formula name], formulaName, @"Formula 'name' property should equal the name object specified in factory method call.");
}

- (void)testFormulaCreatedWithFactoryMethodHasCorrectNewProperty
{
    // setup
    BOOL newProperty = YES;
    NSString *formulaName = @"formula-name";
    
    // execute
    MRBrewFormula *formula = [MRBrewFormula formulaWithName:formulaName isNew:newProperty isUpdated:NO isInstalled:NO];
    
    // verify
    XCTAssertEqual([formula isNew], newProperty, @"Formula 'isNew' property should equal the boolean value specified in factory method call.");
}

- (void)testFormulaCreatedWithFactoryMethodHasCorrectUpdatedProperty
{
    // setup
    BOOL updatedProperty = YES;
    NSString *formulaName = @"formula-name";
    
    // execute
    MRBrewFormula *formula = [MRBrewFormula formulaWithName:formulaName isNew:NO isUpdated:updatedProperty isInstalled:NO];
    
    // verify
    XCTAssertEqual([formula isUpdated], updatedProperty, @"Formula 'isUpdated' property should equal the boolean value specified in factory method call.");
}

- (void)testFormulaCreatedWithFactoryMethodHasCorrectInstalledProperty
{
    // setup
    BOOL installedProperty = YES;
    NSString *formulaName = @"formula-name";
    
    // execute
    MRBrewFormula *formula = [MRBrewFormula formulaWithName:formulaName isNew:NO isUpdated:NO isInstalled:installedProperty];
    
    // verify
    XCTAssertEqual([formula isInstalled], installedProperty, @"Formula 'isInstalled' property should equal the boolean value specified in factory method call.");
}

#pragma mark - Equality Tests

- (void)testEqualityOfSingleFormula
{
    // setup
    MRBrewFormula *formula = [MRBrewFormula formulaWithName:@"formula-name"];

    // execute & verify
    XCTAssertTrue([formula isEqualToFormula:formula], @"Formula should be equal to itself.");
}

- (void)testEqualityOfIdenticalFormulae
{
    // setup
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula-name"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"formula-name"];
    
    // execute & verify
    XCTAssertTrue([formula1 isEqualToFormula:formula2], @"Formulae that have identical properties should be equal.");
}

- (void)testEqualityOfFormulaeWithDifferentNameProperty
{
    // setup
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula-name"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"different-name"];
    
    // execute & verify
    XCTAssertFalse([formula1 isEqualToFormula:formula2], @"Formulae that have a different 'name' property should not be equal.");
}

- (void)testEqualityOfFormulaeWithDifferentUpdatedProperty
{
    // setup
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula-name"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"formula-name"];
    [formula2 setIsUpdated:YES];
    
    // execute & verify
    XCTAssertFalse([formula1 isEqualToFormula:formula2], @"Formulae that have a different 'updated' property should not be equal.");
}

- (void)testEqualityOfFormulaeWithDifferentNewProperty
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula-name"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"formula-name"];
    [formula2 setIsNew:YES];
    
    // execute & verify
    XCTAssertFalse([formula1 isEqualToFormula:formula2], @"Formulae that have a different 'new' property should not be equal.");
}

- (void)testEqualityOfFormulaeWithDifferentInstalledProperty
{
    MRBrewFormula *formula1 = [MRBrewFormula formulaWithName:@"formula-name"];
    MRBrewFormula *formula2 = [MRBrewFormula formulaWithName:@"formula-name"];
    [formula2 setIsInstalled:YES];
    
    // execute & verify
    XCTAssertFalse([formula1 isEqualToFormula:formula2], @"Formulae that have a different 'installed' property should not be equal.");
}

- (void)testEqualityOfFormulaWithNil
{
    // setup
    MRBrewFormula *formula = [[MRBrewFormula alloc] init];
    
    // execute & verify
    XCTAssertFalse([formula isEqualToFormula:nil], @"Formulae should never be equal to nil.");
}

- (void)testEqualityOfFormulaWithObjectOfAnotherClass
{
    // setup
    MRBrewFormula *formula = [[MRBrewFormula alloc] init];
    id string = @"string";
    
    // execute & verify
    XCTAssertFalse([formula isEqualToFormula:string], @"Formulae should never be equal to objects of another class.");
}

#pragma mark - Copying

-(void)testCopiedFormulaIsEqualToOriginalFormula
{
    // setupn
    MRBrewFormula *formula = [MRBrewFormula formulaWithName:@"formula-name"];
    MRBrewFormula *copy = [formula copy];
    
    // execute & verify
    XCTAssertTrue([copy isEqualToFormula:formula], @"Formula copy should be identical to original formula.");
}

@end
