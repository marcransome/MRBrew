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

@interface MRBrewOutputParser ()

- (NSMutableArray *)parseFormulaeFromOutput:(NSString *)output;
- (NSMutableArray *)parseInstallOptionsFromOutput:(NSString *)output;

@end

@implementation MRBrewOutputParser

#pragma mark - Lifecycle

+ (instancetype)sharedOutputParser
{
    static MRBrewOutputParser *outputParser = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        outputParser = [[MRBrewOutputParser alloc] init];
    });
    
    return outputParser;
}

#pragma mark - Object Parsing (public)

- (NSArray *)objectsForOperation:(MRBrewOperation *)operation output:(NSString *)output
{
    NSMutableArray *objects = [NSMutableArray array];
    
    if ([[operation name] isEqualToString:MRBrewOperationListIdentifier]) {
        objects = [self parseFormulaeFromOutput:output];
    }
    else if ([[operation name] isEqualToString:MRBrewOperationSearchIdentifier]) {
        objects = [self parseFormulaeFromOutput:output];
    }
    
    return objects;
}

#pragma mark - Object Parsing (private)

- (NSMutableArray *)parseFormulaeFromOutput:(NSString *)output
{
    NSMutableArray *objects = [NSMutableArray array];
    
    NSArray *names = [output componentsSeparatedByString:@"\n"];
    
    for (NSString *name in names) {
        [objects addObject:[MRBrewFormula formulaWithName:name]];
    }
    
    return objects;
}

- (NSMutableArray *)parseInstallOptionsFromOutput:(NSString *)output
{
    
}

@end
