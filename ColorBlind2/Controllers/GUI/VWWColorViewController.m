//
//  VWWColorViewController.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWColorViewController.h"
#import "VWWColor.h"

@interface VWWColorViewController ()

@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hexLabel;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;




@end

@implementation VWWColorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _colorView.backgroundColor = _color.uiColor;
    _nameLabel.text = _color.name;
    _redLabel.text = [NSString stringWithFormat:@"Red:%u", [_color hexFromFloat:_color.red]];
    _greenLabel.text = [NSString stringWithFormat:@"Green:%u", [_color hexFromFloat:_color.green]];
    _blueLabel.text = [NSString stringWithFormat:@"Blue:%u", [_color hexFromFloat:_color.blue]];
    _hexLabel.text = [NSString stringWithFormat:@"%@", [_color hexValue]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Public methods
//-(void)setColor:(VWWColor *)color{
//    _color = color;
//}

@end
