//
//  ClassInspectionTests.m
//  eppz!model
//
//  Created by Borbás Geri on 01/05/14.
//  Copyright (c) 2010-2014 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <XCTest/XCTest.h>

#import "EPPZModel.h"
#import "NSObject+EPPZModel_inspecting.h"

#import "Human.h"
#import "SuperHero.h"


#pragma mark - Test case


@interface ClassInspectionTests : XCTestCase
@property (nonatomic, strong) SuperHero *model;
@end


@implementation ClassInspectionTests


-(void)setUp
{
    [super setUp];
    self.model = [SuperHero new];
}

-(void)testPropertyNameList
{
    XCTAssertEqualObjects(self.model.className,
                          @"SuperHero",
                          @"Class name should work.");
    
    XCTAssertTrue([self.model.propertyNames containsObject:@"name"],
                  @"Property name list should contain superclass properties.");
    
    XCTAssertTrue([self.model.propertyNames containsObject:@"hairColor"],
                  @"Property name list should contain superclass properties.");
    
    XCTAssertTrue([self.model.propertyNames containsObject:@"civilianName"],
                  @"Property name list should contain class properties.");
}


@end
