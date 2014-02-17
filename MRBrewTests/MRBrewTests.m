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

#import <XCTest/XCTest.h>
#import "MRBrew.h"

@interface MRBrewTests : XCTestCase

@end

@implementation MRBrewTests

static NSString* const MRBrewTestsDefaultBrewPath = @"/usr/local/bin/brew";

#pragma mark - Setup

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

#pragma mark - Brew Path Tests

- (void)testDefaultBrewPath
{
    // launching an NSTask with a nil path raises an exception so we guard against this
    // by initialising brewPath to the default brew path during +(void)initialize
    
    XCTAssertTrue([[[MRBrew sharedBrew] brewPath] isEqualToString:MRBrewTestsDefaultBrewPath], @"Should equal default brew path.");
}

- (void)testNilBrewPath
{
    // launching an NSTask with a nil path raises an exception so we guard against this
    // by setting brewPath to the default brew path whenever setBrewPath: is passed nil
    
    [[MRBrew sharedBrew] setBrewPath:nil];
    XCTAssertNotNil([[MRBrew sharedBrew] brewPath], @"Should not equal nil.");
    XCTAssertTrue([[[MRBrew sharedBrew] brewPath] isEqualToString:MRBrewTestsDefaultBrewPath], @"Setting path to nil should default instead to %@.", MRBrewTestsDefaultBrewPath);
    
    // cleanup
    [[MRBrew sharedBrew] setBrewPath:MRBrewTestsDefaultBrewPath];
}

- (void)testSetBrewPath
{
    NSString *path = @"/usr/bin/brew";
    [[MRBrew sharedBrew] setBrewPath:path];
    XCTAssertTrue([[[MRBrew sharedBrew] brewPath] isEqualToString:@"/usr/bin/brew"], @"Should equal new path %@.", path);
    
    // cleanup
    [[MRBrew sharedBrew] setBrewPath:MRBrewTestsDefaultBrewPath];
}

@end
