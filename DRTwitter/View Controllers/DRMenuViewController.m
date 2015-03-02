//
//  DRMenuViewController.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/27/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRMenuViewController.h"
#import "DRSessionManager.h"
#import "UIImageView+AFNetworking.h"

@interface DRMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuOptions;
@property (strong, nonatomic) UIImageView *profilePic;

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer;

@end

@implementation DRMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    DRUser *user = [DRSessionManager currentUser];

    // TODO: implement auto-layout

    CGRect tableHeaderRect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 68);

    self.profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 60, 60)];
    self.profilePic.layer.cornerRadius = 5;
    self.profilePic.clipsToBounds = YES;
    self.profilePic.userInteractionEnabled = YES;
    [self.profilePic setImageWithURL:[NSURL URLWithString:user.profileImageURL]];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTapFrom:)];
    [self.profilePic addGestureRecognizer:tapGesture];

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 16, 200, 16)];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = user.name;

    UILabel *screenNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 37, 200, 15)];
    screenNameLabel.font = [UIFont systemFontOfSize:12];
    screenNameLabel.textColor = [UIColor lightGrayColor];
    screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];

    UIView *tableHeader = [[UIView alloc] initWithFrame:tableHeaderRect];
    [tableHeader addSubview:self.profilePic];
    [tableHeader addSubview:nameLabel];
    [tableHeader addSubview:screenNameLabel];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    self.tableView.tableHeaderView = tableHeader;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self configureMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureMenu {
    void (^onHomeTimeline)() = ^void() {
        [self.delegate showHomeTimelineFromMenu:self];
    };
    void (^onShowProfile)() = ^void() {
        [self.delegate menuViewController:self showProfileForUser:[DRSessionManager currentUser]];
    };
    void (^onShowMentions)() = ^void() {
        [self.delegate showUserMentionsFromMenu:self];
    };

    self.menuOptions = @[
                         @{@"display":@"Home Timeline", @"selection":onHomeTimeline},
                         @{@"display":@"Your Profile", @"selection":onShowProfile},
                         @{@"display":@"Your Mentions", @"selection":onShowMentions}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.menuOptions[indexPath.row][@"display"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.backgroundColor = [UIColor darkGrayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    void (^callback)() = self.menuOptions[indexPath.row][@"selection"];
    if (callback) {
        callback();
    }
}


- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
    [self.delegate menuViewController:self showProfileForUser:[DRSessionManager currentUser]];
}

@end
