//
//  VWWInteractiveHorizontalSwipeTransition.h
//  ILoveCatz
//
//  Created by Zakk Hoyt on 11/27/13.
//  Copyright (c) 2013 com.razeware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VWWInteractiveHorizontalSwipeTransition : UIPercentDrivenInteractiveTransition
- (void)wireToViewController:(UIViewController*)viewController; @property (nonatomic, assign) BOOL interactionInProgress;
@end