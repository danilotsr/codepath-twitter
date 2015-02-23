//
//  TweetCell.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRTweet.h"
#import "DRTweetDelegate.h"

@interface DRTweetCell : UITableViewCell

@property (nonatomic, strong) DRTweet *tweet;
@property (nonatomic, weak) id<DRTweetDelegate> delegate;

@end