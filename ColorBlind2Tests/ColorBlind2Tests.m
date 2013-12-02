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

#pragma mark Private helpers

-(VWWColors*)colors{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"colors_complex" ofType:@"csv"];
    NSLog(@"Creating colors object from file %@", path);
    VWWColors *colors = [[VWWColors alloc]initWithPath:path];
    XCTAssert(colors, @"Failed to created colors object");
    return colors;
}

#pragma mark - Tests

-(void)testReadColorsFile{

    NSString* path = [[NSBundle mainBundle] pathForResource:@"colors_complex" ofType:@"csv"];
    NSLog(@"Reading colors from file %@", path);
    NSDictionary *colors = [VWWFileReader colorsFromFile:path];
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

-(void)testColorsInit{
    VWWColors *colors = [self colors];
    [colors printKeys];
    [colors printColors];
}

-(void)testColorAtIindex{
    VWWColors *colors = [self colors];
    for(NSInteger index = 0; index < colors.colorsKeys.count; index++){
        VWWColor *color = [colors colorAtIndex:index];
        XCTAssert(colors, @"Failed to get color from index: %d", index);
        color = nil; // deal with compiler warning
    }
}


-(void)testSetCurrentColor{
    VWWColors *colors = [self colors];
    
    for(NSInteger testIndex = 0; testIndex < 10; testIndex++){
        NSInteger index = arc4random() % colors.colorsKeys.count;
        NSString *key = colors.colorsKeys[index];
        VWWColor *color = colors.colorsDictionary[key];
        [colors setCurrentColor:color];
        
        // Test if strings match
        XCTAssertTrue([color.name isEqualToString:colors.currentColorKey], @"Failed to set current color with VWWColor");
    }
}



-(void)testSetCurrentColorFromUIColor{
    VWWColors *colors = [self colors];
    
    NSString *lastColor = @"";
    for(NSInteger testIndex = 0; testIndex < 10; testIndex++){
        const NSUInteger kMax = 100000;
        float r = (arc4random() % kMax) / (float)kMax;
        float g = (arc4random() % kMax) / (float)kMax;
        float b = (arc4random() % kMax) / (float)kMax;
        float a = (arc4random() % kMax) / (float)kMax;
        UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:a];
        [colors setCurrentColorFromUIColor:color];
        
        
        // Test if strings match
        XCTAssertFalse([colors.currentColorKey isEqualToString:lastColor], @"Failed to set current color with VWWColor");
    }
    
}


// NOTE: This method that this tests seems to be working, although could be better.
// Find a better way to TEST that it is working
-(void)testClosestColorFromRGB{
//    const NSUInteger kMax = 100000;
//    VWWColors *colors = [self colors];
//    
//    
//    for(NSInteger index = 0; index < 10; index++){
//        float r = (arc4random() % kMax) / (float)kMax;
//        float g = (arc4random() % kMax) / (float)kMax;
//        float b = (arc4random() % kMax) / (float)kMax;
////        float a = (arc4random() % kMax) / (float)kMax;
//        VWWColor *closestColor = [colors closestColorFromRed:r green:g blue:b];
//        
//        NSLog(@"i.r: %f i.g: %f i.b: %f", r, g, b);
//        NSLog(@"c.r: %f c.g: %f c.b: %f", closestColor.red, closestColor.green, closestColor.blue);
//        
//        float diffR = fabs(r - closestColor.red);
//        float diffG = fabs(r - closestColor.green);
//        float diffB = fabs(r - closestColor.blue);
//        float diffT = diffR + diffG + diffB;
//        NSLog(@"diffR: %f diffG: %f diffB: %f", diffR, diffG, diffB);
//        
//        // The test.... take some other colors to see if they are actually closer
//        for(NSString *key in colors.colorsKeys){
//            VWWColor *color = colors.colorsDictionary[key];
//            float dR = fabs(color.red - closestColor.red);
//            float dG = fabs(color.green - closestColor.green);
//            float dB = fabs(color.blue - closestColor.blue);
//            float dT = dR + dG + dB;
//            
//            if(dT > 0 && diffT > dT){
//                NSLog(@"d.r: %f d.g: %f d.b: %f", color.red, color.green, color.blue);
//                NSLog(@"nope");
//            }
//
//            XCTAssertTrue(diffT <= dT, @"Found a color with less difference than colosest color");
//        }
//
//    }
//    
////    NSUInteger index = arc4random() % colors.colorsKeys.count;

}


@end
