//
//  DRSlideViewController.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/24/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRSlideViewController : UIViewController

@property (nonatomic, strong) UIViewController *primaryViewController;
@property (nonatomic, strong) UIViewController *secondaryViewController;

- (id)initWithPrimaryViewController:(UIViewController *)primaryViewController
            secondaryViewController:(UIViewController *)secondaryViewController;

- (void)showPrimaryView;
- (void)showPrimaryViewAnimated;
- (void)showSecondaryView;

@end
