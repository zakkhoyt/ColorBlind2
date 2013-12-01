//
//  ColorBlind2Tests.m
//  ColorBlind2Tests
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VWWColors.h"
#import "VWWFileReader.h"

@interface ColorBlind2Tests : XCTestCase

@end

@implementation ColorBlind2Tests

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

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

-(void)testReadColorsFile{

    NSString* path = [[NSBundle mainBundle] pathForResource:@"colors_complex" ofType:@"csv"];
    NSLog(@"Reading colors from file %@", path);
    NSOrderedSet *colors = [VWWFileReader colorsFromFile:path];
    XCTAssert(colors, @"Failed to read colors from %@", path);
    
//    if(self.colors.count){
//        self.currentColor = (VWW_Color*)(self.colors)[0];
//    }
//    else{
//        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
//        NSString* strError = @"Failed to load colors file";
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error" message:strError delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"okay", nil];
//        [alert show];
//        return nil;
//    }

}

@end
