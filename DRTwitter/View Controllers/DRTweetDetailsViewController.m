//
//  DRTweetDetailsViewController.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/22/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRTweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DRTweetDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *retweetedIcon;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;

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

    DRTweet *originalTweet = self.tweet;

    if ([self.tweet wasRetweeded]) {
        originalTweet = self.tweet.retweetSource;
        self.retweetedLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.user.name];
    }
    self.retweetedLabel.hidden = ![self.tweet wasRetweeded];
    self.retweetedIcon.hidden = ![self.tweet wasRetweeded];

    self.messageLabel.text = originalTweet.text;
    self.nameLabel.text = originalTweet.user.name;
    self.userNameLabel.text = [NSString stringWithFormat:@"@%@", originalTweet.user.screenName];

    [self.profileImageView setImageWithURL:[NSURL URLWithString:originalTweet.user.profileImageURL]];

    self.retweetsLabel.text = [NSString stringWithFormat:@"%d", originalTweet.retweetsCount];
    self.favoritesLabel.text = [NSString stringWithFormat:@"%d", originalTweet.favoritesCount];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.timestampLabel.text = [dateFormatter stringFromDate:originalTweet.createdAt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
