//
//  TDSearchDeliverViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 17/10/2016.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDSearchDeliverViewController.h"
#import "TDSearchDeliverTableViewCell.h"
#import "TDDBDetailViewController.h"

static NSString * const cellIdentifer = @"searchdevlivercell";
static NSString * const headerdentifer = @"searchdevliverheader";

@interface TDSearchDeliverViewController ()<TDSearchDeliverTableViewCellDelegate>

@end

@implementation TDSearchDeliverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"TDSearchDeliverTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellIdentifer];
    
    [self refreshPendingOrders];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)searchAction:(id)sender;
{
    [super searchAction:sender];
    
    NSString *type = self.isDeliverOut ? @"1" : @"2";
    [[TDClient sharedInstance] searchdborderFormDate:self.beginDate to:self.endDate type:type status:self.status withCompletionHandler:^(BOOL success, NSError *error, id userInfo){
        if (success)
        {
            self.datasource = userInfo;
            
            [self.tableView reloadData];
        }
        else
        {
            [self showErrorMessage:error.description title:nil];
        }
    }];
}

- (NSArray *)attrs;
{
    NSArray *array = nil;
    
    if (self.isDeliverOut)
    {
        array = @[@"单号", @"调入仓库", @"数量合计", @"调拨总额", @"开单日期", @"开单人员", @"操作"];
    }
    else
    {
        array = @[@"单号", @"调出仓库", @"数量合计", @"调拨总额", @"开单日期", @"开单人员", @"操作"];
    }
    return array;
}

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TDSearchDeliverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifer];
    
    NSDictionary *dict = self.datasource[indexPath.row];
    
    cell.label0.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    cell.label1.text = dict[@"order_code"];
    cell.label2.text = dict[@"towarehouse"];
    
    id count = dict[@"goods_count"];
    
    if ([count isKindOfClass:[NSNumber class]])
    {
        cell.label3.text = [count stringValue];
    }
    else
    {
        cell.label3.text = [NSString stringWithString:dict[@"goods_count"]];
    }
    NSNumber *money = dict[@"order_money"];
    cell.label4.text = [money stringValue];
    cell.label5.text = dict[@"order_date"];
    cell.label6.text = dict[@"create_user"];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *dic = self.datasource[indexPath.row];
    TDDBDetailViewController *detailVC = [[TDDBDetailViewController alloc] init];
    detailVC.isDeliverOut = self.isDeliverOut;
    detailVC.orderId = dic[@"order_id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)button1Action:(TDSearchDeliverTableViewCell *)cell;
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确定审核" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *unverifiedAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        NSDictionary *dic = self.datasource[indexPath.row];
        
        NSString *orderId = dic[@"order_id"];
        [[TDClient sharedInstance] checkdborderWithId:orderId completionHandler:^(BOOL success, NSError *error, id userInfo){
            if (success) {
                [self showErrorMessage:@"审核成功" title:nil];
            }
            else
            {
                [self showErrorMessage:error.description title:nil];
            }
            
            [self refreshPendingOrders];
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

- (void)button2Action:(TDSearchDeliverTableViewCell *)cell;
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确定作废" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *unverifiedAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        NSDictionary *dic = self.datasource[indexPath.row];
        
        NSString *orderId = dic[@"order_id"];
        
        [[TDClient sharedInstance] canceldborderbillWithId:orderId completionHandler:^(BOOL success, NSError *error, id userInfo){
            if (success)
            {
                [self showErrorMessage:@"操作成功" title:nil];
                
                [self refreshPendingOrders];
            }
            else
            {
                [self showErrorMessage:error.description title:nil];
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

- (void) refreshPendingOrders;
{
    if (self.isDeliverOut)
    {
        [[TDClient sharedInstance] getPendingdborderWithCompletionHandler:^(BOOL success, NSError *error, id userInfo){
            if (success)
            {
                self.datasource = userInfo;
                
                [self.tableView reloadData];
            }
            else
            {
                [self showErrorMessage:error.description title:nil];
            }
        }];
    }
    else
    {
        [[TDClient sharedInstance] getPendingrkorderWithCompletionHandler:^(BOOL success, NSError *error, id userInfo){
            if (success)
            {
                self.datasource = userInfo;
                
                [self.tableView reloadData];
            }
            else
            {
                [self showErrorMessage:error.description title:nil];
            }
        }];
    }
}

@end
