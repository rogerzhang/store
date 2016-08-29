//
//  TDCashierScanViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/29/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDCashierScanViewController.h"

@interface TDCashierScanViewController ()<TDScanViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TDScanView *scanView;
@end

@implementation TDCashierScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scanView = [[[NSBundle mainBundle] loadNibNamed:@"TDScanView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.scanView];
    self.scanView.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"TDProductPreviewTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:PreviewCellIdentifier];
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    self.scanView.frame = CGRectMake(0, 0, bounds.size.width, TDSCANVIEW_HEIGHT);
    
    self.tableView.frame = CGRectMake(0, TDSCANVIEW_HEIGHT, bounds.size.width, bounds.size.height - TDSCANVIEW_HEIGHT);
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

- (void) scanAction: (TDScanView *)scanView;
{}

- (void) okAction: (TDScanView *)scanView;
{
    [[TDClient sharedInstance] getGoodInfo:@"45348271" withCompletionHandler:^(BOOL success, NSError *error, id userInfo){
        if (userInfo) {
            //
        }
    }];
}
@end
