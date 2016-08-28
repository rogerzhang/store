//
//  TDCountingViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/25/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDCountingViewController.h"
#import "TDCountScanViewController.h"
#import "TDCountChooseViewController.h"

@interface TDCountingViewController ()

@end

@implementation TDCountingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"盘 点";
    
    self.scanViewController = [[TDCountScanViewController alloc] initWithNibName: @"TDCountScanViewController" bundle: nil];
    self.chooseViewController = [[TDCountChooseViewController alloc] initWithNibName: @"TDCountChooseViewController" bundle: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
