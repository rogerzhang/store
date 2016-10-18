//
//  TDUnCountingViewController.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 10/5/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDUnCountingViewController : UIViewController
@property(nonatomic, copy) NSArray *datasource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *status;

- (IBAction)searchAction:(id)sender;
- (NSArray *)attrs;
- (void) showErrorMessage: (NSString *)message title: (NSString *)title;
@end
