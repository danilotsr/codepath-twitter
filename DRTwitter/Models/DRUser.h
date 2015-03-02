//
//  DRUser.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRUser : NSObject<NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic, assign) BOOL useProfileBackgroundImage;
@property (nonatomic, strong) NSString *profileBackgroundImageURL;
@property (nonatomic, strong) NSString *profileBackgroundColor;
@property (nonatomic, strong) NSString *tagLine;
@property (nonatomic, assign) NSUInteger followersCount;
@property (nonatomic, assign) NSUInteger statusesCount;
@property (nonatomic, assign) NSUInteger friendsCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
