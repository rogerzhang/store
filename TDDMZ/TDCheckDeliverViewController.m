//
//  TDCheckDeliverViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 17/10/2016.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDCheckDeliverViewController.h"

@interface TDCheckDeliverViewController ()

@end

@implementation TDCheckDeliverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"调拨单审核";
    
    self.scanViewController = [[TDSearchDeliverViewController alloc] initWithNibName:@"TDUnCountingViewController" bundle:nil];
    self.chooseViewController = [[TDSearchDeliverViewController alloc] initWithNibName:@"TDUnCountingViewController" bundle:nil];
}

- (void) viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    
    [self.itemsBar.chooseGoodButton setTitle:@"调出单审核" forState:UIControlStateNormal];
    [self.itemsBar.chooseGoodButton setTitle:@"调出单审核" forState:UIControlStateSelected];
    [self.itemsBar.chooseGoodButton setTitle:@"调出单审核" forState:UIControlStateHighlighted];
    [self.itemsBar.chooseScanerButton setTitle:@"调入单审核" forState:UIControlStateNormal];
    [self.itemsBar.chooseScanerButton setTitle:@"调入单审核" forState:UIControlStateSelected];
    [self.itemsBar.chooseScanerButton setTitle:@"调入单审核" forState:UIControlStateHighlighted];
    
    self.saveBanner.hidden = YES;
    self.saveBanner = nil;
}

- (void) viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
