//
//  VWWCaptureViewController.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWCaptureViewController.h"
#import "VWWCaptureFromPhotoViewController.h"
#import "VWWCaptureFromVideoViewController.h"

@interface VWWCaptureViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollisionBehaviorDelegate>{
    NSMutableArray* _views;
    UIGravityBehavior* _gravity;
    UIDynamicAnimator* _animator;
    CGPoint _previousTouchPoint;
    BOOL _draggingView;
    UISnapBehavior* _snap;
    BOOL _viewDocked;
    BOOL _hideStatusBars;
}
@property (weak, nonatomic) IBOutlet UIButton *existingButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation VWWCaptureViewController

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
    
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] init];
    [_animator addBehavior:_gravity];
    _gravity.magnitude = 4.0f;
    
    
    _views = [[NSMutableArray alloc]init];
    [self addCaptureViewControllers];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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

-(void)addCaptureViewControllers{
    VWWCaptureFromVideoViewController* videoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VWWCaptureFromVideoViewController"];
    [self addCaptureFromPhotoController:videoViewController offset:130];

    
    VWWCaptureFromPhotoViewController* photosViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VWWCaptureFromPhotoViewController"];
    [self addCaptureFromPhotoController:photosViewController offset:90];
    

}
- (UIView*)addCaptureFromPhotoController:(UIViewController*)viewController offset:(CGFloat)offset{
    
    CGRect frameForView = CGRectOffset(self.view.bounds, 0.0, self.view.bounds.size.height - offset);
    // 2. set the frame and provide some data
    UIView* view = viewController.view;
    view.frame = frameForView;
//    viewController.sandwich = sandwich;
    
    // 3. add as a child
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    
    
    // 1. add a gesture recognizer
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [viewController.view addGestureRecognizer:pan];
    
    // 2. create a collision
    UICollisionBehavior* collision = [[UICollisionBehavior alloc] initWithItems:@[view]];
    [_animator addBehavior:collision];
    
    // 3. lower boundary, where the tab rests
    float boundary = view.frame.origin.y + view.frame.size.height+1;
    CGPoint boundaryStart = CGPointMake(0.0, boundary);
    CGPoint boundaryEnd = CGPointMake(self.view.bounds.size.width, boundary);
    [collision addBoundaryWithIdentifier:@1 fromPoint:boundaryStart toPoint:boundaryEnd];
    
    
    boundaryStart = CGPointMake(0.0, 0.0);
    boundaryEnd = CGPointMake(self.view.bounds.size.width, 0.0);
    [collision addBoundaryWithIdentifier:@2 fromPoint:boundaryStart toPoint:boundaryEnd];
    collision.collisionDelegate = self;
    
    // 4. apply some gravity
    [_gravity addItem:view];
    
    
    UIDynamicItemBehavior* itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
    [_animator addBehavior:itemBehavior];
    
    return view;
    
}


- (void)handlePan:(UIPanGestureRecognizer*)gesture {
    CGPoint touchPoint = [gesture locationInView:self.view];
    UIView* draggedView = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 1. was the pan initiated from the top of the recipe?
        CGPoint dragStartLocation = [gesture locationInView:draggedView];
        if (dragStartLocation.y < 200.0f) {
            _draggingView = YES;
            _previousTouchPoint = touchPoint;
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged && _draggingView) {
        // 2. handle dragging
        float yOffset = _previousTouchPoint.y - touchPoint.y;
        gesture.view.center = CGPointMake(draggedView.center.x, draggedView.center.y - yOffset);
        _previousTouchPoint = touchPoint;
    } else if (gesture.state == UIGestureRecognizerStateEnded && _draggingView) {
        // 3. the gesture has ended
        [self attemptTopDock:draggedView];
        [self addVelocityToView:draggedView fromGesture:gesture];
        [_animator updateItemUsingCurrentState:draggedView];
        _draggingView = NO;
    }
}


- (void)addVelocityToView:(UIView*)view fromGesture:(UIPanGestureRecognizer*)gesture {
    CGPoint vel = [gesture velocityInView:self.view];
    vel.x = 0;
    UIDynamicItemBehavior* behaviour = [self itemBehaviourForView:view];
    [behaviour addLinearVelocity:vel forItem:view];
}

- (UIDynamicItemBehavior*) itemBehaviourForView:(UIView*)view {
    for (UIDynamicItemBehavior* behaviour in _animator.behaviors) {
        if (behaviour.class == [UIDynamicItemBehavior class] && [behaviour.items firstObject] == view) {
            return behaviour;
        }
    }
    return nil;
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior
      beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier
                  atPoint:(CGPoint)p {
    if ([@2 isEqual:identifier]) {
        UIView* view = (UIView*) item;
        [self attemptTopDock:view];
    }
}
-(void)attemptTopDock:(UIView*)view{
    BOOL nearTopOfView = view.frame.origin.y < 100.0;
    if (nearTopOfView) {
        if (!_viewDocked) {
            _snap = [[UISnapBehavior alloc] initWithItem:view snapToPoint:self.view.center];
            [_animator addBehavior:_snap];
            [self setAlphaWhenViewDocked:view alpha:0.0];
            _viewDocked = YES;
            _hideStatusBars = YES;
            [UIView animateWithDuration:0.3 animations:^{
                [self setNeedsStatusBarAppearanceUpdate];
                self.navigationController.navigationBar.alpha = 0.0;
                self.tabBarController.tabBar.alpha = 0.0;
//                self.view.alpha = 0.0;
            }];
        }
    } else {
        if (_viewDocked) {
            [_animator removeBehavior:_snap];
            [self setAlphaWhenViewDocked:view alpha:1.0];
            _viewDocked = NO;
            
            _hideStatusBars = NO;
            [UIView animateWithDuration:0.3 animations:^{
                [self setNeedsStatusBarAppearanceUpdate];
                self.navigationController.navigationBar.alpha = 1.0;
                self.tabBarController.tabBar.alpha = 1.0;
//                self.view.alpha = 1.0;
            }];
        }
    }
}


- (void)setAlphaWhenViewDocked:(UIView*)view alpha:(CGFloat)alpha {
    for (UIView* aView in _views) {
        if (aView != view) {
            aView.alpha = alpha;
        }
    }
}


@end
