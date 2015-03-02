//
//  DRTwitterClient.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "DRUser.h"
#import "DRTweet.h"

@interface DRTwitterClient : BDBOAuth1RequestOperationManager

+ (DRTwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(DRUser *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)timelineForUser:(DRUser *)user
             withParams:(NSDictionary *)params
             completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)userMentionsWithParams:(NSDictionary *)params
                    completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)postStatusWithMessage:(NSString *)message
                  replyTarget:(DRTweet *)replyTarget
                   completion:(void (^)(DRTweet *tweet, NSError *error))completion;

- (void)retweet:(DRTweet *)originalTweet
     completion:(void (^)(DRTweet *retweet, NSError *error))completion;

- (void)favorite:(DRTweet *)tweet
      completion:(void (^)(DRTweet *tweet, NSError *error))completion;

- (void)unretweet:(DRTweet *)originalTweet
       completion:(void (^)(DRTweet *retweet, NSError *error))completion;

- (void)unfavorite:(DRTweet *)tweet
        completion:(void (^)(DRTweet *tweet, NSError *error))completion;

@end
