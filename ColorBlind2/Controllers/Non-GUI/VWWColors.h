//
//  VWWColors.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/23/12.
//
//

#import <Foundation/Foundation.h>

@class VWWColor;

@interface VWWColors : NSObject

@property (nonatomic, strong, readonly) NSMutableOrderedSet *colorsSet;

// Represents the current color used by GUI. Notifications are broadcast when this changes
@property (nonatomic, readonly) NSInteger currentColorIndex;

// Returns a VWWColor in self.colors that most closely matches red green blue
-(VWWColor*)colorFromRed:(NSNumber*)red green:(NSNumber*)green blue:(NSNumber*)blue;

// Returns the closest opposite of currentColor. Math is done on r, g, b
-(VWWColor*)complimentColor;

// Returns a random VWWColor from our NSMutableArray colors
-(VWWColor*)randomColor;

// Sets the currentColor by color.name. Returns NO if no match is found.
-(BOOL)setCurrentColor:(VWWColor*)newColor;

// Sets the currentColor by finding the closest match from RGBA
-(BOOL)setCurrentColorFromUIColor:(UIColor*)newColor;



@end
