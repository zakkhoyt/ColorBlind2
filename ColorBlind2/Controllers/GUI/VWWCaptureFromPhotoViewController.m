//
//  VWWCaptureFromPhotoViewController.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWCaptureFromPhotoViewController.h"
#import "VWWFloatingColorViewController.h"
#import "VWWCrosshairView.h"
#import "VWWColors.h"
#import "VWWColor.h"


@interface VWWCaptureFromPhotoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, VWWCrosshairViewDelegate>{
    CGFloat _firstX;
    CGFloat _firstY;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) VWWFloatingColorViewController *floatingColorViewController;
@property (weak, nonatomic) IBOutlet VWWCrosshairView *crosshairView;
@property (weak, nonatomic) IBOutlet UIView *colorContainerView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *hexLabel;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;


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
    self.crosshairView.delegate = self;
    self.crosshairView.userInteractionEnabled = YES;
//    self.colorContainerView.hidden = YES;
    self.colorContainerView.alpha = 0.0;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBActions


- (IBAction)choosePhotoButtonTouchUpInside:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
- (IBAction)toggleButtonTouchUpInside:(id)sender {
    [self.delegate captureFromPhotoViewControllerToggleButtonTouchUpInside:self];
}

#pragma mark Private methods

-(void)updateColor:(VWWColor*)color{
    _colorView.backgroundColor = color.uiColor;
    _nameLabel.text = color.name;
    _redLabel.text = [NSString stringWithFormat:@"Red:%ld", (long)[color hexFromFloat:color.red]];
    _greenLabel.text = [NSString stringWithFormat:@"Green:%ld", (long)[color hexFromFloat:color.green]];
    _blueLabel.text = [NSString stringWithFormat:@"Blue:%ld", (long)[color hexFromFloat:color.blue]];
    _hexLabel.text = [NSString stringWithFormat:@"%@", [color hexValue]];
}

-(void)showColorView{
    self.colorContainerView.hidden = NO;
    self.colorContainerView.backgroundColor = self.view.backgroundColor;
    [UIView animateWithDuration:0.3 animations:^{
        self.colorContainerView.alpha = 1.0;
    }];
}

-(void)hideColorView{
    self.colorContainerView.hidden = YES;
    self.colorContainerView.backgroundColor = self.view.backgroundColor;
    [UIView animateWithDuration:0.3 animations:^{
        self.colorContainerView.alpha = 0.0;
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


- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(NSInteger)xx andY:(NSInteger)yy count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSInteger byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
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


#pragma mark VWWCrosshairViewDelegate



- (UIColor*)colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [self.imageView.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    return color;
}



-(void)crosshairViewTouchOccurredAtPoint:(CGPoint)point{
    UIColor *uiColor = [self colorOfPoint:point];
    VWWColor *color = [[VWWColors sharedInstance]closestColorFromUIColor:uiColor];
    [self updateColor:color];
    [self showColorView];
}


@end
