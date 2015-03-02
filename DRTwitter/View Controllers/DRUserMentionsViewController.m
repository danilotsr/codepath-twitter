//
//  DRUserMentionsViewController.m
//  DRTwitter
//
//  Created by Danilo Resende on 3/1/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRUserMentionsViewController.h"
#import "DRTweetsViewController.h"
#import "DRTwitterClient.h"

@interface DRUserMentionsViewController () <DRTweetsViewDataSource>

@property (strong, nonatomic) DRTweetsViewController *tweetsVC;

@end

@implementation DRUserMentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Mentions";
    [self.navigationDelegate didLoadNavigationItem:self.navigationItem];

    self.tweetsVC = [[DRTweetsViewController alloc] init];
    self.tweetsVC.dataSource = self;

    [self addChildViewController:self.tweetsVC];
    self.tweetsVC.view.frame = self.view.frame;
    [self.view addSubview:self.tweetsVC.view];
    [self.tweetsVC didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tweetsViewController:(DRTweetsViewController *)tweetsViewController recentTweetsWithCompletion:(void (^)(NSArray *, NSError *))completion {
    [[DRTwitterClient sharedInstance] userMentionsWithParams:nil completion:completion];
}

- (void)tweetsViewController:(DRTweetsViewController *)tweetsViewController tweetsAfter:(DRTweet *)tweet withCompletion:(void (^)(NSArray *, NSError *))completion {
    NSDictionary *params = @{@"max_id": tweet.tweetID};
    [[DRTwitterClient sharedInstance] userMentionsWithParams:params completion:completion];
}

@end
