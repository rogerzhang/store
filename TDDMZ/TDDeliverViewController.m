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
    self.chooseViewController = [[TDDeliverChooseViewController alloc] initWithNibName: @"TDDeliverChooseViewController" bundle: nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
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
    TDDeliverScanViewController *scanVC = (TDDeliverScanViewController *)self.scanViewController;
    
    TDStore *toStore = [scanVC toStore];
    
    if (toStore)
    {
        [[TDClient sharedInstance] deliverToStoreId: toStore.store_id goods:[self goodsInfoList] completionHandler:^(BOOL success, NSError *error, id userInfo){
            TD_LOG(@"%@",userInfo);
            
            [scanVC clean];
        }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择店名" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
