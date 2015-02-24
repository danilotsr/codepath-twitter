//
//  DRTweet.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRTweet.h"

@implementation DRTweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.tweetID = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        NSString *createdAtString = dictionary[@"created_at"];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];

        self.user = [[DRUser alloc] initWithDictionary:dictionary[@"user"]];

        if (dictionary[@"retweeted_status"]) {
            self.retweetSource = [[DRTweet alloc] initWithDictionary:dictionary[@"retweeted_status"]];
        }

        self.retweetsCount = [dictionary[@"retweet_count"] integerValue];
        self.favoritesCount = [dictionary[@"favorite_count"] integerValue];

        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.favorited = [dictionary[@"favorited"] boolValue];

        self.urls = dictionary[@"entities"][@"urls"];
        self.hashtags = dictionary[@"entities"][@"hashtags"];
        self.userMentions = dictionary[@"entities"][@"user_mentions"];
    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[DRTweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

- (NSString *)shortCreatedAt {
    NSTimeInterval elapsedTime = -1 * [self.createdAt timeIntervalSinceNow];

    if (elapsedTime < 60) {
        return [NSString stringWithFormat:@"%.0fs", elapsedTime];
    } else if (elapsedTime < 3600) {
        return [NSString stringWithFormat:@"%.0fm", elapsedTime / 60];
    } else if (elapsedTime < 86400) {
        return [NSString stringWithFormat:@"%.0fh", elapsedTime / 3600];
    } else if (elapsedTime < 7 * 86400) {
        return [NSString stringWithFormat:@"%.0fd", elapsedTime / 86400];
    }
    return [NSString stringWithFormat:@"%.0fw", elapsedTime / 7 * 86400];
}

- (BOOL)wasRetweeded {
    return self.retweetSource != nil;
}

- (DRTweet *)originalTweet {
    return [self wasRetweeded] ? self.retweetSource : self;
}

- (NSArray *)entitiesMetadata {
    // TODO: move this to the setter so that it is done only once
    NSMutableArray *replacements = [NSMutableArray array];

    for (NSDictionary *urlDict in self.originalTweet.urls) {
        NSUInteger offset = [urlDict[@"indices"][0] unsignedIntegerValue];
        NSUInteger end = [urlDict[@"indices"][1] unsignedIntegerValue];
        NSDictionary *replacementDict = @{@"offset": @(offset),
                                          @"length": @(end - offset),
                                          @"display": urlDict[@"display_url"],
                                          @"url": urlDict[@"url"]};
        [replacements addObject:replacementDict];
    }

    for (NSDictionary *hashtagDict in self.originalTweet.hashtags) {
        NSUInteger offset = [hashtagDict[@"indices"][0] unsignedIntegerValue];
        NSUInteger end = [hashtagDict[@"indices"][1] unsignedIntegerValue];
        NSString *text = hashtagDict[@"text"];

        NSString *hashtagUrl = [NSString stringWithFormat:@"https://twitter.com/hashtag/%@", text];

        [replacements addObject:@{@"offset": @(offset),
                                  @"length": @(end - offset),
                                  @"display": text,
                                  @"url": hashtagUrl}];
    }

    for (NSDictionary *userDict in self.originalTweet.userMentions) {
        NSUInteger offset = [userDict[@"indices"][0] unsignedIntegerValue];
        NSUInteger end = [userDict[@"indices"][1] unsignedIntegerValue];
        NSString *screenName = userDict[@"screen_name"];

        NSString *userUrl = [NSString stringWithFormat:@"https://twitter.com/%@", screenName];

        [replacements addObject:@{@"offset": @(offset),
                                  @"length": @(end - offset),
                                  @"display": [NSString stringWithFormat:@"@%@", screenName],
                                  @"url": userUrl}];
    }

    return [replacements sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *dict1, NSDictionary *dict2) {
        if ([dict1[@"offset"] integerValue] < [dict2[@"offset"] integerValue]) {
            return NSOrderedAscending;
        } else if ([dict1[@"offset"] integerValue] > [dict2[@"offset"] integerValue]) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
}

- (NSAttributedString *)textWithEntities {
    NSArray *entitiesMetadata = [self.originalTweet entitiesMetadata];

    NSMutableString *formattedText = [NSMutableString stringWithString:self.originalTweet.text];
    NSInteger lengthDiff = 0;
    for (NSDictionary *dict in entitiesMetadata) {
        NSInteger offset = [dict[@"offset"] integerValue] + lengthDiff;
        NSInteger length = [dict[@"length"] integerValue];
        NSString *display = dict[@"display"];
        [formattedText replaceCharactersInRange:NSMakeRange(offset, length) withString:display];
        lengthDiff += display.length - length;
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:formattedText];
    [attributedString beginEditing];
    lengthDiff = 0;
    for (NSDictionary *linkDict in entitiesMetadata) {
        NSInteger offset = [linkDict[@"offset"] integerValue] + lengthDiff;
        NSInteger length = [linkDict[@"length"] integerValue];
        NSString *display = linkDict[@"display"];
        NSURL *url = [NSURL URLWithString:linkDict[@"url"]];
        [attributedString addAttribute:NSLinkAttributeName value:url range:NSMakeRange(offset, display.length)];
        lengthDiff += display.length - length;
    }
    [attributedString endEditing];
    return attributedString;
}

@end
