//
//  VWWColorCollectionReusableFlowView.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWColorCollectionReusableFlowView.h"

@interface VWWColorCollectionReusableFlowView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation VWWColorCollectionReusableFlowView

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


-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}
@end
