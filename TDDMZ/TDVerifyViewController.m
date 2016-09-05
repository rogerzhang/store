//
//  TDVerifyViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/17/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDVerifyViewController.h"

@interface TDVerifyViewController ()
@property (weak, nonatomic) IBOutlet TDScanView *scanView;

@end

@implementation TDVerifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"核 销";
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
    UIImage *image = [UIImage imageNamed:@"arrow"];
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
