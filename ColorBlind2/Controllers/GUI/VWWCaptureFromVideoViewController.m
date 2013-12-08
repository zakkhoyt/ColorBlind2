//
//  VWWCaptureFromVideoViewController.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/2/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//
// Some good stuff about augmented reality here: http://cmgresearch.blogspot.com/2010/10/augmented-reality-on-iphone-with-ios40.html


#import "VWWCaptureFromVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VWWColors.h"
#import "VWWColor.h"
#import "VWWCrosshairView.h"

@interface VWWCaptureFromVideoViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>
@property dispatch_queue_t avqueue;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *colorContainerView;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *hexLabel;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;

@property (weak, nonatomic) IBOutlet VWWCrosshairView *crosshairView;



@end

@implementation VWWCaptureFromVideoViewController

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
    self.avqueue = dispatch_queue_create("com.vaporwarewolf.colorblind", NULL);
    self.colorContainerView.hidden = YES;
    self.colorContainerView.alpha = 0.0;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.crosshairView.selectedPixel = self.crosshairView.center;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBActions

- (IBAction)startButtonTouchUpInside:(id)sender {
    if([self isCameraAvailable]){
        dispatch_async(self.avqueue, ^{
            [self startCamera];
        });
        [self showColorView];
    }

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


-(BOOL)isCameraAvailable{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    BOOL cameraFound = NO;
    for (AVCaptureDevice *device in videoDevices) {
        if (device.position == AVCaptureDevicePositionBack){
            cameraFound = YES;
        }
    }
    return cameraFound;
}


-(void)startCamera{
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (!input) {
        VWW_LOG_WARN(@"Couldnt' create AV video capture device");
    }
    [session addInput:input];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        UIView *view = self.cameraView;
        CALayer *viewLayer = [view layer];
        
        newCaptureVideoPreviewLayer.frame = view.bounds;
        [viewLayer addSublayer:newCaptureVideoPreviewLayer];
        [self.cameraView bringSubviewToFront:self.crosshairView];
        
//        CGRect bounds=view.layer.bounds;
//        newCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//        newCaptureVideoPreviewLayer.bounds=bounds;
//        newCaptureVideoPreviewLayer.position=CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
        
        
        [session startRunning];
    });
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
    // ************************* configure AVCaptureSession to deliver raw frames via callback (as well as preview layer)
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    NSMutableDictionary *cameraVideoSettings = [[NSMutableDictionary alloc] init];
    NSString *key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber *value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]; //kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange];
    [cameraVideoSettings setValue:value forKey:key];
    [videoOutput setVideoSettings:cameraVideoSettings];
    [videoOutput setAlwaysDiscardsLateVideoFrames:YES];

//    [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [videoOutput setSampleBufferDelegate:self queue:self.avqueue];


    if([session canAddOutput:videoOutput]){
        [session addOutput:videoOutput];
    }
    else {
        NSLog(@"Could not add videoOutput");
    }

    });
    
//    
//    AVCaptureSession *session = [[AVCaptureSession alloc] init];
//    
//    // Set the captures resolution. This varies from device to device
//    
//    //          iPad43      iPhone4
//    // * low    192x144     192x144
//    // * medium 480x360     480x360
//    // * hight  1920x1080   1280x720
//    // * photo  2048x1536   852x640
//    
//    
//    
////    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
////    [captureSession addInput:input];
////    [captureSession setSessionPreset:@"AVCaptureSessionPresetPhoto"];
////    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
////    [self applyDefaults];
////    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
////    previewLayer.backgroundColor = [[UIColor blackColor] CGColor];
////    [previewParentView.layer insertSublayer:previewLayer atIndex:1];
////    
//    
//    
////    session.sessionPreset = AVCaptureSessionPresetLow;
//    session.sessionPreset = AVCaptureSessionPresetMedium;
//    //    session.sessionPreset = AVCaptureSessionPresetHigh;
//    //	session.sessionPreset = AVCaptureSessionPresetPhoto;
//    
//	CALayer *viewLayer = self.cameraView.layer;
//    
//    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
//    captureVideoPreviewLayer.frame = self.cameraView.frame;
//    [self.view.layer addSublayer:captureVideoPreviewLayer];
//    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    captureVideoPreviewLayer.backgroundColor = [[UIColor blackColor] CGColor];
//    [self.view.layer insertSublayer:captureVideoPreviewLayer atIndex:1];
////	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
////	captureVideoPreviewLayer.frame = self.cameraView.bounds;
////	[self.cameraView.layer addSublayer:captureVideoPreviewLayer];
//    
//	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    
//	NSError *error = nil;
//	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
//	if (!input) {
//		// Handle the error appropriately.
//		NSLog(@"ERROR: trying to open camera: %@", error);
//	}
//	[session addInput:input];
//    
////    // ************************* configure AVCaptureSession to deliver raw frames via callback (as well as preview layer)
////    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
////    NSMutableDictionary *cameraVideoSettings = [[NSMutableDictionary alloc] init];
////    NSString *key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
////    NSNumber *value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]; //kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange];
////    [cameraVideoSettings setValue:value forKey:key];
////    [videoOutput setVideoSettings:cameraVideoSettings];
////    [videoOutput setAlwaysDiscardsLateVideoFrames:YES];
////    
//////    [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
////    [videoOutput setSampleBufferDelegate:self queue:self.avqueue];
////    
////    
////    if([session canAddOutput:videoOutput]){
////        [session addOutput:videoOutput];
////    }
////    else {
////        NSLog(@"Could not add videoOutput");
////    }
//    
//	[session startRunning];
    
}

-(void)stopCamera{
    
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

#pragma mark implements AVFoundation

// For image resizing, see the following links:
// http://stackoverflow.com/questions/4712329/how-to-resize-the-image-programatically-in-objective-c-in-iphone
// http://stackoverflow.com/questions/6052188/high-quality-scaling-of-uiimage

-(void)captureOutput :(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection{
    
    
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    
    // Let's grab the center pixel
    NSUInteger halfWidth = floor(width/2.0);
    NSUInteger halfHeight = floor(height/2.0);
    
    
    NSArray* pixels = [self getRGBAsFromImage:image atX:halfWidth andY:halfHeight count:1];
    VWW_LOG(@"Getting pixel data:");
    UIColor* uicolor = pixels[0];
    CGFloat red, green, blue, alpha = 0;
    [uicolor getRed:&red green:&green blue:&blue alpha:&alpha];
    //    NSLog(@"r=%f g=%f b=%f a=%f", red, green, blue, alpha);
    
    
    
    VWWColor *color = [[VWWColors sharedInstance]closestColorFromRed:red green:green blue:blue];
    
//    VWW_Color* color = [self.colors colorFromRed:[NSNumber numberWithInt:red*100]
//                                           Green:[NSNumber numberWithInt:green*100]
//                                            Blue:[NSNumber numberWithInt:blue*100]];
    
    
    static bool hasRunOnce = NO;
    if(!hasRunOnce){
        hasRunOnce = YES;
        NSLog(@"Camera is outputting frames at %dx%d", (int)width, (int)height);
        NSLog(@"We will be examinign pixel in row %d column %d", (int)(halfWidth * height), (int)halfHeight);
    }
    
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self updateColor:color];
//        self.lblColorName.text = color.name;
//        self.lblColorDetails.text = color.description;
//        self.currentColorView.backgroundColor = color.color;
//        self.crosshairsView.selectedPixel = CGPointMake(halfWidth, halfHeight);
    });
}



@end
