//
//  DRMainViewController.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/27/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRMainViewController.h"
#import "DRMenuViewController.h"
#import "DRTweetsViewController.h"
#import "DRSlideViewController.h"
#import "DRSessionManager.h"
#import "DRProfileViewController.h"
#import "DRTweetDelegate.h"
#import "DRTwitterClient.h"
#import "DRComposeViewController.h"
#import "DRHomeViewController.h"
#import "DRUserMentionsViewController.h"
#import "DRNavigationDelegate.h"

@interface DRMainViewController () <DRTweetDelegate, DRMenuViewControllerDelegate, DRComposeViewControllerDelegate, DRNavigationDelegate>

@property (nonatomic, strong) DRMenuViewController *menuVC;
@property (nonatomic, strong) DRSlideViewController *slideVC;

@end

@implementation DRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.menuVC = [[DRMenuViewController alloc] init];
    self.menuVC.delegate = self;

    UINavigationController *navigationForMenuVC = [[UINavigationController alloc] initWithRootViewController:self.menuVC];
    navigationForMenuVC.navigationBar.opaque = YES;

    DRHomeViewController *homeVC = [[DRHomeViewController alloc] init];
    homeVC.navigationDelegate = self;
    UINavigationController *navigationForHomeVC = [self navigationControllerWithRoot:homeVC];

    self.slideVC = [[DRSlideViewController alloc] initWithPrimaryViewController:navigationForHomeVC
                                                        secondaryViewController:navigationForMenuVC];

    [self addChildViewController:self.slideVC];
    self.slideVC.view.frame = self.view.frame;
    [self.view addSubview:self.slideVC.view];
    [self.slideVC didMoveToParentViewController:self];
}

- (void)showHomeTimelineFromMenu:(DRMenuViewController *)menuViewController {
    DRHomeViewController *homeVC = [[DRHomeViewController alloc] init];
    homeVC.navigationDelegate = self;
    UINavigationController *navigationVC = [self navigationControllerWithRoot:homeVC];
    self.slideVC.primaryViewController = navigationVC;
    [self.slideVC showPrimaryViewAnimated];
}

- (void)showUserMentionsFromMenu:(DRMenuViewController *)menuViewController {
    DRUserMentionsViewController *mentionsVC = [[DRUserMentionsViewController alloc] init];
    mentionsVC.navigationDelegate = self;
    UINavigationController *navigationVC = [self navigationControllerWithRoot:mentionsVC];
    self.slideVC.primaryViewController = navigationVC;
    [self.slideVC showPrimaryViewAnimated];
}

- (void)menuViewController:(DRMenuViewController *)menuViewController showProfileForUser:(DRUser *)user {
    DRProfileViewController *userProfileVC = [[DRProfileViewController alloc] initWithUser:user];
    userProfileVC.navigationDelegate = self;
    UINavigationController *navigationVC = [self navigationControllerWithRoot:userProfileVC];
    self.slideVC.primaryViewController = navigationVC;
    [self.slideVC showPrimaryViewAnimated];
}

- (UINavigationController *)navigationControllerWithRoot:(UIViewController *)rootViewController {
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    navigationVC.navigationBar.opaque = YES;
    return navigationVC;
}

- (void)didLoadNavigationItem:(UINavigationItem *)navigationItem {
    navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(onLogout)];

    navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(onNewTapped)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
//    [self.tweetsVC reloadData];
}

- (void)replyWithTarget:(DRTweet *)tweet {
    [self composeTweetWithTarget:tweet];
}

- (void)retweetWithTarget:(DRTweet *)tweet {
    [[DRTwitterClient sharedInstance] retweet:tweet completion:nil];
    tweet.originalTweet.retweetsCount++;
    tweet.originalTweet.retweeted = YES;
    [self reloadData];
}

- (void)favoriteWithTarget:(DRTweet *)tweet {
    [[DRTwitterClient sharedInstance] favorite:tweet completion:nil];
    tweet.originalTweet.favoritesCount++;
    tweet.originalTweet.favorited = YES;
    [self reloadData];
}

- (void)undoRetweetWithTarget:(DRTweet *)tweet {
    [[DRTwitterClient sharedInstance] unretweet:tweet completion:nil];
    tweet.originalTweet.retweetsCount--;
    tweet.originalTweet.retweeted = NO;
    [self reloadData];
}

- (void)unfavoriteWithTarget:(DRTweet *)tweet {
    [[DRTwitterClient sharedInstance] unfavorite:tweet completion:nil];
    tweet.originalTweet.favoritesCount--;
    tweet.originalTweet.favorited = NO;
    [self reloadData];
}

- (void)onNewTapped {
    [self composeTweetWithTarget:nil];
}

- (void)composeTweetWithTarget:(DRTweet *)replyTarget {
    DRComposeViewController *composeVC = [[DRComposeViewController alloc] initWithReplyTarget:replyTarget];
    composeVC.delegate = self;
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:composeVC];

    // TODO: figure out which navigation VC to use here
    [self.slideVC.primaryViewController.navigationController presentViewController:navigationVC animated:YES completion:nil];
}

- (void)composeViewController:(DRComposeViewController *)composeViewController didPostTweet:(DRTweet *)tweet {
    // TODO
//    [self.tweets insertObject:tweet atIndex:0];
//    [self.tableView reloadData];
}

- (void)onLogout {
    [DRSessionManager logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

@end
