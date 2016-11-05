//
//  TDScanView.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/15/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDScanView;

@protocol TDScanViewDelegate <NSObject>

- (void) scanAction: (TDScanView *)scanView;
- (void) okAction: (TDScanView *)scanView;

@end

@interface TDScanView : UIView<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (weak, nonatomic) NSObject<TDScanViewDelegate> *delegate;

@end
