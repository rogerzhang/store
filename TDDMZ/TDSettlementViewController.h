//
//  TDSettlementViewController.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/2/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDCashierScanViewController.h"

@interface TDSettlementViewController : UIViewController
@property (nonatomic, strong) NSString *totalMoney;
@property (nonatomic, strong) NSArray *goodList;
@property (nonatomic, weak) TDCashierScanViewController *scanVC;
@end
