//
//  DRSessionManager.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/20/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRUser.h"

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface DRSessionManager : NSObject

+ (DRUser *)currentUser;
+ (void)setCurrentUser:(DRUser *)user;
+ (void)logout;

@end
