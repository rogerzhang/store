//
//  TDSearchGoodViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/15/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDSearchGoodViewController.h"
#import "TDSearchScanViewController.h"
#import "TDSearchChooseViewController.h"

@interface TDSearchGoodViewController ()<TDItemsBarDelegate>
@property (weak, nonatomic) IBOutlet TDScanView *scanView;
@property (strong, nonatomic) TDItemsBar *itemsBar;
@property (strong, nonatomic) TDSaveBanner *saveBanner;
@property (nonatomic, strong) TDSearchScanViewController *scanViewController;
@property (nonatomic, strong) TDSearchChooseViewController *chooseViewController;

@end

@implementation TDSearchGoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds = self.view.bounds;
    self.title = @"查 货";
    self.navigationController.navigationBar.hidden = NO;
    
    CGRect frame = CGRectMake(0, 0, bounds.size.width, TDITEMBAR_HEIGHT);
    self.itemsBar = [[TDItemsBar alloc] initWithFrame: frame];
    self.itemsBar.delegate = self;
    [self.view addSubview: self.itemsBar];
    
    self.saveBanner = [[[NSBundle mainBundle] loadNibNamed:@"TDSaveBanner" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.saveBanner];
    self.saveBanner.backgroundColor = [UIColor grayColor];
    
    self.scanViewController = [[TDSearchScanViewController alloc] initWithNibName: @"TDSearchScanViewController" bundle: nil];
    self.chooseViewController = [[TDSearchChooseViewController alloc] initWithNibName: @"TDSearchChooseViewController" bundle: nil];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = [self backButton];
}

- (void) viewDidLayoutSubviews;
{
    [super viewDidLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    CGFloat height = TDBANNER_HEIGHT;
    CGRect frame = CGRectMake(0, bounds.size.height - height, bounds.size.width, height);
    self.saveBanner.frame = frame;
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

#pragma mark-

- (void) chooseGoodButtonAction: (TDItemsBar *)itemsBar;
{
    [self.scanViewController removeFromParentViewController];
    [self.scanViewController.view removeFromSuperview];
    [self.scanViewController didMoveToParentViewController: nil];
    
    [self addChildViewController: self.chooseViewController];
    self.chooseViewController.view.frame = [self subViewRect];
    [self.view addSubview: self.chooseViewController.view];
    [self.chooseViewController didMoveToParentViewController: self];
}

- (void) chooseScanerButtonAction: (TDItemsBar *)itemsBar;
{
    [self.chooseViewController removeFromParentViewController];
    [self.chooseViewController.view removeFromSuperview];
    [self.chooseViewController didMoveToParentViewController: nil];
    
    [self addChildViewController: self.scanViewController];
    self.scanViewController.view.frame = [self subViewRect];
    [self.view addSubview: self.scanViewController.view];
    [self.scanViewController didMoveToParentViewController: self];
}

- (CGRect) subViewRect;
{
    CGRect frame = self.view.frame;
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.itemsBar.frame);
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height - y - CGRectGetHeight(self.saveBanner.frame);
    return CGRectMake(x, y, w, h);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
