//
//  DRComposeViewController.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/21/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRTweet.h"

@class DRComposeViewController;

@protocol DRComposeViewControllerDelegate <NSObject>

- (void)composeViewController:(DRComposeViewController *)composeViewController didPostTweet:(DRTweet *)tweet;

@end

@interface DRComposeViewController : UIViewController

@property (nonatomic, weak) id<DRComposeViewControllerDelegate> delegate;

@end
