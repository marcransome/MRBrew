//
//  MRBrewOutputParserTests.m
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
#include "MRBrewOutputParser.h"
#include "MRBrewFormula.h"
#include "MRBrewOperation.h"
#include "MRBrewInstallOption.h"
#include "MRBrewConstants.h"

@interface MRBrewOutputParserTests : XCTestCase
{
    NSString *_fakeOutputFromListOperation;
    NSString *_fakeOutputFromSearchOperation;
    NSString *_fakeOutputFromOptionsOperation;
    NSUInteger _fakeCountForListOperation;
    NSUInteger _fakeCountForSearchOperation;
    NSUInteger _fakeCountForOptionsOperation;
}

@end

@implementation MRBrewOutputParserTests

#pragma mark - Setup

- (void)setUp
{
    [super setUp];
    
    _fakeOutputFromListOperation = @"test-formula\ntest-formula-two\n";
    _fakeOutputFromSearchOperation = @"test-formula\ntest-formula-two\n";
    _fakeOutputFromOptionsOperation = @"--test-option\n\tTest option description\n--test-option-two\n\tTest option description two\n\n";
    
    _fakeCountForListOperation = 2;
    _fakeCountForSearchOperation = 2;
    _fakeCountForOptionsOperation = 2;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

#pragma mark - List Output Parsing Tests

- (void)testParsedObjectArrayForListOperationIsNotNil
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationListIdentifier] name];
    NSArray *objects = [[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromListOperation error:nil];
    XCTAssertNotNil(objects, @"Nil should not be returned when a valid output string is provided.");
}

- (void)testParsedObjectArrayForListOperationContainsValidObject
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationListIdentifier] name];
    NSArray *objects = [[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromListOperation error:nil];
    XCTAssertTrue([[objects objectAtIndex:0] isKindOfClass:[MRBrewFormula class]], @"Objects parsed from list operation output should be of class MRBrewFormula.");
}

- (void)testParsedObjectArrayForListOperationContainsCorrectNumberOfObjects
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationListIdentifier] name];
    NSArray *objects = [[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromListOperation error:nil];
    XCTAssertTrue([objects count] == _fakeCountForListOperation, @"The number of objects parsed should equal the number of non-blank lines in the output string.");
}

- (void)testNoErrorIsInstantiatedForListOperationWithValidOutput
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationListIdentifier] name];
    NSError *error = nil;
    [[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromListOperation error:&error];
    XCTAssertNil(error, @"An error object should not be returned when a valid output string is provided.");
}

#pragma mark - Search Output Parsing Tests

- (void)testParsedObjectArrayForSearchOperationIsNotNil
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationSearchIdentifier] name];
    NSArray *objects = [[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromSearchOperation error:nil];
    XCTAssertNotNil(objects, @"Nil should not be returned when a valid output string is provided.");
}

- (void)testParsedObjectArrayForSearchOperationContainsValidObject
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationSearchIdentifier] name];
    NSArray *objects = [[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromSearchOperation error:nil];
    XCTAssertTrue([[objects objectAtIndex:0] isKindOfClass:[MRBrewFormula class]], @"Objects parsed from search operation output should be of class MRBrewFormula.");
}

- (void)testParsedObjectArrayForSearchOperationContainsCorrectNumberOfObjects
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationSearchIdentifier] name];
    NSArray *objects = [[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromSearchOperation error:nil];
    XCTAssertTrue([objects count] == _fakeCountForSearchOperation, @"The number of objects parsed should equal the number of non-blank lines in the output string.");
}

- (void)testNoErrorIsInstantiatedForSearchOperationWithValidOutput
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationSearchIdentifier] name];
    NSError *error = nil;
    [[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromSearchOperation error:&error];
    XCTAssertNil(error, @"An error object should not be returned when a valid output string is provided.");
}

#pragma mark - Options Output Parsing Tests

- (void)testParsedObjectArrayForOptionsOperationIsNotNil
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationOptionsIdentifier] name];
    NSArray *objects = [[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromOptionsOperation error:nil];
    XCTAssertNotNil(objects, @"Nil should not be returned when a valid output string is provided.");
}

- (void)testParsedObjectArrayForOptionsOperationContainsValidObject
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationOptionsIdentifier] name];
    NSArray *objects = [[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromOptionsOperation error:nil];
    XCTAssertTrue([[objects objectAtIndex:0] isKindOfClass:[MRBrewInstallOption class]], @"Objects parsed from options operation output should be of class MRBrewFormula.");
}

