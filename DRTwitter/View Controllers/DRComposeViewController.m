//
//  DRComposeViewController.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/21/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRComposeViewController.h"
#import "DRSessionManager.h"
#import "UIImageView+AFNetworking.h"
#import "DRTwitterClient.h"

NSInteger const kMaxTextLength = 140;

@interface DRComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) UIBarButtonItem *tweetButton;
@property (nonatomic, strong) UIBarButtonItem *counterBarButton;

@property (nonatomic, strong) DRTweet *replyTarget;

@end

@implementation DRComposeViewController

- (id)initWithReplyTarget:(DRTweet *)replyTarget {
    self  = [super init];
    if (self) {
        self.replyTarget = replyTarget;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self
                                             action:@selector(onCancel)];

    self.tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet"
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(onTweet)];

    self.counterBarButton = [[UIBarButtonItem alloc] init];
    self.counterBarButton.enabled = NO;

    self.navigationItem.rightBarButtonItems = @[self.tweetButton, self.counterBarButton];

    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraints:@[leftConstraint, rightConstraint]];

    DRUser *currentUser = [DRSessionManager currentUser];

    self.nameLabel.text = currentUser.name;
    self.userNameLabel.text = [NSString stringWithFormat:@"@%@", currentUser.screenName];

    self.profileImageView.layer.cornerRadius = 8;
    self.profileImageView.clipsToBounds = YES;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:currentUser.profileImageURL]];

    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
    if (self.replyTarget && [self.replyTarget wasRetweeded]) {
        self.textView.text = [NSString stringWithFormat:@"@%@ @%@ ",
                              self.replyTarget.retweetSource.user.screenName,
                              self.replyTarget.user.screenName];
    } else if (self.replyTarget) {
        self.textView.text = [NSString stringWithFormat:@"@%@ ", self.replyTarget.user.screenName];
    } else {
        self.textView.text = [DRSessionManager pendingTweetMessage];
    }
    [self.textView sizeToFit];

    [self updateAppearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancel {
    [self savePendingTweet];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweet {
    [DRSessionManager setPendingTweetMessage:nil];

    [[DRTwitterClient sharedInstance]
     postStatusWithMessage:self.textView.text
     replyTarget:self.replyTarget
     completion:^(DRTweet *tweet, NSError *error) {
         if (tweet) {
             [self.delegate composeViewController:self didPostTweet:tweet];
         } else {
             NSLog(@"Error on tweeting: %@", error);
         }
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateAppearance];
    [self savePendingTweet];
}

- (void)savePendingTweet {
    [DRSessionManager setPendingTweetMessage:self.textView.text];
}

- (NSInteger)getRemainingSize {
    return kMaxTextLength - self.textView.text.length;
}

- (void)updateAppearance {
    self.tweetButton.enabled = self.textView.text.length > 0;

    if ([self getRemainingSize] <= 0) {
        self.textView.text = [self.textView.text substringToIndex:kMaxTextLength];
    }

    [UIView performWithoutAnimation:^{
        self.counterBarButton.title = [NSString stringWithFormat:@"%d", [self getRemainingSize]];
    }];
}

@end
