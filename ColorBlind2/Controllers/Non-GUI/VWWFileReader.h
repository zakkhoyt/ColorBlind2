//
//  VWWFileReader.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import <Foundation/Foundation.h>
#import "VWWColor.h"

@interface VWWFileReader : NSObject
+(NSMutableOrderedSet*)colorsFromFile:(NSString*)path;
@end
