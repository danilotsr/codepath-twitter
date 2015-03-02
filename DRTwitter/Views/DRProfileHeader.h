//
//  DRProfileHeader.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/28/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRUser.h"

@interface DRProfileHeader : UIView

// TODO: is this really necessary?
@property (weak, nonatomic) IBOutlet NSObject *fileOwner;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;

@property (strong, nonatomic) DRUser *user;

- (id)initWithUser:(DRUser *)user;

@end
