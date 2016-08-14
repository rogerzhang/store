//
//  TDMainViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/14/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDMainViewController.h"

@interface TDMainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentStoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *getListButton;

@end

@implementation TDMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutAction:(id)sender {
}
- (IBAction)getListAction:(id)sender {
}
- (IBAction)scanAction:(id)sender {
}
- (IBAction)orderConfirmAction:(id)sender {
}
- (IBAction)searchGoods:(id)sender {
}
- (IBAction)deliverGoodAction:(id)sender {
}
- (IBAction)coutingAction:(id)sender {
}
- (IBAction)verifyAction:(id)sender {
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
