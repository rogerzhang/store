//
//  TDSearchScanViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/23/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDSearchScanViewController.h"

@interface TDSearchScanViewController ()

@end

@implementation TDSearchScanViewController

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

@end
