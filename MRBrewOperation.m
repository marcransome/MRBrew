//
//  MRBrewOperation.m
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

#import "MRBrewOperation.h"
#import "MRBrewFormula.h"

NSString* const MRBrewOperationUpdateIdentifier = @"update";
NSString* const MRBrewOperationListIdentifier = @"list";
NSString* const MRBrewOperationSearchIdentifier = @"search";
NSString* const MRBrewOperationInstallIdentifier = @"install";
NSString* const MRBrewOperationInfoIdentifier = @"info";
NSString* const MRBrewOperationRemoveIdentifier = @"remove";
NSString* const MRBrewOperationOptionsIdentifier = @"options";

@implementation MRBrewOperation

- (id)initWithOperation:(MRBrewOperationType)operation
                formula:(MRBrewFormula *)formula
             parameters:(NSArray *)parameters
{
    if (self = [super init]) {
        switch (operation) {
            case MRBrewOperationUpdate:
                _operation = MRBrewOperationUpdateIdentifier;
                break;
            case MRBrewOperationList:
                _operation = MRBrewOperationListIdentifier;
                break;
            case MRBrewOperationSearch:
                _operation = MRBrewOperationSearchIdentifier;
                break;
            case MRBrewOperationInstall:
                _operation = MRBrewOperationInstallIdentifier;
                break;
            case MRBrewOperationInfo:
                _operation = MRBrewOperationInfoIdentifier;
                break;
            case MRBrewOperationRemove:
                _operation = MRBrewOperationRemoveIdentifier;
                break;
            case MRBrewOperationOptions:
                _operation = MRBrewOperationOptionsIdentifier;
                break;
        }
        _formula = formula;
        _parameters = [parameters copy];
    }
    
    return self;
}

- (id)initWithOperationString:(NSString *)operation
                      formula:(MRBrewFormula *)formula
                   parameters:(NSArray *)parameters
{
    if (self = [super init]) {
        _operation = [operation copy];
        _formula = formula;
        _parameters = [parameters copy];
    }
    
    return self;
}

+ (id)operationWithOperation:(MRBrewOperationType)operation formula:(MRBrewFormula *)formula parameters:(NSArray *)parameters;
{
    return [[self alloc] initWithOperation:operation formula:formula parameters:parameters];
}

+ (id)operationWithStringOperation:(NSString *)operation formula:(MRBrewFormula *)formula parameters:(NSArray *)parameters
{
    return [[self alloc] initWithOperationString:operation formula:formula parameters:parameters];
}

+ (id)updateOperation
{
    return [[self alloc] initWithOperation:MRBrewOperationUpdate formula:nil parameters:nil];
}

+ (id)listOperation
{
    return [[self alloc] initWithOperation:MRBrewOperationList formula:nil parameters:nil];
}

+ (id)searchOperation
{
    return [[self alloc] initWithOperation:MRBrewOperationSearch formula:nil parameters:nil];
}

+ (id)installOperation:(MRBrewFormula *)formula
{
    return [[self alloc] initWithOperation:MRBrewOperationInstall formula:formula parameters:nil];
}

+ (id)infoOperation:(MRBrewFormula *)formula
{
    return [[self alloc] initWithOperation:MRBrewOperationInfo formula:formula parameters:nil];
}

+ (id)removeOperation:(MRBrewFormula *)formula
{
    return [[self alloc] initWithOperation:MRBrewOperationRemove formula:formula parameters:nil];
}

+ (id)optionsOperation:(MRBrewFormula *)formula
{
    return [[self alloc] initWithOperation:MRBrewOperationOptions formula:formula parameters:nil];
}

@end
