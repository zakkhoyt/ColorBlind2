//
//  VWWExpandIntoFrameTransition.h
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWExpandIntoFrameTransition : NSObject <UIViewControllerAnimatedTransitioning>
-(void)setFromFrame:(CGRect)frame;
-(void)setToFrame:(CGRect)frame;
@end
