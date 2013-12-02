//
//  VWWColorsCollectionViewController.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWColorsCollectionViewController.h"
#import "VWWColor.h"
#import "VWWColors.h"
#import "VWWColorCollectionViewFlowCell.h"
#import "VWWColorCollectionViewCircleCell.h"
#import "VWWColorCollectionViewFlowLayout.h"
#import "VWWColorCollectionViewCircleLayout.h"
#import "VWWColorCollectionReusableFlowView.h"

#define VWW_USE_CIRCLE_LAYOUT 1

static NSString *VWWColorsTableViewControllerHeaderKey = @"headerTitle";
static NSString *VWWColorsTableViewControllerColorKey = @"color";

@interface VWWColorsCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) VWWColors *colors;
@property (nonatomic, strong) VWWColorCollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) VWWColorCollectionViewCircleLayout *circleLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *colorsCollectionView;
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation VWWColorsCollectionViewController

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
    _colors = [VWWColors sharedInstance];
    _flowLayout = [[VWWColorCollectionViewFlowLayout alloc]init];
    _circleLayout = [[VWWColorCollectionViewCircleLayout alloc]init];
#if defined(VWW_USE_CIRCLE_LAYOUT)
    _colorsCollectionView.collectionViewLayout = _circleLayout;
#else
    _colorsCollectionView.collectionViewLayout = _flowLayout;
#endif
    
    _colorsCollectionView.backgroundColor = [UIColor clearColor];
    
    [self createDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private methods
-(void)createDataSource{
    
    const NSUInteger kMaxColorsArraySize = 26; // maximum 26 letters in the alphabet
    _datasource = [[NSMutableArray alloc]initWithCapacity:kMaxColorsArraySize];
    
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
    for (NSUInteger index = 0; index < letters.length; index++ ) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        NSMutableArray* array = [[NSMutableArray alloc]init];
        
        char cl[2] = { toupper([letters characterAtIndex:index]), '\0'};
        NSString* currentLetter = [NSString stringWithFormat:@"%s", cl];
        for(NSUInteger colorsIndex = 0; colorsIndex < self.colors.colorsKeys.count; colorsIndex++){
            VWWColor* color = [self.colors colorAtIndex:colorsIndex];
            if([color.name hasPrefix:currentLetter] == YES){
                [array addObject:color];
            }
        }
        [dict setValue:currentLetter forKey:VWWColorsTableViewControllerHeaderKey];
        [dict setValue:array forKey:VWWColorsTableViewControllerColorKey];
        [_datasource addObject:dict];
    }
}

#if defined(VWW_USE_CIRCLE_LAYOUT)
#pragma mark UICollectionViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    VWW_LOG(@"returning %d", _datasource.count);
    return _datasource.count;
//    return 1;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableDictionary* dictionary = _datasource[section];
    NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];
    VWW_LOG(@"returning %d", array.count);
//    return array.count;
    return MIN(1, array.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    VWWColorCollectionViewFlowCell *cell = [_colorsCollectionView dequeueReusableCellWithReuseIdentifier:@"VWWColorCollectionViewFlowCell" forIndexPath:indexPath];
//    cell.color = [_colors colorAtIndex:indexPath.item];
//    return cell;
    VWW_LOG(@"");
    VWWColorCollectionViewCircleCell *cell = [_colorsCollectionView dequeueReusableCellWithReuseIdentifier:@"VWWColorCollectionViewCircleCell" forIndexPath:indexPath];
    NSMutableDictionary* dictionary = (_datasource)[indexPath.section];
    NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];
    VWWColor* color = array[indexPath.item];
    cell.color = color;
    return cell;

}


#pragma mark UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(160, 141);
//}


#pragma mark UICollectionViewDelegate



#pragma mark UIScollviewDelegate

#else

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    VWW_LOG(@"returning %d", _datasource.count);
    return _datasource.count;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableDictionary* dictionary = _datasource[section];
    NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];
    VWW_LOG(@"returning %d", array.count);
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VWW_LOG(@"");
    VWWColorCollectionViewFlowCell *cell = [_colorsCollectionView dequeueReusableCellWithReuseIdentifier:@"VWWColorCollectionViewFlowCell" forIndexPath:indexPath];
    NSMutableDictionary* dictionary = (_datasource)[indexPath.section];
    NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];
    VWWColor* color = array[indexPath.item];
    cell.color = color;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    VWWColorCollectionReusableFlowView *cell = (VWWColorCollectionReusableFlowView*)[_colorsCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                                                                                         withReuseIdentifier:@"VWWColorCollectionReusableFlowView"
//                                                                                                forIndexPath:indexPath];
    VWWColorCollectionReusableFlowView *cell = (VWWColorCollectionReusableFlowView*)[_colorsCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                         withReuseIdentifier:@"VWWColorCollectionReusableFlowView"
                                                                                                forIndexPath:indexPath];
    NSMutableDictionary* dictionary = (_datasource)[indexPath.section];
    NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];
    VWWColor* color = array[indexPath.row];
    cell.title = [color.name substringToIndex:1];
    return cell;
    
    
}

#pragma mark UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(160, 141);
//}


#pragma mark UICollectionViewDelegate



#pragma mark UIScollviewDelegate

#endif


@end
