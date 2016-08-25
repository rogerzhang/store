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

@interface TDDeliverViewController ()

@end

@implementation TDDeliverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"调 拨";
    
    self.scanViewController = [[TDDeliverScanViewController alloc] initWithNibName: @"TDDeliverScanViewController" bundle: nil];
    self.chooseViewController = [[TDDeliverChooseViewController alloc] initWithNibName: @"TDDeliverChooseViewController" bundle: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
