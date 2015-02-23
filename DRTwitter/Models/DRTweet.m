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

@end
