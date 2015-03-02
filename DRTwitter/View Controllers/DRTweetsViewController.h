//
//  DRTweetsViewController.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRUser.h"
#import "DRTweetDelegate.h"

@class DRTweetsViewController;

@protocol DRTweetsViewDataSource <NSObject>

- (void)tweetsViewController:(DRTweetsViewController *)tweetsViewController
  recentTweetsWithCompletion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)tweetsViewController:(DRTweetsViewController *)tweetsViewController
                 tweetsAfter:(DRTweet *)tweet
              withCompletion:(void (^)(NSArray *tweets, NSError *error))completion;

@end

@interface DRTweetsViewController : UIViewController

@property (weak, nonatomic) id<DRTweetsViewDataSource> dataSource;
@property (weak, nonatomic) id<DRTweetDelegate> delegate;

- (void)reloadData;
- (void)setTableHeader:(UIView *)headerView;

@end
