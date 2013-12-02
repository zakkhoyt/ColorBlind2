//
//  VWWWelcomeViewController.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWWelcomeViewController.h"
#import "VWWAboutViewController.h"
#import "VWWSpringTransition.h"
#import "VWWShrinkTransition.h"
#import "VWWHorizontalFlipInteractiveTransition.h"
#import "VWWHorizontalFlipTransition.h"
#import "VWWExpandIntoFrameTransition.h"

static NSString *VWWSegueWelcomeToAbout = @"VWWSegueWelcomeToAbout";

@interface VWWWelcomeViewController ()<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>{
    VWWSpringTransition *_bounceAnimationController;
    VWWShrinkTransition *_shrinkDismissAnimationController;
    VWWHorizontalFlipInteractiveTransition *_interactiveHorizontalFlipTransition;
    VWWHorizontalFlipTransition *_horizontalFlipTransition;
    VWWExpandIntoFrameTransition *_expandTransition;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;


@end

@implementation VWWWelcomeViewController

#pragma mark UIViewController overrides

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _bounceAnimationController = [[VWWSpringTransition alloc]init];
        _shrinkDismissAnimationController = [[VWWShrinkTransition alloc]init];
        _interactiveHorizontalFlipTransition = [[VWWHorizontalFlipInteractiveTransition alloc]init];
        _horizontalFlipTransition = [[VWWHorizontalFlipTransition alloc]init];
        _expandTransition = [[VWWExpandIntoFrameTransition alloc]init];
    }
    return self;
}


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
    self.navigationController.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:VWWSegueWelcomeToAbout]){
        VWWAboutViewController *vc = segue.destinationViewController;
        vc.transitioningDelegate = self;
    }
}


#pragma mark Private methods



#pragma mark IBActions
- (IBAction)aboutButtonTouchUpInside:(id)sender {
    [self performSegueWithIdentifier:VWWSegueWelcomeToAbout sender:self];
}


#pragma mark UIViewControllerTransitioningDelegate

// Transition for presenting a modal view controller
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController: (UIViewController *)source{
//    [_expandTransition setToFrame:self.logoImageView.frame];
//    [_expandTransition setFromFrame:self.aboutButton.frame];
    return _bounceAnimationController;
}

// Transition for dismissing a modal view controller
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _shrinkDismissAnimationController;
}

// Navigation controller flipper
- (id<UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        [_horizontalFlipTransition wireToViewController:toVC];
    }
    
    
    _interactiveHorizontalFlipTransition.reverse = (operation == UINavigationControllerOperationPop);
    return _interactiveHorizontalFlipTransition;
}

// Method allows for interaction
- (id <UIViewControllerInteractiveTransitioning>) navigationController:(UINavigationController *)navigationController
                           interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController {
    return _horizontalFlipTransition.interactionInProgress ? _horizontalFlipTransition : nil;
}



@end
