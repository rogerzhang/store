//
//  TDDeliverScanViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/25/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDDeliverScanViewController.h"

@interface TDDeliverScanViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) TDScanView *scanView;
@property (nonatomic, strong) TDOptionsBanner *optionBanner;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TDDeliverScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scanView = [[[NSBundle mainBundle] loadNibNamed:@"TDScanView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.scanView];
    
    self.optionBanner = [[[NSBundle mainBundle] loadNibNamed:@"TDOptionsBanner" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.optionBanner];
    self.optionBanner.timeLabel.text = [[TDHelper sharedInstance] dateFormatedString];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(updateTimeLabelText) userInfo:nil repeats:YES];
    
    UINib *cellNib = [UINib nibWithNibName:@"TDProductPreviewTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:PreviewCellIdentifier];
}

- (void) updateTimeLabelText;
{
    self.optionBanner.timeLabel.text = [[TDHelper sharedInstance] dateFormatedString];
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    self.optionBanner.frame = CGRectMake(0, 0, bounds.size.width, TDOPTIONSBANNER_HEIGHT);
    self.scanView.frame = CGRectMake(0, TDOPTIONSBANNER_HEIGHT, bounds.size.width, TDSCANVIEW_HEIGHT);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.scanView.frame), bounds.size.width, bounds.size.height - CGRectGetMaxY(self.scanView.frame));
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
    TDProductPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: PreviewCellIdentifier];
    
    UIImage *image = [UIImage imageNamed:@"test"];
    cell.previewImageView.image = image;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 146;
}

@end
