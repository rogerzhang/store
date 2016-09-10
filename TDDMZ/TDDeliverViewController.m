//
//  TDDeliverViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/25/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDDeliverViewController.h"
#import "TDDeliverChooseViewController.h"
#import "TDDeliverScanViewController.h"

@interface TDDeliverViewController ()<TDSaveBannerDelegate>

@end

@implementation TDDeliverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"调 拨";
    [self.saveBanner showLabel: YES];
    self.saveBanner.key1Label.text = @"总件数：";
    self.saveBanner.key2Label.text = @"总金额：";
    self.saveBanner.value1Label.text = @"";
    self.saveBanner.value2Label.text = @"";
    self.saveBanner.delegate = self;
    self.scanViewController = [[TDDeliverScanViewController alloc] initWithNibName: @"TDDeliverScanViewController" bundle: nil];
    self.chooseViewController = [[TDDeliverChooseViewController alloc] initWithNibName: @"TDDeliverChooseViewController" bundle: nil];
}

- (UIBarButtonItem *)rightButtoItem;
{
    UIBarButtonItem *rightButtoItem = [[UIBarButtonItem alloc] initWithTitle:@"未审核" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    
    return rightButtoItem;
}

- (void) rightButtonAction;
{}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [self rightButtoItem];
}

- (void) saveActionWithSaveBanner: (TDSaveBanner *)banner;
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
