//
//  TDScanBaseViewController.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/2/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDScanBaseViewController : UIViewController<TDScanViewDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TDScanView *scanView;
@property (nonatomic, strong) NSMutableArray *datasource;
@end
