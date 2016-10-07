//
//  TDBaseViewController.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/25/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDProductDetailViewController.h"

@interface TDBaseViewController : UIViewController<TDProductDetailViewControllerDelegate>

@property (strong, nonatomic) TDScanView *scanView;
@property (strong, nonatomic) TDItemsBar *itemsBar;
@property (strong, nonatomic) TDSaveBanner *saveBanner;
@property (nonatomic, strong) UIViewController *scanViewController;
@property (nonatomic, strong) UIViewController *chooseViewController;

- (void) chooseButtonSelectedChangeAction: (TDItemsBar *)itemsBar;
- (void) selectedScanViewController;
@end
