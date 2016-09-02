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
#import "TDSettlementViewController.h"

@interface TDCashierViewController ()<TDCashierBannerDelegate>
@property (nonatomic, strong) TDSettlementViewController *settlementViewController;
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
    self.cashierBanner.delegate = self;

    self.scanViewController = [[TDCashierScanViewController alloc] initWithNibName: @"TDCashierScanViewController" bundle: nil];
    self.chooseViewController = [[TDCashierChooseViewController alloc] initWithNibName: @"TDCashierChooseViewController" bundle: nil];
    self.settlementViewController = [[TDSettlementViewController alloc] initWithNibName:@"TDSettlementViewController" bundle:nil];
}

- (void) viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    
    self.cashierBanner.frame = self.saveBanner.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) holdListAction:(TDCashierBanner *)cashierBanner;
{}

- (void) customerSettlementAction:(TDCashierBanner *)cashierBanner;
{
    [self.navigationController pushViewController:self.settlementViewController animated:YES];
}

- (void) userSettlementAction:(TDCashierBanner *)cashierBanner;
{
    [self.navigationController pushViewController:self.settlementViewController animated:YES];
}

@end
