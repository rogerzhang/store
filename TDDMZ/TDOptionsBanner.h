//
//  TDOptionsBanner.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/25/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDOptionsBanner;
@protocol TDOptionsBannerDelegate <NSObject>

- (void) getStoreListAction:(TDOptionsBanner *)banner;

@end

@interface TDOptionsBanner : UIView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseStoreButton;
@property (weak, nonatomic) IBOutlet UILabel *receiverName;
@property (weak, nonatomic) NSObject<TDOptionsBannerDelegate> *delegate;

@end
