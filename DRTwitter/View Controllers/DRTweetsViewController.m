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

NSString * const kTweetCell = @"TweetCell";

@interface DRTweetsViewController () <UITableViewDataSource, UITableViewDelegate, DRComposeViewControllerDelegate>

@property (nonatomic, strong) DRUser *user;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *tweets;

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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self downloadTweets];
}

- (void)downloadTweetsWithRefreshControl {
    [self.refreshControl beginRefreshing];
    [self downloadTweets];
}

- (void)downloadTweets {
    [[DRTwitterClient sharedInstance] homeTimelineWithParams:nil
                                                  completion:^(NSArray *tweets, NSError *error) {
                                                      [self.refreshControl endRefreshing];
                                                      if (error) {
                                                          NSLog(@"failed: %@", error);
                                                      } else {
                                                          self.tweets = [NSMutableArray arrayWithArray:tweets];
                                                          [self.tableView reloadData];
                                                      }
                                                  }];
}

- (void)onLogout {
    [DRSessionManager logout];
    [self presentViewController:[[DRLoginViewController alloc] init] animated:YES completion:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

- (void)onNewTapped {
    DRComposeViewController *composeVC = [[DRComposeViewController alloc] init];
    composeVC.delegate = self;
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:composeVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
}

- (void)composeViewController:(DRComposeViewController *)composeViewController didPostTweet:(DRTweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DRTweetDetailsViewController *detailsVC = [[DRTweetDetailsViewController alloc] init];
    detailsVC.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

@end
