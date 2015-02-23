//
//  DRTweetsViewController.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRTweetsViewController.h"
#import "DRTweetCell.h"
#import "DRTwitterClient.h"
#import "DRLoginViewController.h"
#import "DRSessionManager.h"
#import "DRComposeViewController.h"
#import "DRTweetDetailsViewController.h"
#import "DRTweetDelegate.h"

NSString * const kTweetCell = @"TweetCell";

@interface DRTweetsViewController () <UITableViewDataSource, UITableViewDelegate, DRComposeViewControllerDelegate, DRTweetDelegate>

@property (nonatomic, strong) DRUser *user;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSMutableSet *seenTweetIDs;

@end

@implementation DRTweetsViewController

- (id)initWithUser:(DRUser *)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Home";
    self.navigationController.navigationBar.opaque = YES;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onLogout)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onNewTapped)];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl beginRefreshing];
    [self.refreshControl addTarget:self action:@selector(downloadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DRTweetCell" bundle:nil] forCellReuseIdentifier:kTweetCell];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 43;

    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 50)];
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingIndicator.center = tableFooterView.center;
    [tableFooterView addSubview:self.loadingIndicator];
    self.tableView.tableFooterView = tableFooterView;

    [self downloadTweets];
}

- (void)downloadTweetsWithRefreshControl {
    [self.refreshControl beginRefreshing];
    [self downloadTweets];
}

- (void)downloadTweets {
    [[DRTwitterClient sharedInstance]
     homeTimelineWithParams:nil
     completion:^(NSArray *tweets, NSError *error) {
         [self.refreshControl endRefreshing];
         if (error) {
             NSLog(@"failed: %@", error);
         } else {
             self.tweets = [NSMutableArray arrayWithArray:tweets];
             self.seenTweetIDs = [NSMutableSet set];
             for (DRTweet *tweet in self.tweets) {
                 [self.seenTweetIDs addObject:tweet.tweetID];
             }
             [self.tableView reloadData];
         }
     }];
}

- (void)appendTweets {
    [self.loadingIndicator startAnimating];
    DRTweet *lastTweet = self.tweets[self.tweets.count - 1];
    [[DRTwitterClient sharedInstance]
     homeTimelineWithParams:@{@"max_id": lastTweet.tweetID}
     completion:^(NSArray *tweets, NSError *error) {
         [self.loadingIndicator stopAnimating];
         if (error) {
             NSLog(@"failed: %@", error);
         } else {
             for (DRTweet *tweet in tweets) {
                 if (![self.seenTweetIDs containsObject:tweet.tweetID]) {
                     [self.tweets addObject:tweet];
                 }
             }
             [self.tableView reloadData];
         }
     }];
}

- (void)onLogout {
    [DRSessionManager logout];
    [self presentViewController:[[DRLoginViewController alloc] init] animated:YES completion:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DRTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:kTweetCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tweet = self.tweets[indexPath.row];
    cell.delegate = self;

    if (indexPath.row == self.tweets.count - 1) {
        [self appendTweets];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DRTweetDetailsViewController *detailsVC = [[DRTweetDetailsViewController alloc] init];
    detailsVC.tweet = self.tweets[indexPath.row];
    detailsVC.delegate = self;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)replyWithTarget:(DRTweet *)tweet {
    [self composeTweetWithTarget:tweet];
}

- (void)retweetWithTarget:(DRTweet *)tweet {
    [[DRTwitterClient sharedInstance] retweet:tweet completion:nil];
    tweet.originalTweet.retweetsCount++;
    tweet.originalTweet.retweeted = YES;
    [self.tableView reloadData];
}

- (void)favoriteWithTarget:(DRTweet *)tweet {
    [[DRTwitterClient sharedInstance] favorite:tweet completion:nil];
    tweet.originalTweet.favoritesCount++;
    tweet.originalTweet.favorited = YES;
    [self.tableView reloadData];
}

- (void)undoRetweetWithTarget:(DRTweet *)tweet {
    [[DRTwitterClient sharedInstance] unretweet:tweet completion:nil];
    tweet.originalTweet.retweetsCount--;
    tweet.originalTweet.retweeted = NO;
    [self.tableView reloadData];
}

- (void)unfavoriteWithTarget:(DRTweet *)tweet {
    [[DRTwitterClient sharedInstance] unfavorite:tweet completion:nil];
    tweet.originalTweet.favoritesCount--;
    tweet.originalTweet.favorited = NO;
    [self.tableView reloadData];
}

- (void)onNewTapped {
    [self composeTweetWithTarget:nil];
}

- (void)composeTweetWithTarget:(DRTweet *)replyTarget {
    DRComposeViewController *composeVC = [[DRComposeViewController alloc] initWithReplyTarget:replyTarget];
    composeVC.delegate = self;
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:composeVC];
    [self.navigationController presentViewController:navigationVC animated:YES completion:nil];
}

- (void)composeViewController:(DRComposeViewController *)composeViewController didPostTweet:(DRTweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

@end
