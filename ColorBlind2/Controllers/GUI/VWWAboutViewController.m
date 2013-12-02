//
//  VWWAboutViewController.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWAboutViewController.h"

@interface VWWAboutViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@end

@implementation VWWAboutViewController

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
	// Do any additional setup after loading the view.

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    NSString *htmlString = [self htmlString];
    //    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    NSString *aboutString = [self aboutString];
    self.aboutTextView.text = aboutString;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBActions
- (IBAction)dismissButtonTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark Private methods

-(NSString*)htmlString{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSError* error;
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:&error];
    return fileContents;
}

-(NSString*)aboutString{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"txt"];
    NSError* error;
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:&error];
    return fileContents;
}

@end
