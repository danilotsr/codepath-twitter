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
    DRTweet *tweet = rawTweet;

    if ([rawTweet wasRetweeded]) {
        tweet = rawTweet.retweetSource;
        self.retweetedLabel.text = [NSString stringWithFormat:@"%@ retweeted", rawTweet.user.name];
    }
    self.retweetedLabel.hidden = ![rawTweet wasRetweeded];
    self.retweetIcon.hidden = ![rawTweet wasRetweeded];
    // FIXME: remove extra empty space when tweet was not retweeded

    self.messageLabel.text = tweet.text;
    self.ownerNameLabel.text = tweet.user.name;
    self.ownerHandleLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];

    [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];

    self.timestampLabel.text = [tweet shortCreatedAt];
}

//- (void)updateConstraints {
//    [super updateConstraints];
//
//    if (self.retweetedView) {
//        UIImageView __weak *profileImageView = self.profileImageView;
//        UIView __weak *retweetedView = self.retweetedView;
//        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(profileImageView, retweetedView);
//        NSMutableArray *constraints = [NSMutableArray array];
//        NSArray *visualConstraints = @[@"|-8-[retweetedView]-8-|", @"V:|-8-[retweetedView]", @"V:[retweetedView]-8-[profileImageView]"];
//        for (NSString *visualConstraint in visualConstraints) {
//            [constraints addObjectsFromArray: [NSLayoutConstraint
//                                               constraintsWithVisualFormat:visualConstraint
//                                               options:0
//                                               metrics:nil
//                                               views:viewsDict]];
//        }
//        [self addConstraints:constraints];
//    }
//    [self layoutIfNeeded];
//}

@end