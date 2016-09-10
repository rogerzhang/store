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
#import "TDCustomerSettlementViewController.h"

@interface TDCashierViewController ()<TDCashierBannerDelegate>
@property (nonatomic, strong) TDSettlementViewController *settlementViewController;
@property (nonatomic, strong) TDCustomerSettlementViewController *customerSettlementViewController;
@property (nonatomic, strong) NSTimer *timer;
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
    self.customerSettlementViewController = [[TDCustomerSettlementViewController alloc] initWithNibName:@"TDCustomerSettlementViewController" bundle:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
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

- (void) updateLabel;
{
    self.cashierBanner.label.text = [NSString stringWithFormat:@"总金额: ￥%@",[self totalMoney]];
}

- (void) holdListAction:(TDCashierBanner *)cashierBanner;
{}

- (void) customerSettlementAction:(TDCashierBanner *)cashierBanner;
{
    [[TDClient sharedInstance] submitorderGoods: [self goodsInfoList] orderMoney: [self totalMoney] withCompletionHandler:^(BOOL success, NSError *error, id userInfo){
        TD_LOG(@"%@", userInfo);
        TDCashierScanViewController *scanVC = (TDCashierScanViewController *)self.scanViewController;
        [scanVC clean];
        [self.navigationController pushViewController:self.customerSettlementViewController animated:YES];
    }];
}

- (NSString *)totalMoney;
{
    NSString *money = nil;
    TDCashierScanViewController *scanVC = (TDCashierScanViewController *)self.scanViewController;
    NSArray *goods = scanVC.datasource;
    
    NSInteger count = 0;
    for (TDGood *good in goods) {
        count += good.goods_number * [good.shop_price integerValue];
    }
    
    money = [NSString stringWithFormat:@"%ld",count];
    
    return money;
}

- (NSArray *)goodsInfoList;
{
    TDCashierScanViewController *scanVC = (TDCashierScanViewController *)self.scanViewController;
    NSArray *goods = scanVC.datasource;
    NSMutableArray *goodList = [NSMutableArray array];
    for (TDGood *good in goods) {
        NSDictionary *dic = [[TDParser sharedInstance] submitionDictionaryWithGood: good];
        [goodList addObject: dic];
    }
    return goodList;
}

- (void) userSettlementAction:(TDCashierBanner *)cashierBanner;
{    
    self.settlementViewController.totalMoney = [self totalMoney];
    self.settlementViewController.goodList = [self goodsInfoList];
    
    TDCashierScanViewController *scanVC = (TDCashierScanViewController *)self.scanViewController;
    [scanVC clean];
    
    [self.navigationController pushViewController:self.settlementViewController animated:YES];
}

- (void) dealloc;
{
    [self.timer invalidate];
}

@end
