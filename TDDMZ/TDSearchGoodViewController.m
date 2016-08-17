//
//  TDSearchGoodViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/15/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDSearchGoodViewController.h"

@interface TDSearchGoodViewController ()
@property (weak, nonatomic) IBOutlet TDScanView *scanView;

@end

@implementation TDSearchGoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    CGRect frame = self.scanView.frame;
    self.scanView = [[[NSBundle mainBundle] loadNibNamed:@"TDScanView" owner:self options:nil] objectAtIndex:0];
    self.scanView.frame = frame;
    [self.view addSubview: self.scanView];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

    self.navigationItem.leftBarButtonItem = [self backButton];
}

- (UIBarButtonItem *)backButton;
{
    UIImage *image = [UIImage imageNamed:@"Arrows-Back-icon"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage: image style: UIBarButtonItemStylePlain target: self action: @selector(backAction)];
    
    return backButton;
}

- (void) backAction
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
