//
//  TDMainViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/14/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDMainViewController.h"
#import "TDSearchGoodViewController.h"
#import "TDVerifyViewController.h"
#import "TDCountingViewController.h"
#import "TDDeliverViewController.h"
#import "TDOrderCollectionViewController.h"
#import "TDGetOrderCollectionViewController.h"

@interface TDMainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *currentStoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *getListButton;

@property (nonatomic, strong) TDSearchGoodViewController *searchGoodViewController;
@property (nonatomic, strong) TDVerifyViewController *verifyViewController;
@property (nonatomic, strong) TDCountingViewController *countingViewController;
@property (nonatomic, strong) TDDeliverViewController *deliverViewController;
@property (nonatomic, strong) TDOrderCollectionViewController *orderViewController;
@property (nonatomic, strong) TDGetOrderCollectionViewController *getOrderViewController;

@end

@implementation TDMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    self.searchGoodViewController = [[TDSearchGoodViewController alloc] initWithNibName:@"TDSearchGoodViewController" bundle:nil];
    self.verifyViewController = [[TDVerifyViewController alloc] initWithNibName: @"TDVerifyViewController" bundle: nil];
    self.countingViewController = [[TDCountingViewController alloc] initWithNibName: @"TDCountingViewController" bundle: nil];
    self.deliverViewController = [[TDDeliverViewController alloc] initWithNibName: @"TDDeliverViewController" bundle: nil];
    
    TDOrderLayout *flowLayout = [[TDOrderLayout alloc] init];
    self.orderViewController = [[TDOrderCollectionViewController alloc] initWithCollectionViewLayout: flowLayout];
    self.getOrderViewController = [[TDGetOrderCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    self.currentStoreLabel.text = [NSString stringWithFormat:@"当前店铺：%@", [TDClient sharedInstance].storeName];
    self.userNameLabel.text = [NSString stringWithFormat:@"收银员：%@", [TDClient sharedInstance].userName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)logoutAction:(id)sender
{
    [[TDClient sharedInstance] logoutWithCompletionHandler: ^(BOOL success, NSError *error){
        [self dismissViewControllerAnimated: YES completion: NULL];
    }];
}

- (IBAction)getListAction:(id)sender
{
    [self.navigationController pushViewController: self.getOrderViewController animated: YES];
}

- (IBAction)scanAction:(id)sender
{
    [[TDZbarReaderManager sharedInstance] startToScanBarcodeOnViewController: self withCompletionHandler: ^(BOOL success, id result){
        if (success)
        {
            NSLog(@"%@", result);
        }
    }];
}

- (IBAction)orderConfirmAction:(id)sender
{
    [self.navigationController pushViewController: self.orderViewController animated: YES];
}

- (IBAction)searchGoods:(id)sender
{
    [self.navigationController pushViewController: self.searchGoodViewController animated: YES];
}

- (IBAction)deliverGoodAction:(id)sender
{
    [self.navigationController pushViewController: self.deliverViewController animated: YES];
}

- (IBAction)coutingAction:(id)sender
{
    [self.navigationController pushViewController: self.countingViewController animated: YES];
}

- (IBAction)verifyAction:(id)sender
{
    [self.navigationController pushViewController: self.verifyViewController animated: YES];
}

@end
