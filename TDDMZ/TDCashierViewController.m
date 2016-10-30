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
#import "TDGetOrderCollectionViewController.h"

@interface TDCashierViewController ()<TDCashierBannerDelegate>
@property (nonatomic, strong) TDSettlementViewController *settlementViewController;
@property (nonatomic, strong) TDCustomerSettlementViewController *customerSettlementViewController;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *datasouce;
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
    TDCashierChooseViewController *chooseVC = [[TDCashierChooseViewController alloc] initWithNibName: @"TDCashierChooseViewController" bundle: nil];
    self.settlementViewController = [[TDSettlementViewController alloc] initWithNibName:@"TDSettlementViewController" bundle:nil];
    self.customerSettlementViewController = [[TDCustomerSettlementViewController alloc] initWithNibName:@"TDCustomerSettlementViewController" bundle:nil];
    chooseVC.delegate = self;
    self.chooseViewController = chooseVC;
    
    if (self.datasouce) {
        TDCashierScanViewController *scanVC = (TDCashierScanViewController *)self.scanViewController;
        NSMutableArray *data = [NSMutableArray arrayWithArray:self.datasouce];
        [scanVC setDatasource:data];
    }

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
}

- (UIBarButtonItem *)rightButtoItem;
{
    NSString *title = [NSString stringWithFormat:@"挂单提取"];
    UIBarButtonItem *rightButtoItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    
    return rightButtoItem;
}

- (void) rightButtonAction;
{
    TDOrderLayout *flowLayout = [[TDOrderLayout alloc] init];
    TDGetOrderCollectionViewController *vc = [[TDGetOrderCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    [self.navigationController pushViewController:vc animated: YES];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [self rightButtoItem];
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

- (void) setDatasource: (NSArray *)datasource;
{
    _datasouce = datasource;
    [self refresh];
}

- (void) refresh;
{
    TDCashierScanViewController *scanVC = (TDCashierScanViewController *)self.scanViewController;
    NSMutableArray *data = [NSMutableArray arrayWithArray:_datasouce];
    [scanVC setDatasource:data];
    [scanVC.tableView reloadData];
}

- (void) updateLabel;
{
    self.cashierBanner.label.text = [NSString stringWithFormat:@"总金额: ￥%@",[self totalMoney]];
}

- (NSInteger) goodsCount;
{
    TDCashierScanViewController *scanVC = (TDCashierScanViewController *)self.scanViewController;
    NSArray *goods = scanVC.datasource;
    
    NSInteger count = 0;
    for (TDGood *good in goods)
    {
        count += good.goods_number;
    }
    return count;
}

- (void) holdListAction:(TDCashierBanner *)cashierBanner;
{
    if ([self goodsCount] < 1) {
        [self showMessage:@"请选择商品"];
        return;
    }
    
    TDCashierScanViewController *scanVC = (TDCashierScanViewController *)self.scanViewController;
    NSArray *goods = scanVC.datasource;
    
    NSInteger count = 0;
    for (TDGood *good in goods)
    {
        count += good.goods_number;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSDate *date = [NSDate date];
    [dict setObject:date forKey:@"time"];
    [dict setObject:@(count) forKey:@"count"];
    [dict setObject:[self totalMoney] forKey:@"money"];
    [dict setObject:[goods copy] forKey:@"goods"];
    
    [[TDClient sharedInstance] addOrder:dict];
    
    [self showMessage: @"挂单成功！"];
    
    [scanVC clean];
}

- (void) showMessage: (NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void) chooseButtonSelectedChangeAction: (TDItemsBar *)itemsBar;
{
    [super chooseButtonSelectedChangeAction: itemsBar];
    
    self.cashierBanner.hidden = itemsBar.chooseGoodButton.isSelected;
    self.saveBanner.hidden = itemsBar.chooseGoodButton.isSelected;
}

- (void) customerSettlementAction:(TDCashierBanner *)cashierBanner;
{
    if ([self goodsCount] < 1) {
        [self showMessage:@"请选择商品"];
        return;
    }
    
    [[TDClient sharedInstance] submitorderGoods: [self goodsInfoList] orderMoney: [self totalMoney] withCompletionHandler:^(BOOL success, NSError *error, id userInfo){
        TD_LOG(@"%@", userInfo);
        
        if (success)
        {
            NSString *qrcode = userInfo[@"qrcode"];
            NSString *orderId = userInfo[@"order_id"];
            
            [self checkOrderId: orderId];

            //TDCashierScanViewController *scanVC = (TDCashierScanViewController *)self.scanViewController;
            self.customerSettlementViewController.urlString = qrcode;
            self.customerSettlementViewController.orderId = orderId;
            //[scanVC clean];
            [self.navigationController pushViewController:self.customerSettlementViewController animated:YES];
        }
        else
        {
            [self showMessage:error.description];
        }
    }];
}

- (void) checkOrderId: (NSString *)orderId;
{
    [[TDClient sharedInstance] lspaystatus:orderId withCompletionHandler:^(BOOL success, NSError *error, id userInfo){
        if (success)
        {
            if ([userInfo isEqualToString:@"0"]) {
                [self checkOrderId:orderId];
            }
            else
            {
                [self showMessage:@"支付成功！"];
            }
        }
        else
        {
            [self showMessage:@"网络错误"];
        }
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
    
    money = [NSString stringWithFormat:@"%ld",(long)count];
    
    return money;
}

- (NSArray *)goodsInfoList;
{
    TDCashierScanViewController *scanVC = (TDCashierScanViewController *)self.scanViewController;
    NSArray *goods = scanVC.datasource;
    NSMutableArray *goodList = [NSMutableArray array];
    for (TDGood *good in goods) {
        if (!good.goods_attr) {
            good.goods_attr = @"";
        }
        if (!good.goodattr_id) {
            good.goodattr_id = @"";
        }
        NSDictionary *dic = [[TDParser sharedInstance] submitionDictionaryWithGood: good];
        [goodList addObject: dic];
    }
    return goodList;
}

- (void) userSettlementAction:(TDCashierBanner *)cashierBanner;
{
    if ([self goodsCount] < 1) {
        [self showMessage:@"请选择商品"];
        return;
    }
    
    self.settlementViewController.totalMoney = [self totalMoney];
    self.settlementViewController.goodList = [self goodsInfoList];
    
    //TDCashierScanViewController *scanVC = (TDCashierScanViewController *)self.scanViewController;
    //[scanVC clean];
    
    [self.navigationController pushViewController:self.settlementViewController animated:YES];
}

- (void) saveActionWithDetailViewController: (TDProductDetailViewController *)detailViewController;
{
    [super saveActionWithDetailViewController: detailViewController];
}

- (void) dealloc;
{
    [self.timer invalidate];
}

@end
