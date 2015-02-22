//
//  DRTweetDetailsViewController.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/22/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRTweet.h"

@interface DRTweetDetailsViewController : UIViewController

@property (nonatomic, strong) DRTweet *tweet;

- (id)initWithTweet:(DRTweet *)tweet;

@end
