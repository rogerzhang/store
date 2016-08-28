//
//  TDCountScanViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/27/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDCountScanViewController.h"

@interface TDCountScanViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TDScanView *scanView;
@property (nonatomic, strong) TDInfoView *infoView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDateFormatter *outputFormatter;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TDCountScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scanView = [[[NSBundle mainBundle] loadNibNamed:@"TDScanView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.scanView];
    
    self.infoView = [[[NSBundle mainBundle] loadNibNamed:@"TDInfoView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.infoView];
    self.infoView.dateLabel.text = [[TDHelper sharedInstance] dateFormatedString];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 10;
}

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TDCountPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CountPreviewCellIdentifier];

    cell.label1.text = [NSString stringWithFormat:@"%ld", [indexPath row]];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *header = [[[NSBundle mainBundle] loadNibNamed:@"TDCountHeader" owner:self options:nil] objectAtIndex:0];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 146;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 42;
}

@end
