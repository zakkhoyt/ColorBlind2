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
@property (nonatomic, strong, readwrite) NSMutableDictionary *colorsDictionary;
@property (nonatomic, strong, readwrite) NSArray *colorsKeys;
@property (nonatomic, readwrite) NSString *currentColorKey;
@end

@implementation VWWColors

#pragma mark - Public methods


-(id)initWithPath:(NSString*)path{
    self = [super init];
    if(self){
        _colorsDictionary = [[VWWFileReader colorsFromFile:path]mutableCopy];
        if(self.colorsDictionary == nil || self.colorsDictionary.count == 0){
            VWW_LOG_WARN(@"Failed to load any colors from %@", path);
        } else {
            // We have a dictionary, now let's generate and sort the keys
            NSMutableArray *unsortedColorsKeys = [[NSMutableArray alloc]initWithCapacity:self.colorsDictionary.allValues.count];
            for(VWWColor *color in self.colorsDictionary.allValues){
                [unsortedColorsKeys addObject:color.name];
            }
            self.colorsKeys = [self sortColors:unsortedColorsKeys];
            
            // Set current key
            if(self.colorsKeys.count){
                self.currentColorKey = self.colorsKeys[0];
            }
        }
    }
    else{
        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
    }
    return self;
}


// Logs all colors to the console
-(void)printColors{
    
    NSLog(@"********************** Begin printing all colors *************************");
    for(NSInteger index = 0; index < self.colorsKeys.count; index++){
        NSString *key = self.colorsKeys[index];
        VWWColor *color = self.colorsDictionary[key];
        NSLog(@"Color: %@", color.description);
    }
    NSLog(@"********************** End printing all colors *************************");
}
-(void)printKeys{
    
    NSLog(@"********************** Begin printing all keys *************************");
    for(NSString *key in self.colorsKeys){
        NSLog(@"Key: %@", key);
    }
    NSLog(@"********************** End printing all keys *************************");
}


-(VWWColor*)colorAtIndex:(NSUInteger)index{
    if(index < self.colorsKeys.count){
        NSString *key = self.colorsKeys[index];
        VWWColor *color = self.colorsDictionary[key];
        return color;
    } else {
        VWW_LOG_WARN(@"Requesting index that is greater than bounds: %d/%d", index, self.colorsDictionary.count);
        return nil;
    }
}


-(VWWColor*)colorFromRed:(float)red green:(float)green blue:(float)blue{

    VWW_LOG_TODO(@"Implement");
    return nil;
}


-(VWWColor*)complimentColor{
//    // TODO: implement
//    return self.currentColor;
    VWW_LOG_TODO(@"Implement");
    return nil;
}



-(VWWColor*)randomColor{
//    if(!self.colorsSet){
//        VWW_LOG_WARN(@"No colors are loaded.");
//        return nil;
//    }
//    
//    int r = arc4random() % self.colorsSet.count;
//    return self.colorsSet[r];
    VWW_LOG_TODO(@"Implement");
    return nil;
    
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

-(VWWColor*)closestColorFromRed:(float)red green:(float)green blue:(float)blue{
//    if(!self.colorsDictionary){
//        VWW_LOG_WARN(@"No colors are loaded")
//        return nil;
//    }
//
//    
//    NSUInteger closestIndex = 0;
//    NSUInteger smallestDifference = 4.0; // 1.0 + 1.0 + 1.0 + 1.0 is the largest possible difference (RGBA)
//
////    for(NSUInteger index = 0; index < self.colors.count; index++){
//    for(NSString *key in self.colorsKeys){
//        VWWColor* color = self.colorsDictionary[key];
//        float diffRed = fabs(color.red - red);
//        float diffGreen = fabs(color.green - green);
//        float diffBlue = fabs(color.blue - blue);
//        if(diffRed + diffGreen + diffBlue < smallestDifference){
//            smallestDifference = diffRed + diffGreen + diffBlue;
//            closestIndex = index;
//        }
//    }
//    
//    return (VWWColor*)(self.colors)[closestIndex];
    return  nil;
}


-(NSArray*)sortColors:(NSArray*)buddies{
    // Lex sort
    NSArray *sortedColors = [buddies sortedArrayUsingComparator:^NSComparisonResult(NSString *name1, NSString* name2) {
        return [name1 compare:name2 options:NSCaseInsensitiveSearch];
    }];
    return sortedColors;
}


@end
