//
//  TDDateViewController.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 10/5/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TDDatePickerChangeHandler) (NSDate *date);
@interface TDDateViewController : UIViewController
@property (nonatomic, copy) TDDatePickerChangeHandler changeHandler;
@end
