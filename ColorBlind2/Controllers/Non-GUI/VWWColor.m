//
//  VWWColor.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import "VWWColor.h"


@interface VWWColor ()
@end

@implementation VWWColor


#pragma mark Custom methods

-(id)initWithName:(NSString*)name
              hex:(NSString*)hex
              red:(NSNumber*)red
            green:(NSNumber*)green
             blue:(NSNumber*)blue
              hue:(NSNumber*)hue{
    
    self = [super init];
    if(self){
        _name = name;
        _hex = hex;
        _red = red;
        _green = green;
        _blue = blue;
        _hue = hue;
        _color = [UIColor colorWithRed:self.red.intValue/100.0f green:self.green.intValue/100.0f blue:self.blue.intValue/100.0f alpha:1.0];
    }
    return self;
}

-(NSString*)description{
    NSString* colorDescription = [NSString stringWithFormat:@"hex:#%@\nred:%d\ngreen:%d\nblue:%d",
                                 self.hex,
                                 self.red.integerValue,
                                 self.green.integerValue,
                                 self.blue.integerValue];
    return  colorDescription;
    
}


@end
