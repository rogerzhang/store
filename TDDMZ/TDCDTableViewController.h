//
//  TDCDTableViewController.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 18/10/2016.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDCDTableViewController : UITableViewController
@property (nonnull, nonatomic, strong) NSString *orderId;
@property (nullable,nonatomic, copy) NSArray *dataSource;
- (nonnull NSArray *)attrs;
@end
