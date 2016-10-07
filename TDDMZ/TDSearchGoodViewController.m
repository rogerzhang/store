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
    TDSearchChooseViewController *chooseViewController = [[TDSearchChooseViewController alloc] initWithNibName: @"TDSearchChooseViewController" bundle: nil];
    chooseViewController.delegate = self;
    self.chooseViewController = chooseViewController;
    
    self.saveBanner.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
