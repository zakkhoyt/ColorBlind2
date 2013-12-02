//
//  VWWColorTableViewCell.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWColorTableViewCell.h"
#import "VWWColor.h"


@interface VWWColorTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *hexLabel;

@end

@implementation VWWColorTableViewCell

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

-(void)setColor:(VWWColor *)color{
    _color = color;
    _colorView.backgroundColor = self.color.uiColor;
    _nameLabel.text = self.color.name;
    _redLabel.text = [NSString stringWithFormat:@"Red:%u", [_color hexFromFloat:_color.red]];
    _greenLabel.text = [NSString stringWithFormat:@"Green:%u", [_color hexFromFloat:_color.green]];
    _blueLabel.text = [NSString stringWithFormat:@"Blue:%u", [_color hexFromFloat:_color.blue]];
    _hexLabel.text = [NSString stringWithFormat:@"%@", [_color hexValue]];
}


@end
