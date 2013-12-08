//
//  VWWCaptureFromPhotoViewController.h
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VWWCaptureFromPhotoViewController;

@protocol VWWCaptureFromPhotoViewControllerDelegate <NSObject>
-(void)captureFromPhotoViewControllerToggleButtonTouchUpInside:(VWWCaptureFromPhotoViewController*)sender;
@end


@interface VWWCaptureFromPhotoViewController : UIViewController
@property (nonatomic, weak) id <VWWCaptureFromPhotoViewControllerDelegate> delegate;
-(void)showColorView;
-(void)hideColorView;

@end
