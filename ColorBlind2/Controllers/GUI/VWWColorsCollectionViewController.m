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
#import "VWWColorViewController.h"

//#define VWW_HIDE_BARS_ON_SCROLL 1

static NSString *VWWColorsTableViewControllerHeaderKey = @"headerTitle";
static NSString *VWWColorsTableViewControllerColorKey = @"color";
static NSString *VWWSegueCollectionToColor = @"VWWSegueCollectionToColor";

@interface VWWColorsCollectionViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
VWWColorCollectionReusableFlowViewDelegate>{
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:VWWSegueCollectionToColor]){
        VWWColorViewController *vc = segue.destinationViewController;
        vc.color = sender;
    }
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
        VWW_LOG(@"switching to flow");
        _useCircleLayout = NO;
        [_colorsCollectionView setCollectionViewLayout:_flowLayout animated:YES completion:^(BOOL finished) {
            [_colorsCollectionView performBatchUpdates:^{

            } completion:^(BOOL finished) {

                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:self.transitionIndexPath.section];
//                NSLog(@"scrolling to %d %d", indexPath.section, indexPath.item);
                [_colorsCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                
                NSArray *indexPaths = [_colorsCollectionView indexPathsForVisibleItems];
                [_colorsCollectionView reloadItemsAtIndexPaths:indexPaths];
                
            }];

        }];
    }
    else {
        VWW_LOG(@"switching to circle");
        _useCircleLayout = YES;
        [_colorsCollectionView setCollectionViewLayout:_circleLayout animated:YES completion:^(BOOL finished) {
            
            [_colorsCollectionView performBatchUpdates:^{
                
            } completion:^(BOOL finished) {
                
                NSArray *indexPaths = [_colorsCollectionView indexPathsForVisibleItems];
                [_colorsCollectionView reloadItemsAtIndexPaths:indexPaths];
                
//                // Center in view
//                CGFloat y = (self.view.bounds.size.height - _colorsCollectionView.contentSize.height)  / 2.0;
//                _colorsCollectionView.contentOffset = CGPointMake(0, y);
            }];
        }];
    }
    
    [_colorsCollectionView.collectionViewLayout invalidateLayout];
    
}


#pragma mark IBActions
- (IBAction)toggleButtonAction:(id)sender {
    [self toggleLayout];
}





#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    VWW_LOG(@"returning %d", _datasource.count);
    return _datasource.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableDictionary* dictionary = _datasource[section];
    NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];
//    VWW_LOG(@"returning %d", array.count);
    
    if(_useCircleLayout){
        return MIN(1, array.count);
    }
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
    cell.delegate = self;
    return cell;
    
    
}

#pragma mark UICollectionViewDelegateFlowLayout


#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // If we are in circle mode, toggle the layout.
    if(_colorsCollectionView.collectionViewLayout == _circleLayout){
        self.transitionIndexPath = indexPath;
        VWW_LOG(@"Setting self.transitionIndexPath: %ld:%ld", (long)self.transitionIndexPath.section, (long)self.transitionIndexPath.item);
        [self toggleLayout];
    } else {
        // Show color detail
        VWWColorCollectionViewFlowCell *cell = (VWWColorCollectionViewFlowCell*)[_colorsCollectionView cellForItemAtIndexPath:indexPath];
        VWWColor *color = cell.color;
        [self performSegueWithIdentifier:VWWSegueCollectionToColor sender:color];
    }
    

    // TODO: Future:
    //    [collectionView startInteractiveTransitionToCollectionViewLayout:_circleLayout completion:^(BOOL completed, BOOL finish) {
    //        [collectionView finishInteractiveTransition];    
    //    }];
    
    
}


#pragma mark UIScollviewDelegate

//#endif

#pragma mark VWWColorCollectionReusableFlowViewDelegate
-(void)colorCollectionReusableFlowViewButtonTouchUpInside:(VWWColorCollectionReusableFlowView*)sender{
    [self toggleLayout];
}





@end
