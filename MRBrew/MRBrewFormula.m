//
//  MRFormula.m
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

#import "MRBrewFormula.h"

@implementation MRBrewFormula

- (id)init {
    
    if (self = [super init]) {
        _name = @"";
        _updated = NO;
        _newFormula = NO;
        _installed = NO;
    }
    
    return self;
}

- (id)initWithName:(NSString *)name
{
    return [self initWithName:name newFormula:NO];
}

- (id)initWithName:(NSString *)name newFormula:(BOOL)newFlag
{
    if (self = [super init]) {
        _name = [name copy];
        _updated = NO;
        _newFormula = NO;
        _installed = NO;
    }
    
    return self;
}

+ (id)formulaWithName:(NSString *)name
{
    return [[self alloc] initWithName:name];
}

+ (id)formulaWithName:(NSString *)name newFormula:(BOOL)newFlag
{
    return [[self alloc] initWithName:name newFormula:newFlag];
}

- (id)copyWithZone:(NSZone *)zone
{
    MRBrewFormula *copy = [[MRBrewFormula alloc] init];
    [copy setName:[[self name] copy]];
    [copy setUpdated:[self updated]];
    [copy setNewFormula:[self newFormula]];
    [copy setInstalled:[self installed]];
    
    return copy;
}

- (BOOL)isEqualToFormula:(MRBrewFormula *)formula
{
    if (self == formula)
        return YES;
    
    if (!formula || ![formula isKindOfClass:[self class]])
        return NO;
    
    if (![[self name] isEqualToString:[formula name]])
        return NO;
    if ([self updated] != [formula updated])
        return NO;
    if ([self newFormula] != [formula newFormula])
        return NO;
    if ([self installed] != [formula installed])
        return NO;
    
    return YES;
}

@end
