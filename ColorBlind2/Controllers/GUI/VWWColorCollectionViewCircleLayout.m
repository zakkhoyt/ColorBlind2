//
//  VWWColorCollectionViewCircleLayout.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWColorCollectionViewCircleLayout.h"

#define ITEM_SIZE 17

@implementation VWWColorCollectionViewCircleLayout


- (id)init {
    if ((self = [super init])) {
//        self.itemSize = CGSizeMake(17, 17);
    }
    return self;
}




-(void)prepareLayout{
    [super prepareLayout];
    
    CGSize size = self.collectionView.frame.size;
//    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    _cellCount = [[self collectionView] numberOfSections];
    _center = CGPointMake(size.width / 2.0, size.height / 2.0);
    _radius = MIN(size.width, size.height) / 2.5;
}

-(CGSize) collectionViewContentSize{
    return [self collectionView].frame.size;
}


-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    
//    attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
//    attributes.center = CGPointMake(_center.x + _radius * cosf(2 * indexPath.item * M_PI / _cellCount),
//                                    _center.y + _radius * sinf(2 * indexPath.item * M_PI / _cellCount));
//    
//    return  attributes;
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
    attributes.center = CGPointMake(_center.x + _radius * cosf(2 * indexPath.section * M_PI / _cellCount),
                                    _center.y + _radius * sinf(2 * indexPath.section * M_PI / _cellCount));
    
    return  attributes;

}


-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
//    NSMutableArray *attributes = [@[]mutableCopy];
//    for(NSInteger i = 0; i < self.cellCount; i++){
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
//    }
//    return attributes;
    NSMutableArray *attributes = [@[]mutableCopy];
    for(NSInteger i = 0; i < self.cellCount; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;

}

////-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath *)indexPath{
//-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"indexPath: %@", indexPath);
//    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
//    attributes.alpha = 0.0;
//    attributes.center = CGPointMake(_center.x, _center.y);
//    return attributes;
//}
//
//
//
////-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedItemAtIndexPath:(NSIndexPath*)indexPath{
//-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath*)indexPath{
//    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
//    attributes.alpha = 0.0;
//    attributes.center = CGPointMake(_center.x, _center.y);
//    attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 0.1);
//    return attributes;
//}

@end
