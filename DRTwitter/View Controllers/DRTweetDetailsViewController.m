//
//  DRTweetDetailsViewController.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/22/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRTweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DRTwitterClient.h"

NSString * const kRetweet = @"RETWEET";
NSString * const kRetweets = @"RETWEETS";
NSString * const kFavorite = @"FAVORITE";
NSString * const kFavorites = @"FAVORITES";

@interface DRTweetDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *retweetedIcon;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;

@property (nonatomic, strong, readonly) DRTweet *originalTweet;

- (void)updateCountersView;
- (NSLayoutConstraint *)findConstraintForRetweetedHeader;

@end

@implementation DRTweetDetailsViewController

- (id)initWithTweet:(DRTweet *)tweet {
    self = [super init];
    if (self) {
        self.tweet = tweet;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.title = @"Tweet";

    self.messageLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.messageLabel.bounds);

    self.profileImageView.layer.cornerRadius = 8;
    self.profileImageView.clipsToBounds = YES;

    if ([self.tweet wasRetweeded]) {
        self.retweetedLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.user.name];
    }
    self.retweetedLabel.hidden = ![self.tweet wasRetweeded];
    self.retweetedIcon.hidden = ![self.tweet wasRetweeded];

    self.messageLabel.text = self.originalTweet.text;
    self.nameLabel.text = self.originalTweet.user.name;
    self.userNameLabel.text = [NSString stringWithFormat:@"@%@", self.originalTweet.user.screenName];

    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.originalTweet.user.profileImageURL]];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.timestampLabel.text = [dateFormatter stringFromDate:self.originalTweet.createdAt];

    [self updateCountersView];
}

- (DRTweet *)originalTweet {
    return [self.tweet wasRetweeded] ? self.tweet.retweetSource : self.tweet;
}

- (void)updateCountersView {
    self.retweetsLabel.text = self.originalTweet.retweetsCount > 1 ? kRetweets : kRetweet;
    self.favoritesLabel.text = self.originalTweet.favoritesCount > 1 ? kFavorites : kFavorite;
    self.retweetsCountLabel.text = [NSString stringWithFormat:@"%ld", self.originalTweet.retweetsCount];
    self.favoritesCountLabel.text = [NSString stringWithFormat:@"%ld", self.originalTweet.favoritesCount];

    self.retweetButton.selected = self.originalTweet.retweeted;
    self.favoriteButton.selected = self.originalTweet.favorited;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSLayoutConstraint *constraint = [self findConstraintForRetweetedHeader];
    constraint.active = [self.tweet wasRetweeded];
}

- (NSLayoutConstraint *)findConstraintForRetweetedHeader {
    NSArray *constraints = self.view.constraints;
    for (NSLayoutConstraint *constraint in constraints) {
        if ([self.profileImageView isEqual:constraint.firstItem] &&
            [self.retweetedIcon isEqual:constraint.secondItem]) {
            return constraint;
        }
    }
    return nil;
}

- (IBAction)onReply:(id)sender {
    [self.delegate replyWithTarget:self.tweet];
}

- (IBAction)onRetweet:(id)sender {
    if (!self.retweetButton.selected) {
        [self.delegate retweetWithTarget:self.tweet];
    } else {
        [self.delegate undoRetweetWithTarget:self.tweet];
    }
    [self updateCountersView];
}

- (IBAction)onFavorite:(id)sender {
    if (!self.favoriteButton.selected) {
        [self.delegate favoriteWithTarget:self.tweet];
    } else {
        [self.delegate unfavoriteWithTarget:self.tweet];
    }
    [self updateCountersView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
