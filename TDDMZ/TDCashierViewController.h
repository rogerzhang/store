//
//  TDCashierViewController.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/29/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDCashierViewController : TDBaseViewController
@property (nonatomic, strong) TDCashierBanner *cashierBanner;

- (void) setDatasource: (NSArray *)datasource;

@end
