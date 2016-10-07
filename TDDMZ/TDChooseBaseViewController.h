//
//  TDChooseBaseViewController.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/5/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDProductDetailViewController.h"

@interface TDChooseBaseViewController : UIViewController
@property (nonatomic, weak) NSObject<TDProductDetailViewControllerDelegate> *delegate;
@end
