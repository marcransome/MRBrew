//
//  MRBrewOutputParser.m
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

#import "MRBrewOutputParser.h"
#import "MRBrewOperation.h"
#import "MRBrewConstants.h"
#import "MRBrewFormula.h"
#import "MRBrewInstallOption.h"

NSString * const MRBrewOutputParserErrorDomain = @"uk.co.fidgetbox.MRBrew";

@interface MRBrewOutputParser ()

- (NSArray *)parseFormulaeFromOutput:(NSString *)output;
- (NSArray *)parseFormulaeFromSearchOperationOutput:(NSString *)output;
- (NSArray *)parseFormulaeFromListOperationOutput:(NSString *)output;
- (NSArray *)parseInstallOptionsFromOutput:(NSString *)output;

@end

@implementation MRBrewOutputParser

#pragma mark - Lifecycle

+ (instancetype)outputParser
{
    return [[self alloc] init];
}

#pragma mark - Object Parsing (public)

- (NSArray *)objectsForOperation:(MRBrewOperation *)operation output:(NSString *)output error:(NSError * __autoreleasing *)error
{
    // return nil if the output string is empty and instantiate an error object if a pointer was provided
    if (![output length] > 0) {
        [self errorForErrorType:MRBrewOutputParserErrorEmptyOutputString usingPointer:error];
        
        return nil;
    }
    
    NSArray *objects = nil;
    BOOL errorOccured = NO;
    
    if ([[operation name] isEqualToString:MRBrewOperationListIdentifier]) {
        objects = [self parseFormulaeFromListOperationOutput:output];
    }
    else if ([[operation name] isEqualToString:MRBrewOperationSearchIdentifier]) {
        objects = [self parseFormulaeFromSearchOperationOutput:output];
        
        if (!objects) {
            [self errorForErrorType:MRBrewOutputParserErrorNoFormulaForSearchResults usingPointer:error];
            errorOccured = YES;
        }
    }
    else if ([[operation name] isEqualToString:MRBrewOperationOptionsIdentifier]) {
        objects = [self parseInstallOptionsFromOutput:output];
        
        if (!objects) {
            [self errorForErrorType:MRBrewOutputParserErrorSyntax usingPointer:error];
            errorOccured = YES;
        }
    }
    else {  // an unsupported operation type was specified
        [self errorForErrorType:MRBrewOutputParserErrorUnsupportedOperation usingPointer:error];
        errorOccured = YES;
    }
    
    // return nil if an error occured, otherwise return the object array
    return (errorOccured ? nil : objects);
}

#pragma mark - Object Parsing (private)

/* Parse output string in which each line is expected to contain the name of a
 * formula, and return an array of one or more MRBrewFormula objects.
 */
- (NSArray *)parseFormulaeFromOutput:(NSString *)output
{
    NSMutableArray *objects = [NSMutableArray array];
    
    NSArray *names = [output componentsSeparatedByString:@"\n"];
    
    for (NSString *name in names) {
        if ([name isEqualToString:@""]) {
            continue;
        }
        
        [objects addObject:[MRBrewFormula formulaWithName:name]];
    }
    
    return [NSArray arrayWithArray:objects];
}

/* Parse output string in which each line is expected to contain the name of a
 * formula, and return an array of one or more MRBrewFormula objects. Returns
 * nil if the output string has a prefix indicating that no formula names are
 * specified.
 */
- (NSArray *)parseFormulaeFromSearchOperationOutput:(NSString *)output
{
    if ([output hasPrefix:@"No formula found"]) {
        return nil;
    }
    
    return [self parseFormulaeFromOutput:output];
}

- (NSArray *)parseFormulaeFromListOperationOutput:(NSString *)output
{
    NSArray *formulae = [self parseFormulaeFromOutput:output];
    
    for (MRBrewFormula *formula in formulae) {
        [formula setIsInstalled:YES];
    }
    
    return [NSArray arrayWithArray:formulae];
}

