//
//  TweetCell.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRTweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "DRTwitterClient.h"
#import "DRComposeViewController.h"

@interface DRTweetCell()

@property (weak, nonatomic) IBOutlet UIImageView *retweetIcon;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong, readonly) DRTweet *originalTweet;

@property (nonatomic, assign) BOOL showRetweetedView;

@end

@implementation DRTweetCell

- (void)awakeFromNib {
    // Initialization code

    self.profileImageView.layer.cornerRadius = 8;
    self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (DRTweet *)originalTweet {
    return [self.tweet wasRetweeded] ? self.tweet.retweetSource : self.tweet;
}

- (void)setTweet:(DRTweet *)tweet {
    _tweet = tweet;

    if ([self.tweet wasRetweeded]) {
        self.retweetedLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.user.name];
    }
    self.retweetedLabel.hidden = ![self.tweet wasRetweeded];
    self.retweetIcon.hidden = ![self.tweet wasRetweeded];


    self.textView.text = nil;
    self.textView.attributedText = [self.originalTweet textWithEntities];
    self.textView.textContainerInset = UIEdgeInsetsZero;
    self.textView.contentInset = UIEdgeInsetsMake(0, -4, 0, 0);

    self.ownerHandleLabel.text = [NSString stringWithFormat:@"@%@", self.originalTweet.user.screenName];

    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.originalTweet.user.profileImageURL]];

    self.timestampLabel.text = [self.originalTweet shortCreatedAt];

    [self updateActionBar];
    [self setNeedsUpdateConstraints];
}

- (void)updateActionBar {
    self.retweetButton.selected = self.originalTweet.retweeted;
    self.favoriteButton.selected = self.originalTweet.favorited;
}

NSInteger const kTopMarginRetweeted = 8;
NSInteger const kTopMarginRegularTweet = -14;

- (void)updateConstraints {
    [super updateConstraints];

    NSLayoutConstraint *constraint = [self findConstraintForRetweetedHeader];
    constraint.constant = [self.tweet wasRetweeded] ? kTopMarginRetweeted : kTopMarginRegularTweet;
}

- (NSLayoutConstraint *)findConstraintForRetweetedHeader {
    NSArray *constraints = self.contentView.constraints;
    for (NSLayoutConstraint *constraint in constraints) {
        if ([self.profileImageView isEqual:constraint.firstItem] &&
            [self.retweetIcon isEqual:constraint.secondItem]) {
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
    [self updateActionBar];
}

- (IBAction)onFavorite:(id)sender {
    if (!self.favoriteButton.selected) {
        [self.delegate favoriteWithTarget:self.tweet];
    } else {
        [self.delegate unfavoriteWithTarget:self.tweet];
    }
    [self updateActionBar];
}

- (IBAction)onTapMessage:(id)sender {
    NSLog(@"onTapMessage: %@", sender);
}

@end