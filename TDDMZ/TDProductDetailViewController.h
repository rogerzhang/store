//
//  TDProductDetailViewController.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 10/5/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDProductDetailViewController;

@protocol TDProductDetailViewControllerDelegate <NSObject>

- (void) saveActionWithDetailViewController: (TDProductDetailViewController *)detailViewController;
- (void) choseGood: (TDGood *)good;

@end

@interface TDProductDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imagView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) TDGood *goods;
@property (strong, nonatomic) TDSaveBanner *saveBanner;
@property (weak, nonatomic) NSObject<TDProductDetailViewControllerDelegate> *delegate;

@end
