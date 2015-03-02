//
//  DRTweetsViewController.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRTweetsViewController.h"
#import "DRTweetCell.h"
#import "DRTweetDetailsViewController.h"

NSString * const kTweetCell = @"TweetCell";

@interface DRTweetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DRUser *user;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSMutableSet *seenTweetIDs;

@end

@implementation DRTweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl beginRefreshing];
    [self.refreshControl addTarget:self action:@selector(downloadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DRTweetCell" bundle:nil] forCellReuseIdentifier:kTweetCell];
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 50)];
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingIndicator.center = tableFooterView.center;
    [tableFooterView addSubview:self.loadingIndicator];
    self.tableView.tableFooterView = tableFooterView;

    [self downloadTweets];
}

- (void)setTableHeader:(UIView *)headerView {
    self.tableView.tableHeaderView = headerView;
}

- (void)downloadTweetsWithRefreshControl {
    [self.refreshControl beginRefreshing];
    [self downloadTweets];
}

- (void)downloadTweets {
    void(^completion)(NSArray *, NSError *) = ^(NSArray *tweets, NSError *error) {
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
    };
    [self.dataSource tweetsViewController:self recentTweetsWithCompletion:completion];
}

- (void)appendTweets {
    [self.loadingIndicator startAnimating];
    void(^completion)(NSArray *, NSError *) = ^(NSArray *tweets, NSError *error) {
        [self.loadingIndicator stopAnimating];
        if (error) {
            NSLog(@"failed: %@", error);
        } else {
            for (DRTweet *tweet in tweets) {
                if (![self.seenTweetIDs containsObject:tweet.tweetID]) {
                    [self.tweets addObject:tweet];
                    [self.seenTweetIDs addObject:tweet.tweetID];
                }
            }
            [self.tableView reloadData];
        }
    };
    DRTweet *lastTweet = self.tweets[self.tweets.count - 1];
    [self.dataSource tweetsViewController:self tweetsAfter:lastTweet withCompletion:completion];
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
    cell.delegate = self.delegate;

    if (indexPath.row == self.tweets.count - 1) {
        [self appendTweets];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DRTweetDetailsViewController *detailsVC = [[DRTweetDetailsViewController alloc] init];
    detailsVC.tweet = self.tweets[indexPath.row];
    detailsVC.delegate = self.delegate;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)reloadData {
    [self.tableView reloadData];
}

@end
