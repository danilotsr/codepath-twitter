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

@interface DRTweetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DRUser *user;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tweets;

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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onLogout)];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DRTweetCell" bundle:nil] forCellReuseIdentifier:@"DRTweetCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self downloadTweets];
}

- (void)downloadTweets {
    [[DRTwitterClient sharedInstance] homeTimelineWithParams:nil
                                                  completion:^(NSArray *tweets, NSError *error) {
                                                      if (error) {
                                                          NSLog(@"failed: %@", error);
                                                      } else {
                                                          self.tweets = tweets;
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
    DRTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DRTweetCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

@end
