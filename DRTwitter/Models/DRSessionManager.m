//
//  DRSessionManager.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/20/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRSessionManager.h"
#import "DRTwitterClient.h"

NSString * const kCurrentUserKey = @"current_user";
NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@implementation DRSessionManager

static DRUser *_currentUser;

+ (DRUser *)currentUser {
    if (!_currentUser) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data) {
            _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(DRUser *)user {
    _currentUser = user;

    if (_currentUser) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout {
    [DRSessionManager setCurrentUser:nil];
    [[DRTwitterClient sharedInstance].requestSerializer removeAccessToken];
}

@end
