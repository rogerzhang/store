//
//  TDCashierBanner.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/23/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDCashierBanner;
@protocol TDCashierBannerDelegate <NSObject>

- (void) holdListAction:(TDCashierBanner *)cashierBanner;
- (void) customerSettlementAction:(TDCashierBanner *)cashierBanner;
- (void) userSettlementAction:(TDCashierBanner *)cashierBanner;

@end
@interface TDCashierBanner : UIView
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *gdButton;
@property (weak, nonatomic) IBOutlet UIButton *jsButton;
@property (weak, nonatomic) IBOutlet UIButton *dsButton;
@property (weak, nonatomic) NSObject<TDCashierBannerDelegate> *delegate;
@end
