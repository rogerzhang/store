//
//  TDSearchScanViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/23/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDSearchScanViewController.h"
#import "TDSearchGoodsTableViewCell.h"
#define HeaderIdentifier @"header"
@interface TDSearchScanViewController ()

@end

@implementation TDSearchScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scanView = [[[NSBundle mainBundle] loadNibNamed:@"TDScanView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.scanView];
    self.scanView.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"TDSearchGoodsTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:PreviewCellIdentifier];
    [self.tableView registerClass:[TDSearchGoodHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifier];
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    self.scanView.frame = CGRectMake(0, 0, bounds.size.width, TDSCANVIEW_HEIGHT);
    
    self.tableView.frame = CGRectMake(0, TDSCANVIEW_HEIGHT, bounds.size.width, bounds.size.height);
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    if (self.datasource.count)
    {
        TDSearchGoodHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
        
        headerView.backgroundColor = [UIColor redColor];
        
        if (!headerView)
        {
            headerView = [[TDSearchGoodHeaderView alloc] initWithReuseIdentifier: HeaderIdentifier];
        }
        
        NSDictionary *dic = self.datasource[0];
        NSArray *attrs = dic[@"attr2_name"];
        [headerView setAttributes:attrs];
        
        return headerView;
    }
    else
    {
        return nil;
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

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TDSearchGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: PreviewCellIdentifier];
    NSDictionary *dic = self.datasource[indexPath.row];
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    cell.storeNameLabel.text = dic[@"store"];
    cell.attr1Label.text = dic[@"attr1"];
    [cell setAttributes:dic[@"attr2"] keys: dic[@"attr2_name"]];
    return cell;
}

- (void) searchGoodsWithBarId: (NSString *)barId;
{
    [[TDClient sharedInstance] searchgoodsWithBarcode:barId orGoodsId:nil orGoodattrId:nil withCompletionHandler:^(BOOL success, NSError *error, id userInfo){
        if (success)
        {
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:userInfo];
            [self.tableView reloadData];
        }
    }];
}

- (void) addGoods: (TDGood *)good;
{
    [self searchGoodWithId: good.goods_id];
}

- (void) searchGoodWithId: (NSString *)goodId;
{
    [[TDClient sharedInstance] searchgoodsWithBarcode:nil orGoodsId:goodId orGoodattrId:nil withCompletionHandler:^(BOOL success, NSError *error, id userInfo){
        if (success)
        {
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:userInfo];
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
