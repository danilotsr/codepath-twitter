//
//  DRTwitterClient.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRTwitterClient.h"
#import "DRSessionManager.h"
#import "DRTweet.h"

NSString * const kTwitterConsumerKey = @"B5d3bSLLRMkL6lSZ0UArW5UQ3";
NSString * const kTwitterConsumerSecret = @"NDeJITK035Gjy6hp6yzVjK9aiHfwTguCgiYwnyShPfJbm24bEl";
NSString * const kTwitterBaseURL = @"https://api.twitter.com";

#define BLOCK_SAFE_RUN(block, ...) block ? block(__VA_ARGS__) : nil

@interface DRTwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(DRUser *user, NSError *error);

@end

@implementation DRTwitterClient

+ (DRTwitterClient *)sharedInstance {
    static DRTwitterClient *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[DRTwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseURL]
                                                    consumerKey:kTwitterConsumerKey
                                                 consumerSecret:kTwitterConsumerSecret];
        }
    });

    return instance;
}

- (void)loginWithCompletion:(void (^)(DRUser *, NSError *))completion {
    self.loginCompletion = completion;

    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"GET"
                        callbackURL:[NSURL URLWithString:@"drtwitterdemo://oauth"]
                              scope:nil
                            success:^(BDBOAuth1Credential *requestToken) {
                                NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
                                [[UIApplication sharedApplication] openURL:authURL];
                            } failure:^(NSError *error) {
                                self.loginCompletion(nil, error);
                            }];
}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token"
                            method:@"POST"
                      requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query]
                           success:^(BDBOAuth1Credential *accessToken) {
                               [self.requestSerializer saveAccessToken:accessToken];

                               [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   DRUser *user = [[DRUser alloc] initWithDictionary:responseObject];
                                   [DRSessionManager setCurrentUser:user];
                                   self.loginCompletion(user, nil);
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   [DRSessionManager setCurrentUser:nil];
                                   self.loginCompletion(nil, error);
                               }];
                           } failure:^(NSError *error) {
                               [DRSessionManager setCurrentUser:nil];
                               self.loginCompletion(nil, error);
                           }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          BLOCK_SAFE_RUN(completion, [DRTweet tweetsWithArray:responseObject], nil);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          BLOCK_SAFE_RUN(completion, nil, error);
      }];
}

- (void)postStatusWithMessage:(NSString *)message
                  replyTarget:(DRTweet *)replyTarget
                   completion:(void (^)(DRTweet *, NSError *))completion {
    [self POST:@"1.1/statuses/update.json"
    parameters:@{@"status": message ?: [NSNull null], @"in_reply_to_status_id":replyTarget.tweetID ?: [NSNull null]}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
       BLOCK_SAFE_RUN(completion, [[DRTweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_SAFE_RUN(completion, nil, error);
    }];
}

- (void)retweet:(DRTweet *)originalTweet completion:(void (^)(DRTweet *retweet, NSError *error))completion {
    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", originalTweet.tweetID]
    parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           BLOCK_SAFE_RUN(completion, [[DRTweet alloc] initWithDictionary:responseObject], nil);
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           BLOCK_SAFE_RUN(completion, nil, error);
       }];
}

- (void)favorite:(DRTweet *)tweet completion:(void (^)(DRTweet *tweet, NSError *error))completion {
    [self POST:@"1.1/favorites/create.json"
    parameters:@{@"id": tweet.tweetID}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           BLOCK_SAFE_RUN(completion, [[DRTweet alloc] initWithDictionary:responseObject], nil);
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           BLOCK_SAFE_RUN(completion, nil, error);
       }];
}

- (void)unretweet:(DRTweet *)originalTweet
       completion:(void (^)(DRTweet *retweet, NSError *error))completion {
    [self POST:[NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", originalTweet.tweetID]
    parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           BLOCK_SAFE_RUN(completion, [[DRTweet alloc] initWithDictionary:responseObject], nil);
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           BLOCK_SAFE_RUN(completion, nil, error);
       }];
}

- (void)unfavorite:(DRTweet *)tweet
        completion:(void (^)(DRTweet *tweet, NSError *error))completion {
    [self POST:@"1.1/favorites/destroy.json"
    parameters:@{@"id": tweet.tweetID}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           BLOCK_SAFE_RUN(completion, [[DRTweet alloc] initWithDictionary:responseObject], nil);
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           BLOCK_SAFE_RUN(completion, nil, error);
       }];
}

@end
