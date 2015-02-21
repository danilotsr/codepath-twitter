//
//  DRTwitterClient.h
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "DRUser.h"

@interface DRTwitterClient : BDBOAuth1RequestOperationManager

+ (DRTwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(DRUser *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

@end
