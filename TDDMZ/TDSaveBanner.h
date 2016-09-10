//
//  TDSaveBanner.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/23/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDSaveBanner;

@protocol TDSaveBannerDelegate <NSObject>

- (void) saveActionWithSaveBanner: (TDSaveBanner *)banner;

@end

@interface TDSaveBanner : UIView

@property (weak, nonatomic) IBOutlet UILabel *key1Label;
@property (weak, nonatomic) IBOutlet UILabel *value1Label;
@property (weak, nonatomic) IBOutlet UILabel *key2Label;
@property (weak, nonatomic) IBOutlet UILabel *value2Label;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) NSObject<TDSaveBannerDelegate> *delegate;

- (void) showLabel: (BOOL)show;
@end
