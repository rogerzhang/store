//
//  TDBaseViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/25/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDBaseViewController.h"

@interface TDBaseViewController ()<TDItemsBarDelegate>

@end

@implementation TDBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itemsBar = [[TDItemsBar alloc] initWithFrame: CGRectZero];
    self.itemsBar.delegate = self;
    [self.view addSubview: self.itemsBar];
    
    self.saveBanner = [[[NSBundle mainBundle] loadNibNamed:@"TDSaveBanner" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.saveBanner];
    self.saveBanner.backgroundColor = RGBColor(247, 247, 247);
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem = [self backButton];
}

- (void) viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    CGRect frame = CGRectMake(0, 0, bounds.size.width, TDITEMBAR_HEIGHT);
    self.itemsBar.frame = frame;
    CGFloat height = TDBANNER_HEIGHT;
    frame = CGRectMake(0, bounds.size.height - height, bounds.size.width, height);
    self.saveBanner.frame = frame;
}

-(void) viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    [self.itemsBar setDefaultActionButton: self.itemsBar.chooseScanerButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

@end
