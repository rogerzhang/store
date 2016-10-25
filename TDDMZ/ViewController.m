//
//  ViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/1/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "ViewController.h"
#import "TDMainViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *psTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;
@end

@implementation ViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.registerLabel.hidden = YES;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)loginAction:(id)sender
{
    NSString *account = [self.userTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.psTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    password = @"123456";
    account = @"13606057867";
    if (!account || account.length < 1) {
        [self showMessage: @"请输入账号"];
        return;
    }
    
    if (!password || password.length < 1) {
        [self showMessage: @"请输入密码"];
        return;
    }
    
    //13606057867 123456
    TDClient *client = [TDClient sharedInstance];
    [client loginWithAccount: account password:password completionHandler:^(BOOL success, NSError *error, id userInfo){
        if (success) {
            TDMainViewController *mv = [[TDMainViewController alloc] initWithNibName: @"TDMainViewController" bundle: nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mv];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.mainVC = mv;
            [self presentViewController: nav animated: YES completion: NULL];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"登录失败" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

- (void) showMessage: (NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
