//
//  TDScanBaseViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/2/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDScanBaseViewController.h"

@interface TDScanBaseViewController ()

@end

@implementation TDScanBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.datasource) {
        self.datasource = [NSMutableArray array];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) clean;
{
    [self.datasource removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark-<UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.datasource.count;
}

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TDProductPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: PreviewCellIdentifier];
    
    TDGood *good = self.datasource[indexPath.row];
    NSString *name = [NSString stringWithFormat:@"名称：%@", good.goods_name];
    NSString *type = [NSString stringWithFormat:@"编码：%@", good.goods_sn];
    NSString *attr = [NSString stringWithFormat:@"规格：%@", good.goods_attr];
    NSString *price = [NSString stringWithFormat:@"单价：￥%@", good.shop_price];
    
    cell.count = good.goods_number;
    cell.nameLabel.text = name;
    cell.typeLabel.text = type;
    cell.sizeLabel.text = attr;
    cell.priceLabel.text = price;
    cell.delegate = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL* aURL = [NSURL URLWithString: good.goods_img];
        NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.previewImageView.image = image;
        });
    });
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 146;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *) tableView: (UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath: (NSIndexPath *)indexPath;
{
    return @" 删除 ";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.datasource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
    }
}

- (void) scanAction: (TDScanView *)scanView;
{
    [[TDZbarReaderManager sharedInstance] startToScanBarcodeOnViewController: self withCompletionHandler: ^(BOOL success, id result){
        if (success)
        {
            TD_LOG(@"%@", result);
            NSString *goodId = result;
            [self searchGoodWithId:goodId];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }];
}

- (void) countDidChanged: (TDProductPreviewTableViewCell *)cell;
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TDGood *good = self.datasource[indexPath.row];
    good.goods_number = cell.count;
}

- (void) okAction: (TDScanView *)scanView;
{
    NSString *goodId = [self.scanView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //goodId = @"100118000003";
    if (!goodId || goodId.length < 1) {
        [self showMessage: @"请输入商品条码"];
    }
    [self searchGoodsWithBarId: goodId];
    self.scanView.textView.text = nil;
}

- (void) showMessage: (NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void) searchGoodsWithBarId: (NSString *)barId;
{
    [self searchGoodWithId:barId];
}

- (void)searchGoodWithId: (NSString *)goodId;
{
    if (goodId && goodId.length)
    {
        [[TDClient sharedInstance] getGoodInfo:goodId withCompletionHandler:^(BOOL success, NSError *error, id userInfo){
            if (userInfo) {
                TDGood *good = [[TDParser sharedInstance] goodWithDictionary:userInfo];
                good.goods_number = 1;//default
                [self addGoods: good];
            }
        }];
    }
}

- (void) addGoods: (TDGood *)good;
{
    BOOL isExist = NO;
    
    for (TDGood *goods in self.datasource)
    {
        if ([goods isEqualGoods:good])
        {
            goods.goods_number += good.goods_number;
            
            isExist = YES;
        }
    }
    
    if (!isExist)
    {
        [self.datasource addObject:good];
    }
    
    [self.tableView reloadData];
}

- (void) removeGoods: (TDGood *)good;
{
    [self.datasource addObject:good];
    [self.tableView reloadData];
}

@end
