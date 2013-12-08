//
//  VWWCaptureFromPhotoViewController.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWCaptureFromPhotoViewController.h"
#import "VWWFloatingColorViewController.h"


@interface VWWCaptureFromPhotoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>{
    CGFloat _firstX;
    CGFloat _firstY;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) VWWFloatingColorViewController *floatingColorViewController;


@end

@implementation VWWCaptureFromPhotoViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)choosePhotoButtonTouchUpInside:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}


-(void)addFloatingColorViewController{
    self.floatingColorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VWWFloatingColorViewController"];
    
    CGRect frameForView = CGRectMake(160, 141, 100.0, 100.0);
    // 2. set the frame and provide some data
    UIView* view = self.floatingColorViewController.view;
    view.frame = frameForView;
    //    viewController.sandwich = sandwich;
    
    // 3. add as a child
    [self addChildViewController:self.floatingColorViewController];
    [self.view addSubview:view];
    [self.floatingColorViewController didMoveToParentViewController:self];
    
    
    
    // 1. add a gesture recognizer
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [view addGestureRecognizer:pan];
    
    
}

- (void)handlePan:(UIPanGestureRecognizer*)gestureRecognizer {
    [self.view bringSubviewToFront:[gestureRecognizer view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self.view];
    
    if ([(UIPanGestureRecognizer*)gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        _firstX = [[gestureRecognizer view] center].x;
        _firstY = [[gestureRecognizer view] center].y;
        
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    //    translatedPoint = gestureRecognizer.view.center;
    
    [[gestureRecognizer view] setCenter:translatedPoint];

}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    self.imageView.image = image;
    self.navigationController.navigationBar.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:^{
//        [self addFloatingColorViewController];
    }];

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    self.navigationController.navigationBar.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:^{

    }];
    
}


@end
