//
//  TDCountScanViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/27/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDCountScanViewController.h"

@interface TDCountScanViewController ()<UITableViewDelegate, UITableViewDataSource,TDScanViewDelegate>

@property (nonatomic, strong) TDInfoView *infoView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDateFormatter *outputFormatter;
@end

@implementation TDCountScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scanView = [[[NSBundle mainBundle] loadNibNamed:@"TDScanView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.scanView];
    self.scanView.delegate = self;
    
    self.infoView = [[[NSBundle mainBundle] loadNibNamed:@"TDInfoView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.infoView];
    self.infoView.dateLabel.text = [[TDHelper sharedInstance] dateFormatedString];
    self.infoView.nameLabel.text = [TDClient sharedInstance].storeName;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(updateTimeLabelText) userInfo:nil repeats:YES];
    UINib *cellNib = [UINib nibWithNibName:@"TDCountPreviewTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CountPreviewCellIdentifier];
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    self.infoView.frame = CGRectMake(0, TDSCANVIEW_HEIGHT, bounds.size.width, TDOPTIONSBANNER_HEIGHT);
    self.scanView.frame = CGRectMake(0, 0, bounds.size.width, TDSCANVIEW_HEIGHT);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame), bounds.size.width, bounds.size.height - CGRectGetMaxY(self.infoView.frame));
}

- (void) updateTimeLabelText;
{
    self.infoView.dateLabel.text = [[TDHelper sharedInstance] dateFormatedString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark-<UITableViewDelegate, UITableViewDataSource>

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TDCountPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CountPreviewCellIdentifier];

    cell.backgroundColor = [indexPath row] % 2 ? [UIColor whiteColor] : RGBColor(235, 235, 235);
    
    TDGood *good = self.datasource[indexPath.row];
    cell.label2.text = good.goods_name;
    cell.label1.text = [NSString stringWithFormat:@"%ld", (long)[indexPath row]];
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *header = [[[NSBundle mainBundle] loadNibNamed:@"TDCountHeader" owner:self options:nil] objectAtIndex:0];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 42;
}

@end
