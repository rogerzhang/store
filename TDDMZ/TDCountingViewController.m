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

@interface TDCountingViewController ()<TDSaveBannerDelegate>
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TDCountingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"盘 点";
    
    self.scanViewController = [[TDCountScanViewController alloc] initWithNibName: @"TDCountScanViewController" bundle: nil];
    TDCountChooseViewController *chooseViewController = [[TDCountChooseViewController alloc] initWithNibName: @"TDCountChooseViewController" bundle: nil];
    chooseViewController.delegate = self;
    self.chooseViewController = chooseViewController;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    self.saveBanner.key1Label.text = @"总件数：";
    self.saveBanner.key2Label.text = @"总金额：";
    self.saveBanner.value1Label.text = @"";
    self.saveBanner.value2Label.text = @"";
    self.saveBanner.delegate = self;
}


- (UIBarButtonItem *)rightButtoItem;
{
    NSString *title = [NSString stringWithFormat:@"未审核%@", [TDClient sharedInstance].unreadCountOfPD ? [TDClient sharedInstance].unreadCountOfPD : @""];
    UIBarButtonItem *rightButtoItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    
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
    
    [self refreshNavigationItems];
}

- (void) refreshNavigationItems;
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.mainVC refreshUnreadCount];
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
    TDCountScanViewController *scanVC = (TDCountScanViewController *)self.scanViewController;
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
    TDCountScanViewController *scanVC = (TDCountScanViewController *)self.scanViewController;
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
    TDCountScanViewController *scanVC = (TDCountScanViewController *)self.scanViewController;
    NSArray *goods = scanVC.datasource;
    NSMutableArray *goodList = [NSMutableArray array];
    
    for (TDGood *good in goods) {
       // NSDictionary *dic = [[TDParser sharedInstance] submitionDictionaryWithGood: good];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"" forKey:@"barcode"];
        [dict setValue:good.goods_id forKey:@"goods_id"];
        [dict setValue:good.goods_attr forKey:@"attr_id1"];
        [dict setValue:good.goods_attr forKey:@"attr_id2"];
        [dict setValue:@(good.goods_number) forKey:@"number"];
        [dict setValue:good.kucun forKey:@"kucun"];
        
        [goodList addObject: dict];
    }
    return goodList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) saveActionWithSaveBanner: (TDSaveBanner *)banner;
{
    if ([self goodsInfoList].count < 1)
    {
        [self showMessage: @"请选择盘点商品"];
        return;
    }
    
    TDCountScanViewController *scanVC = (TDCountScanViewController *)self.scanViewController;
    
    [[TDClient sharedInstance] addPdorderWithListData: [self goodsInfoList] completionHandler:^(BOOL success, NSError *error, id userInfo){
        TD_LOG(@"%@",userInfo);
        
        if (success)
        {
            [self showMessage: @"保存成功"];
            [scanVC clean];
            
            [self refreshNavigationItems];
        }
        else
        {
            [self showMessage: error.description];
        }
    }];
}

- (void) showMessage: (NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
