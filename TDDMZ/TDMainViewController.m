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
#import "TDCashierViewController.h"

@interface TDMainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *currentStoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *getListButton;
@property (weak, nonatomic) IBOutlet UILabel *orderCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliverCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pdCountLabel;

@property (nonatomic, strong) TDSearchGoodViewController *searchGoodViewController;
@property (nonatomic, strong) TDVerifyViewController *verifyViewController;
@property (nonatomic, strong) TDCountingViewController *countingViewController;
@property (nonatomic, strong) TDDeliverViewController *deliverViewController;
@property (nonatomic, strong) TDOrderCollectionViewController *orderViewController;
@property (nonatomic, strong) TDGetOrderCollectionViewController *getOrderViewController;
@property (nonatomic, strong) TDCashierViewController *cashierViewController;

@end

@implementation TDMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.orderCountLabel.text = nil;
    self.deliverCountLabel.text = nil;
    self.pdCountLabel.text = nil;
    
    self.cashierViewController = [[TDCashierViewController alloc] initWithNibName: @"TDCashierViewController" bundle: nil];
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
    
    [self refreshUnreadCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) refreshUnreadCount;
{
    TDClient *client = [TDClient sharedInstance];
    
    [client getIndexNumWithCompletionHandler:^(BOOL success, NSError *error, id userInfo){
        if (userInfo) {
            NSDictionary *result = userInfo;
            
            client.unreadCountOfOrder = [[result objectForKey:@"order"] integerValue] ? [[result objectForKey:@"order"] stringValue] : nil;
            self.orderCountLabel.text = client.unreadCountOfOrder;
            
            client.unreadCountOfDB = [[result objectForKey:@"db"] integerValue] ? [[result objectForKey:@"db"] stringValue] : nil;
            self.deliverCountLabel.text = client.unreadCountOfDB;
            
            client.unreadCountOfPD = [[result objectForKey:@"pd"] integerValue] ? [[result objectForKey:@"pd"] stringValue] : nil;
            self.pdCountLabel.text = client.unreadCountOfPD;
        }
    }];
}

- (IBAction)logoutAction:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确定退出" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *unverifiedAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [[TDClient sharedInstance] logoutWithCompletionHandler: ^(BOOL success, NSError *error, id userInfo){
            [self dismissViewControllerAnimated: YES completion: NULL];
        }];
        [alertController dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    UIAlertAction *verifiedAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        [alertController dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    [alertController addAction:unverifiedAction];
    [alertController addAction:verifiedAction];
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (IBAction)getListAction:(id)sender
{
    [self.navigationController pushViewController: self.getOrderViewController animated: YES];
}

- (IBAction)scanAction:(id)sender
{
    [self.navigationController pushViewController: self.cashierViewController animated: YES];
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
