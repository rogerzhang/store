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


- (UIBarButtonItem *)rightButtoItem;
{
    UIBarButtonItem *rightButtoItem = [[UIBarButtonItem alloc] initWithTitle:@"未审核" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    
    return rightButtoItem;
}

- (void) rightButtonAction;
{
    TDUnCountingViewController *unCountingVC = [[TDUnCountingViewController alloc] initWithNibName:@"TDUnCountingViewController" bundle:nil];
    [self.navigationController pushViewController:unCountingVC animated: YES];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [self rightButtoItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
