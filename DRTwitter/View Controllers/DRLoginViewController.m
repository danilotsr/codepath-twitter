//
//  DRLoginViewController.m
//  DRTwitter
//
//  Created by Danilo Resende on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import "DRLoginViewController.h"
#import "DRTwitterClient.h"
#import "DRTweetsViewController.h"

NSString * const kTwitterAuthorizeURL = @"https://api.twitter.com/oauth/authorize";

@interface DRLoginViewController ()

@end

@implementation DRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginWithTwitter:(id)sender {
    [[DRTwitterClient sharedInstance] loginWithCompletion:^(DRUser *user, NSError *error) {
        if (user) {
            DRTweetsViewController *tweetsVC = [[DRTweetsViewController alloc] initWithUser:user];
            UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:tweetsVC];
            [self.navigationController presentViewController:navigationVC animated:YES completion:nil];
        } else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Unable to login"
                                                                             message:error.localizedDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
            [alertVC addAction:alertAction];
            [self.navigationController presentViewController:alertVC animated:YES completion:nil];
        }
    }];
}

@end
