//
//  VWWColorsTableViewController.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWColorsTableViewController.h"
#import "VWWColors.h"
#import "VWWColorTableViewCell.h"
#import "VWWColor.h"


//#define VWW_HIDE_BARS_ON_SCROLL 1

static NSString *VWWColorsTableViewControllerHeaderKey = @"headerTitle";
static NSString *VWWColorsTableViewControllerColorKey = @"color";

@interface VWWColorsTableViewController () <UITableViewDataSource, UITableViewDelegate>{
    BOOL _hideStatusBars;
}
@property (nonatomic, strong) VWWColors *colors;
@property (weak, nonatomic) IBOutlet UITableView *colorsTableView;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation VWWColorsTableViewController

#pragma mark UIViewController overrides
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
    [self createDataSource];


    [self addGestureRecognizers];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.colorsTableView reloadData];
    
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
// We already have an NSOrderedSet of VWWColor objects sorted by color.name.
// We need to convert that data in what the UITableView's scrubber can take advantage or
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
    [_colorsTableView addGestureRecognizer:singleTapGestureRecognizer];

}
-(void)singleTap:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded && _hideStatusBars) {
        [self showBars];
    }
}

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


#pragma mark Public methods





#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    VWW_LOG(@"returning %d", _datasource.count);
    return _datasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary* dictionary = _datasource[section];
    NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];
    VWW_LOG(@"returning %d", array.count);
    return array.count;
}

// This method is asking for the letters to use in the scrubber for the tableview
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for(NSUInteger index = 0; index < _datasource.count; index++){
        NSDictionary* dictionary = _datasource[index];
        NSString* headerTitle = [dictionary valueForKey:VWWColorsTableViewControllerHeaderKey];
        [array addObject:headerTitle];
    }
    return array;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VWW_LOG(@"");
    VWWColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VWWColorTableViewCell"];
    NSMutableDictionary* dictionary = (_datasource)[indexPath.section];
    NSArray* array = dictionary[VWWColorsTableViewControllerColorKey];
    VWWColor* color = array[indexPath.row];
    cell.color = color;
    return cell;
}

#pragma mark UITableViewDelegate



#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_hideStatusBars == NO) {
        [self hideBars];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(_hideStatusBars){
        [self showBars];
    }
}





@end
