//
//  VWWExpandIntoFrameTransition.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWExpandIntoFrameTransition.h"



@implementation VWWExpandIntoFrameTransition{
    CGRect _fromFrame;
    CGRect _toFrame;
}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // 1. obtain state from the context
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    VWW_LOG_TODO(@"Check if final frame is CGRectZero")
    
    // 2. obtain the container view
    UIView *containerView = [transitionContext containerView];
    
    // 3. set initial state
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    toViewController.view.frame = CGRectOffset(_toFrame, 0, screenBounds.size.height);
    toViewController.view.frame = _fromFrame;
//    NSLog(@"toViewController.view.frame: %@", NSStringFromCGRect(toViewController.view.frame));
    
    UIView *intermediateView = [toViewController.view snapshotViewAfterScreenUpdates:NO];
    intermediateView.frame = _fromFrame;
    [containerView addSubview:intermediateView];
    
    
    
    
//    // 4. add the view
//    [containerView addSubview:toViewController.view];
    
    // 5. animate
    CGFloat duration = 5.0;
    
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromViewController.view.alpha = 0.5;
                         toViewController.view.frame = _toFrame;
                     }
                     completion:^(BOOL finished) {
                         fromViewController.view.alpha = 1.0;
                         [transitionContext completeTransition:YES];
                     }];
}


#pragma mark Public methods
-(void)setFromFrame:(CGRect)frame{
    _fromFrame = frame;

}
-(void)setToFrame:(CGRect)frame{
    _toFrame = frame;
}
@end
