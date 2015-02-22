//
//  TweetCell.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRTweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface DRTweetCell()

@property (weak, nonatomic) IBOutlet UIImageView *retweetIcon;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, assign) BOOL showRetweetedView;

@end

//static NSInteger const kMessageLabelOffset = 74;

@implementation DRTweetCell

- (void)awakeFromNib {
    // Initialization code

    self.messageLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.messageLabel.bounds);
    self.profileImageView.layer.cornerRadius = 8;
    self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(DRTweet *)rawTweet {
    _tweet = rawTweet;

    DRTweet *tweet = rawTweet;

    if ([rawTweet wasRetweeded]) {
        tweet = rawTweet.retweetSource;
        self.retweetedLabel.text = [NSString stringWithFormat:@"%@ retweeted", rawTweet.user.name];
    }
    self.retweetedLabel.hidden = ![rawTweet wasRetweeded];
    self.retweetIcon.hidden = ![rawTweet wasRetweeded];

    self.messageLabel.text = tweet.text;
    self.ownerNameLabel.text = tweet.user.name;
    self.ownerHandleLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];

    [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];

    self.timestampLabel.text = [tweet shortCreatedAt];

    [self setNeedsUpdateConstraints];
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

@end