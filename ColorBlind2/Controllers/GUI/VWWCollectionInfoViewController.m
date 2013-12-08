//
//  VWWCollectionInfoViewController.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/7/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWCollectionInfoViewController.h"

@interface VWWCollectionInfoViewController ()

@end

@implementation VWWCollectionInfoViewController

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
	UIImage *image = [UIImage imageNamed:@"collection_on.png"];
	self.navigationController.tabBarItem.selectedImage = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
