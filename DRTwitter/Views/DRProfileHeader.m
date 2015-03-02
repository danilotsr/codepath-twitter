//
//  DRProfileHeader.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/28/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRProfileHeader.h"
#import "UIImageView+AFNetworking.h"

@interface DRProfileHeader()

@end

@implementation DRProfileHeader

- (id)initWithUser:(DRUser *)user {
    self = [self init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (id)init {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"DRProfileHeader" owner:self options:nil];
    id mainView = [views objectAtIndex:0];
    return mainView;
}

- (void)setUser:(DRUser *)user {
    _user = user;
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageURL]];
    if (user.useProfileBackgroundImage) {
        [self.backgroundImageView setImageWithURL:[NSURL URLWithString:user.profileBackgroundImageURL]];
    }
    self.tweetsCountLabel.text = [NSString stringWithFormat:@"%d", self.user.statusesCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%d", self.user.followersCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%d", self.user.friendsCount];
}

@end
