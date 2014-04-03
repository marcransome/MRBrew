//
//  MRBrewInstallOptionTests.m
//  MRBrew
//
//  Created by Marc Ransome on 03/04/2014.
//  Copyright (c) 2014 fidgetbox. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MRBrewInstallOption.h"

@interface MRBrewInstallOptionTests : XCTestCase

@end

@implementation MRBrewInstallOptionTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInstallOptionCreatedWithInitMethodHasCorrectProperties
{
    // execute
    MRBrewInstallOption *installOption = [[MRBrewInstallOption alloc] init];
    
    // verify
    XCTAssertNil([installOption name], @"Install option 'name' property should equal nil.");
    XCTAssertNil([installOption description], @"Install option 'description' property should equal nil.");
    XCTAssertTrue([installOption selected] == NO, @"Formula 'installed' property should equal NO.");
}

@end
