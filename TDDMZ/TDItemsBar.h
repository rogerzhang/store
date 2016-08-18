//
//  TDItemsBar.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/18/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDItemsBar;
@protocol TDItemsBarDelegate <NSObject>

- (void) chooseGoodButtonAction: (TDItemsBar *)itemsBar;
- (void) chooseScanerButtonAction: (TDItemsBar *)itemsBar;

@end
@interface TDItemsBar : UIView
@property (nonatomic, strong) UIButton *chooseGoodButton;
@property (nonatomic, strong) UIButton *chooseScanerButton;
@property (nonatomic, weak) NSObject<TDItemsBarDelegate> *delegate;
@end
