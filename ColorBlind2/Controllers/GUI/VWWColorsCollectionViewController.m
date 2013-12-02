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
//#define VWW_HIDE_BARS_ON_SCROLL 1

static NSString *VWWColorsTableViewControllerHeaderKey = @"headerTitle";
static NSString *VWWColorsTableViewControllerColorKey = @"color";

@interface VWWColorsCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>{
    BOOL _hideStatusBars;
    BOOL _useCircleLayout;
}
@property (nonatomic, strong) VWWColors *colors;
@property (nonatomic, strong) VWWColorCollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) VWWColorCollectionViewCircleLayout *circleLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *colorsCollectionView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSIndexPath *transitionIndexPath;
@end

@implementation VWWColorsCollectionViewController

#pragma mark UIViewController overrides

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _useCircleLayout = YES;
    _colors = [VWWColors sharedInstance];
    _flowLayout = [[VWWColorCollectionViewFlowLayout alloc]init];
    _circleLayout = [[VWWColorCollectionViewCircleLayout alloc]init];
    
    
    if(_useCircleLayout){
        _colorsCollectionView.collectionViewLayout = _circleLayout;
    } else {
        _colorsCollectionView.collectionViewLayout = _flowLayout;
    }
    
    _colorsCollectionView.backgroundColor = [UIColor clearColor];
    
    [self createDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return _hideStatusBars;
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



-(void)addGestureRecognizers{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    //    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    //    [self.view addGestureRecognizer:panGestureRecognizer];
}
-(void)singleTap:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded && _hideStatusBars) {
        [self showBars];
    }
}

//-(void)panAction:(UIGestureRecognizer*)sender{
//    static CGFloat xStart = 0;
//
//    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
//    if(sender.state == UIGestureRecognizerStateBegan) {
//        xStart = translatedPoint.x;
//    } else if(sender.state == UIGestureRecognizerStateChanged ||
//              sender.state == UIGestureRecognizerStateEnded){
//        CGFloat offset = xStart - translatedPoint.x;
//        self.circleLayout.offset = offset;
//    }
//
//
//
//    NSLog(@"");
//
//}

-(void)showBars{
    
#if defined(VWW_HIDE_BARS_ON_SCROLL)
    _hideStatusBars = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
        
        self.navigationController.navigationBar.alpha = 1.0f;
        self.tabBarController.tabBar.alpha = 1.0f;
    }];
#endif
}





-(void)hideBars{
#if defined(VWW_HIDE_BARS_ON_SCROLL)
    _hideStatusBars = YES;
    [UIView animateWithDuration:0.25 animations:^{
        
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.navigationBar.alpha = 0.0f;
        self.tabBarController.tabBar.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
    }];
#endif
}





