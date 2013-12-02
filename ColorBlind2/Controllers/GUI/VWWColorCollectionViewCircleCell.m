//
//  VWWColorCollectionViewCircleCell.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWColorCollectionViewCircleCell.h"
#import "VWWColor.h"




@interface VWWColorCollectionViewCircleCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@end

@implementation VWWColorCollectionViewCircleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setColor:(VWWColor *)color{
    _color = color;
    _colorView.backgroundColor = self.color.uiColor;
    _nameLabel.text = [self.color.name substringToIndex:1];
//    _redLabel.text = [NSString stringWithFormat:@"Red:%u", [_color hexFromFloat:_color.red]];
//    _greenLabel.text = [NSString stringWithFormat:@"Green:%u", [_color hexFromFloat:_color.green]];
//    _blueLabel.text = [NSString stringWithFormat:@"Blue:%u", [_color hexFromFloat:_color.blue]];
//    _hexLabel.text = [NSString stringWithFormat:@"%@", [_color hexValue]];
}




@end
