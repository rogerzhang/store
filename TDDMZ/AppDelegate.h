//
//  AppDelegate.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/1/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TDMainViewController *mainVC;
- (void) showProgressBar;
- (void) hideProgressBar;
@end

