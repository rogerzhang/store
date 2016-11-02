//
//  TDCustomerSettlementViewController.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/6/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDCashierScanViewController.h"

@interface TDCustomerSettlementViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, weak) TDCashierScanViewController *scanVC;
@end
