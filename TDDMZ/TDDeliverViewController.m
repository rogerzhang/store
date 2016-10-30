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
@property (nonatomic, strong) NSTimer *timer;
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
    TDDeliverChooseViewController *chooseViewController = [[TDDeliverChooseViewController alloc] initWithNibName: @"TDDeliverChooseViewController" bundle: nil];
    chooseViewController.delegate = self;
    self.chooseViewController = chooseViewController;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
}

- (UIBarButtonItem *)rightButtoItem;
{
    NSString *title = [NSString stringWithFormat:@"未审核%@", [TDClient sharedInstance].unreadCountOfDB];
    UIBarButtonItem *rightButtoItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    
    return rightButtoItem;
}

- (void) rightButtonAction;
{
    TDCheckDeliverViewController *checkDeliverVC = [[TDCheckDeliverViewController alloc] initWithNibName:@"TDCheckDeliverViewController" bundle:nil];
    [self.navigationController pushViewController:checkDeliverVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [self rightButtoItem];
}

- (void) updateLabel;
{
    self.saveBanner.value1Label.text = [self totaCount];
    self.saveBanner.value2Label.text = [NSString stringWithFormat:@"￥%@",[self totalMoney]];
}

- (NSString *)totalMoney;
{
    NSString *money = nil;
    TDDeliverScanViewController *scanVC = (TDDeliverScanViewController *)self.scanViewController;
    NSArray *goods = scanVC.datasource;
    
    NSInteger count = 0;
    for (TDGood *good in goods) {
        count += good.goods_number * [good.shop_price integerValue];
    }
    
    money = [NSString stringWithFormat:@"%ld",(long)count];
    
    return money;
}

- (NSString *)totaCount;
{
    NSString *money = nil;
    TDDeliverScanViewController *scanVC = (TDDeliverScanViewController *)self.scanViewController;
    NSArray *goods = scanVC.datasource;
    
    NSInteger count = 0;
    for (TDGood *good in goods) {
        count += good.goods_number;
    }
    
    money = [NSString stringWithFormat:@"%ld",(long)count];
    
    return money;
}

- (NSArray *)goodsInfoList;
{
    TDDeliverScanViewController *scanVC = (TDDeliverScanViewController *)self.scanViewController;
    NSArray *goods = scanVC.datasource;
    NSMutableArray *goodList = [NSMutableArray array];
    for (TDGood *good in goods) {
        NSDictionary *dic = [[TDParser sharedInstance] submitionDictionaryWithGood: good];
        [goodList addObject: dic];
    }
    return goodList;
}

- (void) saveActionWithSaveBanner: (TDSaveBanner *)banner;
{
    if ([self goodsInfoList].count < 1)
    {
        [self showMessage: @"请选择调拨商品"];
        return;
    }
    
    TDDeliverScanViewController *scanVC = (TDDeliverScanViewController *)self.scanViewController;
    
    TDStore *toStore = [scanVC toStore];
    
    if (toStore)
    {
        [[TDClient sharedInstance] deliverToStoreId: toStore.store_id goods:[self goodsInfoList] completionHandler:^(BOOL success, NSError *error, id userInfo){
            TD_LOG(@"%@",userInfo);
            
            if (success)
            {
                [self showMessage: @"调拨单保存成功"];
                [scanVC clean];
            }
            else
            {
                [self showMessage: error.description];
            }
        }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择店名" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void) showMessage: (NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
