//
//  VWWHorizontalFlipInteractiveTransition.m
//  ILoveCatz
//
//  Created by Zakk Hoyt on 11/27/13.
//  Copyright (c) 2013 com.razeware. All rights reserved.
//

#import "VWWHorizontalFlipInteractiveTransition.h"

@implementation VWWHorizontalFlipInteractiveTransition

- (NSTimeInterval)transitionDuration: (id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0f;
}

- (CATransform3D) yRotation:(CGFloat) angle {
    return CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}

- (void)animateTransition: (id<UIViewControllerContextTransitioning>)transitionContext {
    // 1. the usual stuff ...
    UIView* containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    [containerView addSubview:toVC.view];
    
    
    // 2. Add a perspective transform
    CATransform3D transform = CATransform3DIdentity; transform.m34 = -0.002;
    [containerView.layer setSublayerTransform:transform];
    
    // 3. Give both VCs the same start frame
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame = initialFrame; toView.frame = initialFrame;
    
    // 4. reverse?
    float factor = self.reverse ? 1.0 : -1.0;
    
    // 5. flip the to VC halfway round - hiding it
    toView.layer.transform = [self yRotation:factor * -M_PI_2];
    

    // See TODO below in completion block
//    if(CATransform3DEqualToTransform(toView.layer.transform, [self yRotation:0.0])){
//        NSLog(@"YES!");
//    }
//    NSLog(@"to: %@", NSStringFromCATransform3D(toView.layer.transform));
//    NSLog(@"to: %@", NSStringFromCGAffineTransform(toView.layer.transform));
    
    // 6. Animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    // 7. rotate the from view
                                                                    fromView.layer.transform = [self yRotation:factor * M_PI_2];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5 animations:^{
                                                              // 8. rotate the to view
                                                              toView.layer.transform = [self yRotation:0.0];
                                                          }];
                              } completion:^(BOOL finished) {
                                  // TODO; There is a bug here where on a slow swipe (with completion) that this block is never called
                                  // Can probably fix this with a compare on the current rotation and the calculate target. If same, call completTransaction.
                                  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                              }];
}
@end
