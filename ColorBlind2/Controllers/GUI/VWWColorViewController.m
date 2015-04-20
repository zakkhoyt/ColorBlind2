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
    self.navigationController.navigationBarHidden = NO;
    _colorView.backgroundColor = _color.uiColor;
    _nameLabel.text = _color.name;
    _redLabel.text = [NSString stringWithFormat:@"Red:%lu", (unsigned long)[_color hexFromFloat:_color.red]];
    _greenLabel.text = [NSString stringWithFormat:@"Green:%lu", (unsigned long)[_color hexFromFloat:_color.green]];
    _blueLabel.text = [NSString stringWithFormat:@"Blue:%lu", (unsigned long)[_color hexFromFloat:_color.blue]];
    _hexLabel.text = [NSString stringWithFormat:@"%@", [_color hexValue]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)shareColor{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [hud configureSmileAppearance];
//    hud.labelText = @"Caching image";
    
//    void (^shareImage)(UIImage *image) = ^(UIImage *image){
    NSString *colorString = [NSString stringWithFormat:@"ColorBlind on iOS\n%@", _color.prettyDescription];
    NSMutableArray *items = items = [@[colorString]mutableCopy];
    NSMutableArray *activities = [@[]mutableCopy];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:items
                                                                                        applicationActivities:activities];
    
    activityViewController.completionHandler = ^(NSString *activityType, BOOL completed){
        if(completed){
            [self dismissViewControllerAnimated:YES completion:^{
//                [SMMixPanel logMixpanelActivityType:activityType asset:self.asset];
            }];
        }
    };
    
    [self presentViewController:activityViewController animated:YES completion:nil];
//    };
    
//    [[SDWebImageManager sharedManager] downloadWithURL:self.asset.largeImageURL
//                                               options:SDWebImageRetryFailed
//                                              progress:^(NSUInteger receivedSize, long long expectedSize) {
//                                              } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
//                                                  if(image && finished){
//                                                      shareImage(image);
//                                                  }
//                                                  else if(error){
//                                                      // TODO handle error;
//                                                  }
//                                              }];
}


#pragma mark IBActions

- (IBAction)shareBarButtonAction:(id)sender {
    [self shareColor];
}



#pragma mark Public methods
//-(void)setColor:(VWWColor *)color{
//    _color = color;
//}

@end