-(void)toggleLayout{
    if(_useCircleLayout){
        _useCircleLayout = NO;
//        [_colorsCollectionView performBatchUpdates:^{
//            _colorsCollectionView.collectionViewLayout = _flowLayout;
//        } completion:^(BOOL finished) {
//            
//        }];
        
//        if(_colorsCollectionView.collectionViewLayout == _flowLayout) return;
        [_colorsCollectionView setCollectionViewLayout:_flowLayout animated:YES completion:^(BOOL finished) {
//            _useCircleLayout = NO;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:self.transitionIndexPath.section];
            NSLog(@"scrolling to %d %d", indexPath.section, indexPath.item);
            [_colorsCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }];
        //        [_colorsCollectionView startInteractiveTransitionToCollectionViewLayout:_flowLayout completion:^(BOOL completed, BOOL finish) {
        //
        //        }];
    }
    else {
        _useCircleLayout = YES;
//        [_colorsCollectionView performBatchUpdates:^{
//            _colorsCollectionView.collectionViewLayout = _circleLayout;
//        } completion:^(BOOL finished) {
//            
//        }];
//        if(_colorsCollectionView.collectionViewLayout == _circleLayout) return;
        [_colorsCollectionView setCollectionViewLayout:_circleLayout animated:YES completion:^(BOOL finished) {
//            _useCircleLayout = YES;

//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:self.transitionIndexPath.section];
//            NSLog(@"scrolling to %d %d", indexPath.section, indexPath.item);
//            [_colorsCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }];
        
        //        [_colorsCollectionView startInteractiveTransitionToCollectionViewLayout:_circleLayout completion:^(BOOL completed, BOOL finish) {
        //
        //        }];
    }
    
    [_colorsCollectionView.collectionViewLayout invalidateLayout];
    
}


#pragma mark IBActions
- (IBAction)toggleButtonAction:(id)sender {
    [self toggleLayout];
}



//#if defined(VWW_USE_CIRCLE_LAYOUT)
//#pragma mark UICollectionViewDatasource
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    VWW_LOG(@"returning %d", _datasource.count);
//    return _datasource.count;
//
//
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSMutableDictionary* dictionary = _datasource[section];
//    NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];
//    VWW_LOG(@"returning %d", array.count);
////    return array.count;
//    return MIN(1, array.count);
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
////    VWWColorCollectionViewFlowCell *cell = [_colorsCollectionView dequeueReusableCellWithReuseIdentifier:@"VWWColorCollectionViewFlowCell" forIndexPath:indexPath];
////    cell.color = [_colors colorAtIndex:indexPath.item];
////    return cell;
//    VWW_LOG(@"");
//    VWWColorCollectionViewCircleCell *cell = [_colorsCollectionView dequeueReusableCellWithReuseIdentifier:@"VWWColorCollectionViewCircleCell" forIndexPath:indexPath];
//    NSMutableDictionary* dictionary = (_datasource)[indexPath.section];
//    NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];
//    VWWColor* color = array[indexPath.item];
//    cell.color = color;
//    return cell;
//
//}
//
//
//#pragma mark UICollectionViewDelegateFlowLayout
////- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
////    return CGSizeMake(160, 141);
////}
//
//
//#pragma mark UICollectionViewDelegate
//
//
//
//#pragma mark UIScrollViewDelegate
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if (_hideStatusBars == NO) {
//        [self hideBars];
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if(_hideStatusBars){
//        [self showBars];
//    }
//}
//
//#else

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    if(_useCircleLayout){
//        VWW_LOG(@"returning %d", _datasource.count);
//        return _datasource.count;
//        
//    }
//    VWW_LOG(@"returning %d", _datasource.count);
    return _datasource.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableDictionary* dictionary = _datasource[section];
    NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];
    VWW_LOG(@"returning %d", array.count);

    
    if(_useCircleLayout){
//        NSMutableDictionary* dictionary = _datasource[section];
//        NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];
//        VWW_LOG(@"returning %d", array.count);

        return MIN(1, array.count);
    }
    
//    NSMutableDictionary* dictionary = _datasource[section];
//    NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];

    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary* dictionary = (_datasource)[indexPath.section];
    NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];
    VWWColor* color = array[indexPath.item];
    
    if(_useCircleLayout){
        VWWColorCollectionViewCircleCell *cell = [_colorsCollectionView dequeueReusableCellWithReuseIdentifier:@"VWWColorCollectionViewCircleCell" forIndexPath:indexPath];
        cell.color = color;
        return cell;
    }

    VWWColorCollectionViewFlowCell *cell = [_colorsCollectionView dequeueReusableCellWithReuseIdentifier:@"VWWColorCollectionViewFlowCell" forIndexPath:indexPath];
    cell.color = color;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(_useCircleLayout){
        return nil;
    }
    
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


#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.transitionIndexPath = indexPath;
    [self toggleLayout];
    //    [collectionView startInteractiveTransitionToCollectionViewLayout:_circleLayout completion:^(BOOL completed, BOOL finish) {
    //        [collectionView finishInteractiveTransition];    
    //    }];
    
    
}


#pragma mark UIScollviewDelegate

//#endif






@end
