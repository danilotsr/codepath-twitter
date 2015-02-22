//
//  DRSessionManager.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/20/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRSessionManager.h"
#import "DRTwitterClient.h"

NSString * const kCurrentUserKey = @"kCurrentUserKey";
NSString * const kPendingTweetMessage = @"kPendingTweetMessage";
NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@implementation DRSessionManager

static DRUser *_currentUser;
static NSString *_pendingTweetMessage;

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

+ (NSString *)pendingTweetMessage {
    if (!_pendingTweetMessage) {
        _pendingTweetMessage = [[NSUserDefaults standardUserDefaults] objectForKey:kPendingTweetMessage];
    }
    return _pendingTweetMessage;
}

+ (void)setPendingTweetMessage:(NSString *)pendingTweetMessage {
    _pendingTweetMessage = pendingTweetMessage;
    [[NSUserDefaults standardUserDefaults] setObject:_pendingTweetMessage forKey:kPendingTweetMessage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout {
    [DRSessionManager setCurrentUser:nil];
    [DRSessionManager setPendingTweetMessage:nil];
    [[DRTwitterClient sharedInstance].requestSerializer removeAccessToken];
}

@end
