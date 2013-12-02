//
//  VWWWelcomeViewController.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWWelcomeViewController.h"

@interface VWWWelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation VWWWelcomeViewController

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
	
//    NSString *htmlString = [self htmlString];
//    [self.webView loadHTMLString:htmlString baseURL:nil];
    NSString *aboutString = [self textString];
    self.textView.text = aboutString;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)htmlString{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSError* error;
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:&error];
    return fileContents;
}

-(NSString*)textString{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"txt"];
    NSError* error;
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:&error];
    return fileContents;
}


@end
