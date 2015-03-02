//
//  DRProfileViewController.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/27/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DRTweetCell.h"
#import "DRTwitterClient.h"
#import "DRProfileHeader.h"
#import "DRTweetsViewController.h"

@interface DRProfileViewController () <DRTweetsViewDataSource>

@property (strong, nonatomic) DRTweetsViewController *tweetsVC;

@end

@implementation DRProfileViewController

- (id)initWithUser:(DRUser *)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.user.name;
    [self.navigationDelegate didLoadNavigationItem:self.navigationItem];

    DRProfileHeader *tableHeader = [[DRProfileHeader alloc] initWithUser:self.user];

    self.tweetsVC = [[DRTweetsViewController alloc] init];
    self.tweetsVC.dataSource = self;

    [self addChildViewController:self.tweetsVC];
    self.tweetsVC.view.frame = self.view.frame;
    [self.view addSubview:self.tweetsVC.view];
    [self.tweetsVC didMoveToParentViewController:self];

    [self.tweetsVC setTableHeader:tableHeader];
}

- (void)tweetsViewController:(DRTweetsViewController *)tweetsViewController recentTweetsWithCompletion:(void (^)(NSArray *, NSError *))completion {
    [[DRTwitterClient sharedInstance] timelineForUser:self.user withParams:nil completion:completion];
}

- (void)tweetsViewController:(DRTweetsViewController *)tweetsViewController tweetsAfter:(DRTweet *)tweet withCompletion:(void (^)(NSArray *, NSError *))completion {
    NSDictionary *params = @{@"max_id": tweet.tweetID};
    [[DRTwitterClient sharedInstance] timelineForUser:self.user withParams:params completion:completion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
