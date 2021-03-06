//
//  TDOrderCollectionViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/28/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDOrderCollectionViewController.h"
#import "TDOrderDetailViewController.h"

@interface TDOrderCollectionViewController ()<TDOrderCollectionViewCellDeleagate>
@property (nonatomic, strong) NSArray *datasource;
@end

@implementation TDOrderCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"订单确认";
    
    UINib *nib = [UINib nibWithNibName: @"TDOrderCollectionViewCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = [self backButton];
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self refresh];
}

- (void) refresh;
{
    [[TDClient sharedInstance] getUncheckorderlistWithCompletionHandler: ^(BOOL success, NSError *error, id userInfo){
        if (success) {
            TD_LOG(@"%@", userInfo);
            self.datasource = userInfo;
            [self.collectionView reloadData];
        }
        else
        {
            [self showMessage: error.description];
        }
    }];
}

- (void) showMessage: (NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (UIBarButtonItem *)backButton;
{
    UIImage *image = [UIImage imageNamed:@"arrow"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage: image style: UIBarButtonItemStylePlain target: self action: @selector(backAction)];
    
    return backButton;
}

- (void) backAction
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGSize) collectionView: (UICollectionView *)collectionView
                   layout: (UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath: (NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake (300, 300);
    
    return size;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TDOrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.delegate = self;
    
    cell.label1.text = [NSString stringWithFormat:@"%ld", (long)[indexPath row]];
    
    NSDictionary *dic = self.datasource[indexPath.row];
    
    NSString *date = dic[@"order_date"];
    NSString *orderId = dic[@"order_code"];
    NSString *money = dic[@"order_money"];
    NSString *count = dic[@"order_number"];
    NSString *nickname = dic[@"nickname"];
    NSString *status = [dic[@"pay_status"] stringValue];
    
    cell.label1.text = [NSString stringWithFormat:@"日期：%@", date];
    cell.label2.text = [NSString stringWithFormat:@"订单号：%@", orderId];
    cell.label3.text = [NSString stringWithFormat:@"金额：%@", money];
    cell.label4.text = [NSString stringWithFormat:@"件数：%@", count];
    cell.label5.text = [NSString stringWithFormat:@"昵称：%@", nickname];
    
    NSString *ss = nil;
    UIImage *image = nil;
    NSString *title = nil;
    
    if ([status isEqualToString:@"0"])
    {
        ss = @"未付款";
        cell.button2.enabled = YES;
        cell.button2.hidden = NO;
        image = [UIImage imageNamed:@"订单确认2"];
        title = @"订单取消";
    }
    else if ([status isEqualToString:@"1"])
    {
        cell.button2.enabled = YES;
        image = [UIImage imageNamed:@"订单确认2"];
        ss = @"已付款";
        title = @"订单确认";
    }
    else if ([status isEqualToString:@"2"])
    {
        cell.button2.enabled = NO;
        image = [UIImage imageNamed:@"订单已确认状态"];
        ss = @"已确认";
        title = @"订单已确认";
    }
    else if ([status isEqualToString:@"3"])
    {
        cell.button2.enabled = NO;
        image = [UIImage imageNamed:@"订单已取消状态"];
        ss = @"已取消";
        title = @"订单已取消";
    }
    
    [cell.button2 setBackgroundImage:image forState:UIControlStateNormal];
    [cell.button2 setBackgroundImage:image forState:UIControlStateDisabled];
    [cell.button2 setTitle:title forState:UIControlStateNormal];
    [cell.button2 setTitle:title forState:UIControlStateDisabled];
    
    cell.label6.text = [NSString stringWithFormat:@"状态：%@", ss];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{}

- (void) orderDetailAction: (TDOrderCollectionViewCell*)cell;
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell: cell];
    TD_LOG(@"indexPath is %ld", (long)[indexPath row]);
    
    NSDictionary *dic = self.datasource[indexPath.row];
    NSString *orderId = dic[@"order_id"];
    
    [[TDClient sharedInstance] getOrderDetailWithOrderId:orderId completionHandler:^(BOOL success, NSError *error, id userInfo){
        if (success) {
            TD_LOG(@"%@", userInfo);
            
            TDOrderDetailViewController *detailVC = [[TDOrderDetailViewController alloc] initWithNibName:@"TDOrderDetailViewController" bundle:nil];
            detailVC.datasource = (NSArray *)userInfo;
            [self.navigationController pushViewController:detailVC animated: YES];
        }
        else
        {
            [self showMessage:error.description];
        }
    }];
}

- (void) orderOKAction: (TDOrderCollectionViewCell*)cell;
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell: cell];
    NSDictionary *dic = self.datasource[indexPath.row];
    NSString *orderId = dic[@"order_id"];
    NSString *status = [dic[@"pay_status"] stringValue];
    
    if ([status isEqualToString:@"0"])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确定退出" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *unverifiedAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            [[TDClient sharedInstance] checkorderWithId:orderId status:status completionHandler:^(BOOL success, NSError *error, id userInfo){
                if (success)
                {
                    [self showMessage:@"操作成功"];
                    [self refresh];
                }
                else
                {
                    [self showMessage:error.description];
                }
            }];
            
            [alertController dismissViewControllerAnimated:YES completion:NULL];
        }];
        
        UIAlertAction *verifiedAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            [alertController dismissViewControllerAnimated:YES completion:NULL];
        }];
        
        [alertController addAction:unverifiedAction];
        [alertController addAction:verifiedAction];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
    else
    {
        [[TDClient sharedInstance] checkorderWithId:orderId status:status completionHandler:^(BOOL success, NSError *error, id userInfo){
            if (success)
            {
                [self showMessage:@"操作成功"];
                [self refresh];
            }
            else
            {
                [self showMessage:error.description];
            }
        }];
    }
    
    TD_LOG(@"indexPath is %ld", (long)[indexPath row]);
}

@end
