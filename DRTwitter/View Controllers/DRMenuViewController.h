//
//  DRMenuViewController.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/27/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRUser.h"

@class DRMenuViewController;

@protocol DRMenuViewControllerDelegate <NSObject>

- (void)showHomeTimelineFromMenu:(DRMenuViewController *)menuViewController;
- (void)showUserMentionsFromMenu:(DRMenuViewController *)menuViewController;
- (void)menuViewController:(DRMenuViewController *)menuViewController showProfileForUser:(DRUser *)user;

@end

@interface DRMenuViewController : UIViewController

@property (weak, nonatomic) id<DRMenuViewControllerDelegate> delegate;

@end
