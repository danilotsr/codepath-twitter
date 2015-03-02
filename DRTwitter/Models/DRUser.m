//
//  DRUser.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRUser.h"

@implementation DRUser

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageURL = dictionary[@"profile_image_url"];
        self.profileBackgroundImageURL = dictionary[@"profile_background_image_url"];
        self.useProfileBackgroundImage = [dictionary[@"profile_use_background_image"] boolValue];
        self.profileBackgroundColor = dictionary[@"profile_background_color"];
        self.tagLine = dictionary[@"description"];
        self.followersCount = [dictionary[@"followers_count"] unsignedIntegerValue];
        self.statusesCount = [dictionary[@"statuses_count"] unsignedIntegerValue];
        self.friendsCount = [dictionary[@"friends_count"] unsignedIntegerValue];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.screenName = [aDecoder decodeObjectForKey:@"screen_name"];
        self.profileImageURL = [aDecoder decodeObjectForKey:@"profile_image_url"];
        self.profileBackgroundImageURL = [aDecoder decodeObjectForKey:@"profile_background_image_url"];
        self.useProfileBackgroundImage = [aDecoder decodeBoolForKey:@"profile_use_background_image"];
        self.profileBackgroundColor = [aDecoder decodeObjectForKey:@"profile_background_color"];
        self.tagLine = [aDecoder decodeObjectForKey:@"description"];
        self.followersCount = [aDecoder decodeIntegerForKey:@"followers_count"];
        self.statusesCount = [aDecoder decodeIntegerForKey:@"statuses_count"];
        self.friendsCount = [aDecoder decodeIntegerForKey:@"friends_count"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.screenName forKey:@"screen_name"];
    [aCoder encodeObject:self.profileImageURL forKey:@"profile_image_url"];
    [aCoder encodeObject:self.profileBackgroundImageURL forKey:@"profile_background_image_url"];
    [aCoder encodeBool:self.useProfileBackgroundImage forKey:@"profile_use_background_image"];
    [aCoder encodeObject:self.profileBackgroundColor forKey:@"profile_background_color"];
    [aCoder encodeObject:self.tagLine forKey:@"description"];
    [aCoder encodeInt:self.followersCount forKey:@"followers_count"];
    [aCoder encodeInt:self.statusesCount forKey:@"statuses_count"];
    [aCoder encodeInt:self.friendsCount forKey:@"friends_count"];
}

- (BOOL)isEqual:(DRUser *)otherUser {
    return [self.screenName isEqualToString:otherUser.screenName];
}

@end
