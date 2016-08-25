//
//  TDDeliverScanViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/25/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDDeliverScanViewController.h"

@interface TDDeliverScanViewController ()
@property (nonatomic, strong) TDScanView *scanView;
@property (nonatomic, strong) TDOptionsBanner *optionBanner;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDateFormatter *outputFormatter;
@end

@implementation TDDeliverScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.outputFormatter = [[NSDateFormatter alloc] init];
    self.scanView = [[[NSBundle mainBundle] loadNibNamed:@"TDScanView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.scanView];
    
    self.optionBanner = [[[NSBundle mainBundle] loadNibNamed:@"TDOptionsBanner" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.optionBanner];
    self.optionBanner.timeLabel.text = [self dataString];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(updateTimeLabelText) userInfo:nil repeats:YES];
}

- (void) updateTimeLabelText;
{
    self.optionBanner.timeLabel.text = [self dataString];
}

- (NSString *) dataString;
{
    NSDate *date = [NSDate date];
    [self.outputFormatter setLocale:[NSLocale currentLocale]];
    [self.outputFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *str = [self.outputFormatter stringFromDate:date];
    return str;
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    self.optionBanner.frame = CGRectMake(0, 0, bounds.size.width, TDOPTIONSBANNER_HEIGHT);
    self.scanView.frame = CGRectMake(0, TDOPTIONSBANNER_HEIGHT, bounds.size.width, TDSCANVIEW_HEIGHT);
    
//    self.tableView.frame = CGRectMake(0, TDSCANVIEW_HEIGHT, bounds.size.width, bounds.size.height - TDSCANVIEW_HEIGHT);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
