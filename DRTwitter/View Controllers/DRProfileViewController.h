//
//  DRProfileViewController.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/27/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRUser.h"
#import "DRTweetDelegate.h"
#import "DRNavigationDelegate.h"

@interface DRProfileViewController : UIViewController

@property (strong, nonatomic) DRUser *user;
@property (weak, nonatomic) id<DRTweetDelegate> delegate;
@property (weak, nonatomic) id<DRNavigationDelegate> navigationDelegate;

- (id)initWithUser:(DRUser *)user;

@end
