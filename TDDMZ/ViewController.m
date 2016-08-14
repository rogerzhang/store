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
    TDMainViewController *mv = [[TDMainViewController alloc] initWithNibName: @"TDMainViewController" bundle: nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mv];
    
    [self presentViewController: nav animated: YES completion: NULL];
}

- (IBAction) scanButtonTapped
{
    [[TDZbarReaderManager sharedInstance] startToScanBarcodeOnViewController: self withCompletionHandler: ^(BOOL success, id result){
        if (success)
        {
            NSLog(@"%@", result);
        }
    }];
}

@end
