//
//  VWWFileReader.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import "VWWFileReader.h"

@interface VWWFileReader ()
@end

@implementation VWWFileReader

#pragma mark Custom methods

+(NSDictionary*)colorsFromFile:(NSString*)path{
    const NSUInteger kNameIndex = 0;
    const NSUInteger kHexIndex = 1;
    const NSUInteger kRedIndex = 2;
    const NSUInteger kGreenIndex = 3;
    const NSUInteger kBlueIndex = 4;
    const NSUInteger kHueIndex = 5;
    const NSUInteger kNumOfElementsPerLine = 6;

    
    NSError* error;
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:&error];
    NSArray* lines = [fileContents componentsSeparatedByString:@"\n"];
    NSMutableDictionary* colors = [[NSMutableDictionary alloc]initWithCapacity:lines.count];

    VWW_LOG_TODO(@"add support for alpha and other color properties")
    
    // Each line in the file will look like this:
    // "name, hex, red, green, blue, hue"
    // And with values:
    // string, string, 0-100, 0-100, 0-100, 0-255
    for(NSString* line in lines){
        NSArray* elements = [line componentsSeparatedByString:@","];
        
        if(elements.count != kNumOfElementsPerLine){
            VWW_LOG_WARN(@"Invalid number of sections per line");
            continue;
        }
        
        NSString* name =    (NSString*)elements[kNameIndex];
        NSString* hex =     (NSString*)elements[kHexIndex];
        NSNumber* red =     (NSNumber*)elements[kRedIndex];
        NSNumber* green =   (NSNumber*)elements[kGreenIndex];
        NSNumber* blue =    (NSNumber*)elements[kBlueIndex];
        NSNumber* hue =     (NSNumber*)elements[kHueIndex];

        
        VWWColor* color = [[VWWColor alloc]initWithName:name hex:hex red:red.integerValue green:green.integerValue blue:blue.integerValue hue:hue];
        colors[name] = color;
        
    }
    
    NSLog(@"Loaded %d colors from colors.csv", colors.allKeys.count);
    return [NSDictionary dictionaryWithDictionary:colors];
}


@end
