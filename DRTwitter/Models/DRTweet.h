//
//  DRTweet.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRUser.h"

@interface DRTweet : NSObject

@property (nonatomic, strong) NSString *tweetID;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) DRUser *user;
@property (nonatomic, strong) DRTweet *retweetSource;
@property (nonatomic, assign) NSInteger retweetsCount;
@property (nonatomic, assign) NSInteger favoritesCount;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) BOOL favorited;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)tweetsWithArray:(NSArray *)array;
- (NSString *)shortCreatedAt;
- (BOOL)wasRetweeded;
- (DRTweet *)originalTweet;

@end
