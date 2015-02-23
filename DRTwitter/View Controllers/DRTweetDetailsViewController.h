//
//  DRTweetDetailsViewController.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/22/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRTweet.h"
#import "DRTweetDelegate.h"

@interface DRTweetDetailsViewController : UIViewController

@property (nonatomic, strong) DRTweet *tweet;
@property (nonatomic, weak) id<DRTweetDelegate> delegate;

- (id)initWithTweet:(DRTweet *)tweet;

@end
