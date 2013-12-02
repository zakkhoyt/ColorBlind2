//
//  VWWColorCollectionViewFlowLayout.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWColorCollectionViewFlowLayout.h"

@implementation VWWColorCollectionViewFlowLayout
- (id)init {
    if ((self = [super init])) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 0.0f;
        self.minimumInteritemSpacing = 0.0f;
        self.itemSize = CGSizeMake(160, 141);
        self.headerReferenceSize = CGSizeMake(self.collectionView.bounds.size.width, 100);
    }
    return self;
}
@end
