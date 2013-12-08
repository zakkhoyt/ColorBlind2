//
//  VWWMixerViewController.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/7/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWMixerViewController.h"
#import "VWWColors.h"
#import "VWWColor.h"
@interface VWWMixerViewController ()

@property (weak, nonatomic) IBOutlet UIView *colorContainerView;

@property (nonatomic) BOOL hasLoaded;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *hexLabel;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;







@property (weak, nonatomic) IBOutlet UISlider *slider1;
@property (weak, nonatomic) IBOutlet UISlider *slider2;

@end

@implementation VWWMixerViewController

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
}



- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if(self.hasLoaded == NO){
        self.hasLoaded = YES;
        self.redSlider.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
        self.blueSlider.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
        self.greenSlider.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
        self.alphaSlider.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
        
        NSString *key = [VWWColors sharedInstance].currentColorKey;
        VWWColor *color = [VWWColors sharedInstance].colorsDictionary[key];
        
        
        self.redSlider.value = color.red;
        self.greenSlider.value = color.green;
        self.blueSlider.value = color.blue;
        
        
    }
    
    [self.view layoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Private methods
-(void)updateColorFromMixers{
    
    float r = self.redSlider.value;
    float g = self.greenSlider.value;
    float b = self.blueSlider.value;
    VWWColor *color = [[VWWColors sharedInstance] closestColorFromRed:r green:g blue:b];
    

    _colorView.backgroundColor = color.uiColor;
    _nameLabel.text = color.name;
    _redLabel.text = [NSString stringWithFormat:@"Red:%ld", (long)[color hexFromFloat:color.red]];
    _greenLabel.text = [NSString stringWithFormat:@"Green:%ld", (long)[color hexFromFloat:color.green]];
    _blueLabel.text = [NSString stringWithFormat:@"Blue:%ld", (long)[color hexFromFloat:color.blue]];
    _hexLabel.text = [NSString stringWithFormat:@"%@", [color hexValue]];
}

#pragma mark IBActions

- (IBAction)redSliderValueChanged:(id)sender {
    [self updateColorFromMixers];
}
- (IBAction)greenSliderValueChanged:(id)sender {
    [self updateColorFromMixers];
}
- (IBAction)blueSliderValueChanged:(id)sender {
    [self updateColorFromMixers];
}
- (IBAction)alphaSliderValueChanged:(id)sender {
    [self updateColorFromMixers];
}
@end
