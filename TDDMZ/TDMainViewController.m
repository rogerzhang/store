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

@interface TDMainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentStoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *getListButton;

@property (nonatomic, strong) TDSearchGoodViewController *searchGoodViewController;
@property (nonatomic, strong) TDVerifyViewController *verifyViewController;

@end

@implementation TDMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    self.searchGoodViewController = [[TDSearchGoodViewController alloc] initWithNibName:@"TDSearchGoodViewController" bundle:nil];
    self.verifyViewController = [[TDVerifyViewController alloc] initWithNibName: @"TDVerifyViewController" bundle: nil];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)logoutAction:(id)sender
{
}

- (IBAction)getListAction:(id)sender
{
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
}

- (IBAction)searchGoods:(id)sender
{
    [self.navigationController pushViewController: self.searchGoodViewController animated: YES];
}

- (IBAction)deliverGoodAction:(id)sender {
}

- (IBAction)coutingAction:(id)sender {
}

- (IBAction)verifyAction:(id)sender
{
    [self.navigationController pushViewController: self.verifyViewController animated: YES];
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
