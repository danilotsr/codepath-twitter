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
#import "DRSessionManager.h"

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
            [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
        } else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Unable to login"
                                                                             message:error.localizedDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
            [alertVC addAction:alertAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }];
}

@end
