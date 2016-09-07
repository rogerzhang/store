//
//  TDSotreListTableViewController.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/6/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDSotreListTableViewController;

@protocol TDSotreListTableViewControllerDelegate <NSObject>

- (void)storeListViewController:(TDSotreListTableViewController *)storeViewController didSelectStore: (TDStore *)store;

@end

@interface TDSotreListTableViewController : UITableViewController
@property (nonatomic, weak) NSObject<TDSotreListTableViewControllerDelegate> *delegate;
@end