/* Parse output string that is expected to contain two lines of text for each
 * option defined by homebrew. The first line should begin with the string '--',
 * and the second should begin with a tab character. Returns nil if the string
 * parsing was unsuccessful, an empty array if the output string if empty, or an
 * array of one or more MRBrewFormula objects if parsing was successful.
 */
- (NSArray *)parseInstallOptionsFromOutput:(NSString *)output
{
    NSMutableArray *objects = [NSMutableArray array];

    NSUInteger optionIndex = 0;
    NSUInteger descriptionIndex = 1;
    
    for (NSString *line in [output componentsSeparatedByString:@"\n--"]) {
        
        NSMutableArray *optionWithDescription = [[line componentsSeparatedByString:@"\t"] mutableCopy];
        
        // after separating the components into an array, we expect there to be
        // precisely two elements -- the option and description strings
        if ([optionWithDescription count] != 2) {
            return nil;
        }
        
        // replace '--' prefix that was removed when separating into components
        if (![[optionWithDescription objectAtIndex:optionIndex] hasPrefix:@"--"]) {
            [optionWithDescription setObject:[NSString stringWithFormat:@"--%@", [optionWithDescription objectAtIndex:optionIndex]] atIndexedSubscript:optionIndex];
        }
        
        // remove unnecessary line breaks from the option string
        if ([[optionWithDescription objectAtIndex:optionIndex] rangeOfString:@"\n"].location != NSNotFound) {
            [optionWithDescription setObject:[[optionWithDescription objectAtIndex:optionIndex] stringByReplacingOccurrencesOfString:@"\n" withString:@""] atIndexedSubscript:optionIndex];
        }
        
        // remove unnecessary line breaks from the description string
        if ([[optionWithDescription objectAtIndex:descriptionIndex] rangeOfString:@"\n"].location != NSNotFound) {
            [optionWithDescription setObject:[[optionWithDescription objectAtIndex:descriptionIndex] stringByReplacingOccurrencesOfString:@"\n" withString:@""] atIndexedSubscript:descriptionIndex];
        }
        
        // instantiate an install option object for each option we encounter
        MRBrewInstallOption *option = [MRBrewInstallOption installOptionWithName:[optionWithDescription objectAtIndex:optionIndex] description:[optionWithDescription objectAtIndex:descriptionIndex] selected:NO];
        [objects addObject:option];
    }
    
    return [NSArray arrayWithArray:objects];
}


/* Sets the error pointer (if provided) to a newly instantiated error object
 * with a default error domain and the specified error code.
 */
- (void)errorForErrorType:(MRBrewOutputParserError)type usingPointer:(NSError * __autoreleasing *)errorPtr
{
    // instantiate an error object using the provided pointer, if one exists
    if (errorPtr) {
        MRBrewOutputParserError errorCode;
        NSString *errorDescription;
        
        // determine the error type and set an appropriate error code and description
        switch (type) {
            case MRBrewOutputParserErrorEmptyOutputString:
                errorCode = MRBrewOutputParserErrorEmptyOutputString;
                errorDescription = @"The output string was empty.";
                break;
            case MRBrewOutputParserErrorUnsupportedOperation:
                errorCode = MRBrewOutputParserErrorUnsupportedOperation;
                errorDescription = @"Object parsing for this type of operation is not supported.";
                break;
                
            case MRBrewOutputParserErrorNoFormulaForSearchResults:
                errorCode = MRBrewOutputParserErrorNoFormulaForSearchResults;
                errorDescription = @"Output string for search operation did not list any formula names.";
                break;
                
            case MRBrewOutputParserErrorSyntax:
                errorCode = MRBrewOutputParserErrorSyntax;
                errorDescription = @"Output string was not of the expected format.";
                break;
        }
        
        *errorPtr = [NSError errorWithDomain:MRBrewOutputParserErrorDomain code:errorCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorDescription, NSLocalizedDescriptionKey, nil]];
    }
}

@end
