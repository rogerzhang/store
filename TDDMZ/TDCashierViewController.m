//
//  TDCashierViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/29/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDCashierViewController.h"
#import "TDCashierScanViewController.h"
#import "TDCashierChooseViewController.h"

@interface TDCashierViewController ()

@end

@implementation TDCashierViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"收银";
    self.navigationController.navigationBar.hidden = NO;
    
    self.cashierBanner = [[[NSBundle mainBundle] loadNibNamed:@"TDCashierBanner" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.cashierBanner];
    self.cashierBanner.backgroundColor = RGBColor(247, 247, 247);

    self.scanViewController = [[TDCashierScanViewController alloc] initWithNibName: @"TDCashierScanViewController" bundle: nil];
    self.chooseViewController = [[TDCashierChooseViewController alloc] initWithNibName: @"TDCashierChooseViewController" bundle: nil];
}

- (void) viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    
//    CGRect bounds = self.view.bounds;
    
//    CGRect frame = CGRectMake(0, 0, bounds.size.width, TDITEMBAR_HEIGHT);
//    self.itemsBar.frame = frame;
//    CGFloat height = TDBANNER_HEIGHT;
//    frame = CGRectMake(0, bounds.size.height - height, bounds.size.width, height);
//    self.saveBanner.frame = frame;
    
    self.cashierBanner.frame = self.saveBanner.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
