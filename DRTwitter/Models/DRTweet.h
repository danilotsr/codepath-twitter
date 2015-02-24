//
//  DRTweet.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRUser.h"
#import <UIKit/NSAttributedString.h>

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
@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) NSArray *hashtags;
@property (nonatomic, strong) NSArray *userMentions;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)shortCreatedAt;
- (BOOL)wasRetweeded;
- (DRTweet *)originalTweet;
- (NSArray *)entitiesMetadata;
- (NSAttributedString *)textWithEntities;

@end
