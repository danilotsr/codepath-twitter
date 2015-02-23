//
//  DRTweetDelegate.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/22/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRTweet.h"

// TODO: kill this?

@protocol DRTweetDelegate <NSObject>

- (void)replyWithTarget:(DRTweet *)tweet;
- (void)retweetWithTarget:(DRTweet *)tweet;
- (void)favoriteWithTarget:(DRTweet *)tweet;
- (void)undoRetweetWithTarget:(DRTweet *)tweet;
- (void)unfavoriteWithTarget:(DRTweet *)tweet;

@end
