//
//  TDDBDetailViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 23/10/2016.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDDBDetailViewController.h"

@interface TDDBDetailViewController ()

@end

@implementation TDDBDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isDeliverOut)
    {
        [[TDClient sharedInstance] getDborderinfoWithId:self.orderId withCompletionHander:^(BOOL success, NSError *error, id userInfo){
            self.dataSource = userInfo;
            [self.tableView reloadData];
        }];
    }
    else
    {
        [[TDClient sharedInstance] getRkorderinfoWithId:self.orderId withCompletionHander:^(BOOL success, NSError *error, id userInfo){
            self.dataSource = userInfo;
            [self.tableView reloadData];
        }];
    }
}

- (NSArray *)attrs;
{
    return @[@"商品编码", @"商品名称", @"尺寸范围", @"单价", @"数量",@"调拨价",@"调拨金额"];
}

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TDCDTableViewCell *cell = (TDCDTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.label0.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.label1.text = dict[@"goods_sn"];
    cell.label2.text = dict[@"goods_name"];
    cell.label3.text = dict[@"goods_attr"];
    cell.label4.text = [dict[@"goods_pice"] stringValue];
    cell.label5.text = [dict[@"goods_number"] stringValue];
    cell.label6.text = [dict[@"goods_pice"] stringValue];
    cell.label7.text = [dict[@"goods_total"] stringValue];
    cell.label8.text = dict[@"good_type"];
    cell.label9.text = dict[@"good_type"];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
