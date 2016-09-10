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
    self.datasource = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    cell.typeLabel.text = good.goods_name;
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
    goodId = @"45348271";
    [self searchGoodWithId:goodId];
}

- (void)searchGoodWithId: (NSString *)goodId;
{
    if (goodId && goodId.length)
    {
        [[TDClient sharedInstance] getGoodInfo:goodId withCompletionHandler:^(BOOL success, NSError *error, id userInfo){
            if (userInfo) {
                TDGood *good = [[TDParser sharedInstance] goodWithDictionary:userInfo];
                [self.datasource addObject:good];
                [self.tableView reloadData];
            }
        }];
    }
}
@end
