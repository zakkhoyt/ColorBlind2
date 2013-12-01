//
//  VWWColor.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import <Foundation/Foundation.h>

@interface VWWColor : NSObject

@property (nonatomic, retain) NSString* name; 
@property (nonatomic, retain) NSString* hex; 
@property (nonatomic) float red;
@property (nonatomic) float green;
@property (nonatomic) float blue;
@property (nonatomic, retain) NSNumber* hue;
@property (nonatomic, retain) UIColor*  color;


-(id)initWithName:(NSString*)name 
              hex:(NSString*)hex
              red:(NSUInteger)red
            green:(NSUInteger)green
             blue:(NSUInteger)blue
              hue:(NSNumber*)hue;

-(NSString*)description;


@end
