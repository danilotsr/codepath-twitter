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
        self.tagLine = dictionary[@"description"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.screenName = [aDecoder decodeObjectForKey:@"screen_name"];
        self.profileImageURL = [aDecoder decodeObjectForKey:@"profile_image_url"];
        self.tagLine = [aDecoder decodeObjectForKey:@"description"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.screenName forKey:@"screen_name"];
    [aCoder encodeObject:self.profileImageURL forKey:@"profile_image_url"];
    [aCoder encodeObject:self.tagLine forKey:@"description"];
}

@end
