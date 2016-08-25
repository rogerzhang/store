//
//  TDSearchGoodViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/15/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDSearchGoodViewController.h"
#import "TDSearchScanViewController.h"
#import "TDSearchChooseViewController.h"

@interface TDSearchGoodViewController ()

@end

@implementation TDSearchGoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"查 货";
    self.navigationController.navigationBar.hidden = NO;
    
    self.scanViewController = [[TDSearchScanViewController alloc] initWithNibName: @"TDSearchScanViewController" bundle: nil];
    self.chooseViewController = [[TDSearchChooseViewController alloc] initWithNibName: @"TDSearchChooseViewController" bundle: nil];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
