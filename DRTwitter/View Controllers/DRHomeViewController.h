//
//  DRHomeViewController.h
//  DRTwitter
//
//  Created by Danilo Resende on 3/1/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRNavigationDelegate.h"

@interface DRHomeViewController : UIViewController

@property (weak, nonatomic) id<DRNavigationDelegate> navigationDelegate;

@end
