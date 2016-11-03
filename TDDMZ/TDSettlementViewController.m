//
//  TDSettlementViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/2/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDSettlementViewController.h"

@interface TDSettlementViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;

@end

@implementation TDSettlementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"确认结算";
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.leftBarButtonItem = [self backButton];
}

- (void) viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    [self resign];
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

- (void) showMessage: (NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if (textField == self.textField1) {
        self.textField2.text = nil;
    }
    else
    {
        self.textField1.text = nil;
    }
}

- (void) resign;
{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
}

- (IBAction)okAction:(id)sender
{
    NSString *string = self.textField1.text.length > 0 ? self.textField1.text : self.textField2.text;
    NSString *payTye = self.textField1.text.length > 0 ? @"现金" : @"刷卡";
    
    if (string && [string integerValue])
    {
        [[TDClient sharedInstance] saveOrderWithOrderMomeny:[self totalMoney] payMomney:string payType:payTye goods:self.goodList completionHandler:^(BOOL success, NSError *error, id userInfo){
            TD_LOG(@"%@", userInfo);
            if (success) {
                [self resign];
                [self showMessage: @"支付成功！"];
                
                [self.scanVC clean];
                
                [self.navigationController popViewControllerAnimated: YES];
            }
            else
            {
                [self showMessage:error.description];
            }
        }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入付款金额" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil, nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
