//
//  MRBrewTests.m
//  MRBrewTests
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

#import "MRBrewTests.h"
#import "MRBrew.h"

@implementation MRBrewTests

static NSString* const MRBrewTestsDefaultBrewPath = @"/usr/local/bin/brew";

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

- (void)testDefaultBrewPath
{
    // launching an NSTask with a nil path raises an exception so we guard against this
    // by initialising brewPath to the default brew path during +(void)initialise
    
    STAssertTrue([[MRBrew brewPath] isEqualToString:MRBrewTestsDefaultBrewPath], @"Should equal default brew path.");
}

- (void)testNilBrewPath
{
    // launching an NSTask with a nil path raises an exception so we guard against this
    // by setting brewPath to the default brew path whenever setBrewPath: is passed nil
    
    [MRBrew setBrewPath:nil];
    STAssertNotNil([MRBrew brewPath], @"Should not equal nil.");
    STAssertTrue([[MRBrew brewPath] isEqualToString:MRBrewTestsDefaultBrewPath], @"Setting path to nil should default instead to %@.", MRBrewTestsDefaultBrewPath);
    
    // cleanup
    [MRBrew setBrewPath:MRBrewTestsDefaultBrewPath];
}

- (void)testSetBrewPath
{
    NSString *path = @"/usr/bin/brew";
    [MRBrew setBrewPath:path];
    STAssertTrue([[MRBrew brewPath] isEqualToString:@"/usr/bin/brew"], @"Should equal new path %@.", path);
    
    // cleanup
    [MRBrew setBrewPath:MRBrewTestsDefaultBrewPath];
}

@end
