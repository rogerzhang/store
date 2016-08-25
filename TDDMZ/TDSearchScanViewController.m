//
//  TDSearchScanViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/23/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDSearchScanViewController.h"

@interface TDSearchScanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TDScanView *scanView;

@end

@implementation TDSearchScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scanView = [[[NSBundle mainBundle] loadNibNamed:@"TDScanView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.scanView];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return nil;
}

@end