- (void)testParsedObjectArrayForOptionsOperationContainsCorrectNumberOfObjects
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationOptionsIdentifier] name];
    NSArray *objects = [[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromOptionsOperation error:nil];
    XCTAssertTrue([objects count] == _fakeCountForOptionsOperation, @"The number of objects parsed should equal the number of lines in the output string separated by a newline character immediately followed by the string '--'.");
}

- (void)testNoErrorIsInstantiatedForOptionsOperationWithValidOutput
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationOptionsIdentifier] name];
    NSError *error = nil;
    [[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromOptionsOperation error:&error];
    XCTAssertNil(error, @"An error object should not be returned when a valid output string is provided.");
}

#pragma mark - Error Tests

- (void)testErrorIsInstantiatedForUnsupportedOperation
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationInstallIdentifier] name];
    NSError *error = nil;
    [[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromOptionsOperation error:&error];
    XCTAssertTrue([error isKindOfClass:[NSError class]], @"An error object should be returned for an unsupported operation.");
    XCTAssertTrue([error code] == MRBrewOutputParserErrorUnsupportedOperation, @"The error code should match the constant MRBrewOutputParserErrorUnsupportedOperation.");
    XCTAssertTrue([error domain] == MRBrewOutputParserErrorDomain, @"The domain should match the constant MRBrewOutputParserErrorDomain.");
}

- (void)testNilIsReturnedForUnsupportedOperation
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationInstallIdentifier] name];
    NSError *error = nil;
    NSArray *objects =[[MRBrewOutputParser outputParser] objectsForOperation:operation output:_fakeOutputFromOptionsOperation error:&error];
    XCTAssertNil(objects, @"Nil should be returned for an unsupported operations.");
}

- (void)testErrorIsInstantiatedForInvalidOptionsOperationOutput
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationOptionsIdentifier] name];
    NSError *error = nil;
    [[MRBrewOutputParser outputParser] objectsForOperation:operation output:@"invalid\noutput" error:&error];
    XCTAssertTrue([error isKindOfClass:[NSError class]], @"An error object should be returned for an invalid output string.");
    XCTAssertTrue([error code] == MRBrewOutputParserErrorSyntax, @"The error code should match the constant MRBrewOutputParserErrorSyntax.");
    XCTAssertTrue([error domain] == MRBrewOutputParserErrorDomain, @"The domain should match the constant MRBrewOutputParserErrorDomain.");
}

- (void)testNilIsReturnedForInvalidOptionsOperationOutput
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationOptionsIdentifier] name];
    NSError *error = nil;
    NSArray *objects = [[MRBrewOutputParser outputParser] objectsForOperation:operation output:@"invalid\noutput" error:&error];
    XCTAssertNil(objects, @"Nil should be returned for an invalid output string.");
}

- (void)testErrorIsInstantiatedForEmptyOutputString
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationListIdentifier] name];
    NSError *error = nil;
    [[MRBrewOutputParser outputParser] objectsForOperation:operation output:@"" error:&error];
    XCTAssertTrue([error isKindOfClass:[NSError class]], @"An error object should be returned for an empty output string.");
    XCTAssertTrue([error code] == MRBrewOutputParserErrorEmptyOutputString, @"The error code should match the constant MRBrewOutputParserErrorEmptyOutputString.");
    XCTAssertTrue([error domain] == MRBrewOutputParserErrorDomain, @"The domain should match the constant MRBrewOutputParserErrorDomain.");
}

- (void)testNilIsReturnedForEmptyOutputString
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationListIdentifier] name];
    NSError *error = nil;
    NSArray *objects = [[MRBrewOutputParser outputParser] objectsForOperation:operation output:@"" error:&error];
    XCTAssertNil(objects, @"Nil should be returned for an empty output string.");
}

- (void)testErrorIsInstantiatedForSearchOperationThatReturnsNoFormulaNames
{
    id operation = [OCMockObject mockForClass:[MRBrewOperation class]];
    [[[operation stub] andReturn:MRBrewOperationSearchIdentifier] name];
    NSError *error = nil;
    [[MRBrewOutputParser outputParser] objectsForOperation:operation output:@"No formula found" error:&error];
    XCTAssertTrue([error isKindOfClass:[NSError class]], @"An error object should be returned when the output string is prefixed with 'No formula found' message.");
    XCTAssertTrue([error code] == MRBrewOutputParserErrorNoFormulaForSearchResults, @"The error code should match the constant MRBrewOutputParserErrorNoFormulaForSearchResults.");
    XCTAssertTrue([error domain] == MRBrewOutputParserErrorDomain, @"The domain should match the constant MRBrewOutputParserErrorDomain.");
}

@end
