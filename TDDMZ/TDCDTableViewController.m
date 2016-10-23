//
//  TDCDTableViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 18/10/2016.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDCDTableViewController.h"
#import "TDCDHeader.h"
#import "TDCDTableViewCell.h"

static NSString * const cellIdentifer = @"CDcell";
static NSString * const headerdentifer = @"CDheader";

@interface TDCDTableViewController ()

@end

@implementation TDCDTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    UINib *cellNib = [UINib nibWithNibName:@"TDCDTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellIdentifer];
    [self.tableView registerClass:[TDCDHeader class] forHeaderFooterViewReuseIdentifier:headerdentifer];
    [self refreshData];
}

- (void) refreshData;
{
    [[TDClient sharedInstance] getRkorderinfoWithId:self.orderId withCompletionHander:^(BOOL success, NSError *error, id userInfo){
        self.dataSource = userInfo;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSArray *)attrs;
{
    return @[@"商品编码", @"商品名称", @"规格", @"单位", @"系统数量", @"盘到数量", @"盈亏数量", @"单价", @"金额"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataSource.count;
}

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TDCDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifer];
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.label0.text = [NSString stringWithFormat:@"%ld",(indexPath.row + 1)];
    cell.label1.text = dict[@"goods_sn"];
    cell.label2.text = dict[@"goods_name"];
    cell.label3.text = dict[@"goods_attr"];
    cell.label4.text = dict[@"good_type"];
    cell.label5.text = [dict[@"system_count"] stringValue];
    cell.label6.text = [dict[@"goods_count"] stringValue];
    cell.label7.text = [dict[@"difference"] stringValue];
    cell.label8.text = dict[@"goods_pice"];
    cell.label9.text = dict[@"goods_total"];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    TDCDHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerdentifer];
    
    if (!headerView)
    {
        headerView = [[TDCDHeader alloc] initWithReuseIdentifier: headerdentifer];
    }
    
    NSArray *attrs = [self attrs];
    [headerView setAttributes:attrs];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 44;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
