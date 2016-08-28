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
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)loginAction:(id)sender
{
//    TDClient *client = [TDClient sharedInstance];
//    [client loginWithAccount: @"13606057867" password:@"123456" completionHandler:^(BOOL success, NSError *error){
//        if (success) {
//            TDMainViewController *mv = [[TDMainViewController alloc] initWithNibName: @"TDMainViewController" bundle: nil];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mv];
//            
//            [self presentViewController: nav animated: YES completion: NULL];
//        }
//        else
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"登录失败" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//    }];
    
    TDMainViewController *mv = [[TDMainViewController alloc] initWithNibName: @"TDMainViewController" bundle: nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mv];
    
    [self presentViewController: nav animated: YES completion: NULL];
}

@end
