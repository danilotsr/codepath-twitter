//
//  DRSlideViewController.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/24/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRSlideViewController.h"

@interface DRSlideViewController ()

@property (weak, nonatomic) IBOutlet UIView *primaryView;
@property (weak, nonatomic) IBOutlet UIView *secondaryView;
@property (assign, nonatomic) BOOL isShowingPrimaryView;


- (void)configurePrimaryView;
- (void)configureSecondaryView;
- (void)removeViewController:(UIViewController *)viewController;

@end

@implementation DRSlideViewController

- (id)initWithPrimaryViewController:(UIViewController *)primaryViewController
            secondaryViewController:(UIViewController *)secondaryViewController {
    self = [super init];
    if (self) {
        self.primaryViewController = primaryViewController;
        self.secondaryViewController = secondaryViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self configurePrimaryView];
    [self configureSecondaryView];
    self.isShowingPrimaryView = YES;
}

- (CGFloat)width {
    return CGRectGetWidth(self.view.frame);
}

- (CGFloat)height {
    return CGRectGetHeight(self.view.frame);
}

- (void)setPrimaryViewController:(UIViewController *)primaryViewController {
    [self removeViewController:_primaryViewController];
    _primaryViewController = primaryViewController;
    if (self.primaryView) {
        [self configurePrimaryView];
    }
}

- (void)setSecondaryViewController:(UIViewController *)secondaryViewController {
    [self removeViewController:_secondaryViewController];
    _secondaryViewController = secondaryViewController;
    if (self.secondaryView) {
        [self configureSecondaryView];
    }
}

- (void)configurePrimaryView {
    [self addChildViewController:self.primaryViewController];
    self.primaryViewController.view.frame = CGRectMake(0, 0, [self width], [self height]);
    [self.primaryView addSubview:self.primaryViewController.view];
    [self.view bringSubviewToFront:self.primaryView];
    [self.primaryViewController didMoveToParentViewController:self];
}

- (void)configureSecondaryView {
    [self addChildViewController:self.secondaryViewController];
    self.secondaryViewController.view.frame = CGRectMake(0, 0, [self width], [self height]);
    [self.secondaryView addSubview:self.secondaryViewController.view];
    [self.secondaryViewController didMoveToParentViewController:self];
}

- (void)removeViewController:(UIViewController *)viewController {
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

- (void)showPrimaryView {
    self.primaryView.frame = CGRectMake(0, 0, self.width, self.height);
    self.isShowingPrimaryView = YES;
}

- (void)showSecondaryView {
    self.primaryView.frame = CGRectMake(self.width, 0, self.width, self.height);
    self.isShowingPrimaryView = NO;
}

- (void)showPrimaryViewAnimated {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
        [self showPrimaryView];
    } completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];

    CGFloat targetX = self.isShowingPrimaryView ? translation.x : self.width + translation.x;
    targetX = fmin(fmax(0, targetX), [self width]);
    self.primaryView.frame = CGRectMake(targetX, 0, self.view.frame.size.width, self.view.frame.size.height);

    if (sender.state == UIGestureRecognizerStateEnded) {

        CGFloat initialVelocity = fabsf(velocity.x / 100);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:initialVelocity options:0 animations:^{
            if ([self isSlidingRight:velocity]) {
                [self showSecondaryView];
            } else if ([self isSlidingLeft:velocity]) {
                [self showPrimaryView];
            } else if ([self isShowingPrimaryView]) {
                [self showPrimaryView];
            } else {
                [self showSecondaryView];
            }
        } completion:^(BOOL finished) {
        }];
    }
}

- (BOOL)isSlidingRight:(CGPoint)translation {
    return [self isMostlyHorizontal:translation] && translation.x > 0;
}

- (BOOL)isSlidingLeft:(CGPoint)translation {
    return [self isMostlyHorizontal:translation] && translation.x < 0;
}

- (BOOL)isMostlyHorizontal:(CGPoint)translation {
    return fabsf(translation.x) > fabsf(translation.y) * 2;
}

@end
