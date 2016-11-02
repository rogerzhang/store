//
//  TDMainViewController.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/14/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDCashierViewController.h"

@interface TDMainViewController : UIViewController
@property (nonatomic, strong) TDCashierViewController *cashierViewController;
- (void) refreshUnreadCount;
@end
