//
//  VWWColors.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/23/12.
//
//

#import "VWWColors.h"
#import "VWWFileReader.h"
#import "VWWColor.h"

@interface VWWColors ()
@property (nonatomic, strong, readwrite) NSMutableOrderedSet *colorsSet;
@property (nonatomic, readwrite) NSInteger currentColorIndex;
@end

@implementation VWWColors

#pragma mark - Public methods


-(id)initWithPath:(NSString*)path{
    self = [super init];
    if(self){
        _colorsSet = [VWWFileReader colorsFromFile:path];
        if(self.colorsSet == nil || self.colorsSet.count == 0){
            VWW_LOG_WARN(@"Failed to load any colors from %@", path);
        } else {
            self.currentColorIndex = 0;
        }
    }
    else{
        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
    }
    return self;
}


-(VWWColor*)colorAtIndex:(NSUInteger)index{
    if(index < self.colorsSet.count){
        VWWColor *color = self.colorsSet[index];
        return color;
    } else {
        VWW_LOG_WARN(@"Requesting index that is greater than bounds: %d/%d", index, _colorsSet.count);
        return nil;
    }
}


-(VWWColor*)colorFromRed:(NSNumber*)red green:(NSNumber*)green blue:(NSNumber*)blue{
//    if(!self.colors){
//        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
//        return nil;
//    }
//
//    NSUInteger closestIndex = 0;
//    NSUInteger smallestDifference = 300; // 100+100+100 is the largest possible difference
//    
//    for(NSUInteger index = 0; index < self.colors.count; index++){
//        VWWColor* color = (self.colors)[index];
//        NSUInteger diffRed = abs(color.red.integerValue - red.integerValue);
//        NSUInteger diffGreen = abs(color.green.integerValue - green.integerValue);
//        NSUInteger diffBlue = abs(color.blue.integerValue - blue.integerValue);
//        if(diffRed + diffGreen + diffBlue < smallestDifference){
//            smallestDifference = diffRed + diffGreen + diffBlue;
//            closestIndex = index;
//        }
//    }
//    
//    return (VWWColor*)(self.colors)[closestIndex];
    return nil;
}


-(VWWColor*)complimentColor{
//    // TODO: implement
//    return self.currentColor;
    return nil;
}



-(VWWColor*)randomColor{
    if(!self.colorsSet){
        VWW_LOG_WARN(@"No colors are loaded.");
        return nil;
    }
    
    int r = arc4random() % self.colorsSet.count;
    return self.colorsSet[r];
}



// Loop through our array of VWWColor objects and do a case insensitive compare on the name property
// Also dispatch a Notification Center event
-(BOOL)setCurrentColor:(VWWColor*)newColor{
//    if(!self.colors){
//        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
//        return NO;
//    }
//
//    for(NSUInteger index = 0; index < self.colors.count; index++){
//        VWWColor* color = (self.colors)[index];
//        if([color.name caseInsensitiveCompare:newColor.name] == NSOrderedSame){
//            _currentColor = color;
//
//            // Stuff color into an NSDictionary and sent it along with the notification. 
//            NSDictionary *userInfo = @{@"currentColor": _currentColor};
////            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%s", NC_CURRENT_COLOR_CHANGED] object:self userInfo:userInfo];
//            return YES;
//        }
//    }
//    
//    // we never found color in our list of colors. Return NO;
//    return NO;
    
    VWW_LOG_TODO(@"Implement");
    return NO;
}

// Loop through our array of VWWColor objects and compare normalized RGB properties
// Also dispatch a Notification Center event
-(BOOL)setCurrentColorFromUIColor:(UIColor*)newColor{
//    if(!self.colors){
//        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
//        return NO;
//    }
//    
//    for(NSUInteger index = 0; index < self.colors.count; index++){
//        VWWColor* color = (self.colors)[index];
//
//        CGFloat red = 0.0f;
//        CGFloat green = 0.0f;
//        CGFloat blue = 0.0f;
//        CGFloat alpha = 0.0f;
//        
//        if(![newColor getRed:&red green:&green blue:&blue alpha:&alpha]){
//            // Error occured getting rgba. Fail silently
//            continue;
//        }
//
//// TODO: BUG: color "Asparagus" fails to function here
////        NSLog(@"%d=%d\t%d=%d\t%d=%d",
////              (NSUInteger)(red*100), color.red.integerValue,
////              (NSUInteger)(green*100), color.green.integerValue,
////              (NSUInteger)(blue*100), color.blue.integerValue);
//        
//        // local vars are 0.0 - 1.0
//        // color.(vars) are 0 - 100.
//        // Normalize and compare. Disregard alpha
//        if((NSUInteger)(red*100) == color.red.integerValue &&
//           (NSUInteger)(green*100) == color.green.integerValue &&
//           (NSUInteger)(blue*100) == color.blue.integerValue){
//
////            [_currentColor release];
//            _currentColor = color;
////            [_currentColor retain];
//            
//            // Stuff color into an NSDictionary and sent it along with the NSNotification.
//            NSDictionary *userInfo = @{@"currentColor": _currentColor};
////            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%s", NC_CURRENT_COLOR_CHANGED] object:self userInfo:userInfo];
//            return YES;
//        }
//    }
//    
//    // we never found color in our list of colors. Return NO;
//    return NO;
    
    VWW_LOG_TODO(@"Implement");
    return  NO;
}

#pragma mark - Private methods



@end
