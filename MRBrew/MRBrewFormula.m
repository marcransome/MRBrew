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
    return [self initWithName:nil
                        isNew:NO
                    isUpdated:NO
                  isInstalled:NO];
}

- (id)initWithName:(NSString *)name
{
    return [self initWithName:name
                        isNew:NO
                    isUpdated:NO
                  isInstalled:NO];
}

- (id)initWithName:(NSString *)name
             isNew:(BOOL)isNew
         isUpdated:(BOOL)isUpdated
       isInstalled:(BOOL)isInstalled
{
    if (self = [super init]) {
        _name = name == nil ? @"" : [name copy];  // replace nil with empty string
        _isUpdated = isUpdated;
        _isNew = isNew;
        _isInstalled = isInstalled;
    }
    
    return self;
}

+ (id)formulaWithName:(NSString *)name
{
    return [[self alloc] initWithName:name
                                isNew:NO
                            isUpdated:NO
                          isInstalled:NO];
}

+ (id)formulaWithName:(NSString *)name
                isNew:(BOOL)isNew
            isUpdated:(BOOL)isUpdated
          isInstalled:(BOOL)isInstalled
{
    return [[self alloc] initWithName:name
                                isNew:isNew
                            isUpdated:isUpdated
                          isInstalled:isInstalled];
}

- (id)copyWithZone:(NSZone *)zone
{
    MRBrewFormula *copy = [[MRBrewFormula alloc] init];
    [copy setName:[[self name] copy]];
    [copy setIsUpdated:[self isUpdated]];
    [copy setIsNew:[self isNew]];
    [copy setIsInstalled:[self isInstalled]];
    
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
    if ([self isUpdated] != [formula isUpdated])
        return NO;
    if ([self isNew] != [formula isNew])
        return NO;
    if ([self isInstalled] != [formula isInstalled])
        return NO;
    
    return YES;
}

@end
