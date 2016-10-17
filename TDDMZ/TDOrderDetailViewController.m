//
//  TDOrderDetailViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 17/10/2016.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDOrderDetailViewController.h"
#import "TDOrderHeaderView.h"

static NSString * const cellIdentifer = @"cell";
static NSString * const headerdentifer = @"orderheader";
@interface TDOrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TDOrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"TDOrderDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellIdentifer];
    [self.tableView registerClass:[TDOrderHeaderView class] forHeaderFooterViewReuseIdentifier:headerdentifer];
}

- (void) viewDidLayoutSubviews;
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
    
    [self refresh];
}

- (void) refresh;
{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.datasource.count;
}

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TDOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifer];
    
    NSDictionary *dict = self.datasource[indexPath.row];
    
    cell.label1.text = dict[@"goods_sn"];
    cell.label2.text = dict[@"goods_name"];
    cell.label3.text = dict[@"goods_attr"];
    cell.label4.text = dict[@"shop_price"];
    cell.label5.text = dict[@"goods_number"];
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    {
        TDOrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerdentifer];
        
        headerView.backgroundColor = [UIColor redColor];
        
        if (!headerView)
        {
            headerView = [[TDOrderHeaderView alloc] initWithReuseIdentifier: headerdentifer];
        }
        
        NSArray *attrs = @[@"商品编码", @"商品名称", @"规格", @"单价", @"数量"];
        [headerView setAttributes:attrs];
        
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 44;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
