//
//  VWWColorCollectionReusableFlowView.h
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VWWColorCollectionReusableFlowView;

@protocol VWWColorCollectionReusableFlowViewDelegate <NSObject>
-(void)colorCollectionReusableFlowViewButtonTouchUpInside:(VWWColorCollectionReusableFlowView*)sender;
@end
@interface VWWColorCollectionReusableFlowView : UICollectionReusableView
@property (nonatomic, weak) id <VWWColorCollectionReusableFlowViewDelegate> delegate;
@property (nonatomic, strong) NSString *title;
@end
