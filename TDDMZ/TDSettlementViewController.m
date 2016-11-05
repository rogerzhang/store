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
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotLabel;

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
    
    NSString *info = [NSString stringWithFormat:@"需支付金额 ￥ %@", self.totalMoney];
    self.infoLabel.text = info;
    self.promotLabel.text = @"";
    self.promotLabel.hidden = YES;
    [self.textField1 setRightView:self.promotLabel];
    [self.textField1 setRightViewMode:UITextFieldViewModeAlways];
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
        self.promotLabel.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (textField == self.textField1)
    {
        NSString *stringAfter = [textField.text stringByReplacingCharactersInRange: range withString: string];
        
        NSString *trimmedStr = [stringAfter stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (stringAfter != textField.text && trimmedStr.length >= 1)
        {
            NSString *string = trimmedStr;
            NSInteger inputNumber = [string integerValue];
            NSInteger actualNumber = [self.totalMoney integerValue];
            
            if (inputNumber < actualNumber)
            {
                self.promotLabel.text = @"支付金额不足！";
                self.promotLabel.textColor = [UIColor redColor];
                self.promotLabel.hidden = NO;
            }
            else
            {
                self.promotLabel.text = [NSString stringWithFormat:@"需找零 ￥ %ld", (inputNumber - actualNumber)];;
                self.promotLabel.textColor = [UIColor grayColor];
                self.promotLabel.hidden = NO;
            }
        }
    }
    return YES;
}

- (void) resign;
{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
}

- (void) checkInputMoney: (UITextField *)textField;
{
    if (textField == self.textField1 && self.textField1.text.length) {
        NSString *string = self.textField1.text;
        NSInteger inputNumber = [string integerValue];
        NSInteger actualNumber = [self.totalMoney integerValue];
        
        if (inputNumber < actualNumber)
        {
            self.promotLabel.text = @"支付金额不足！";
            self.promotLabel.textColor = [UIColor redColor];
            self.promotLabel.hidden = NO;
            return;
        }
        else
        {
            self.promotLabel.text = [NSString stringWithFormat:@"需找零 ￥ %ld", (inputNumber - actualNumber)];;
            self.promotLabel.textColor = [UIColor grayColor];
            self.promotLabel.hidden = NO;
        }
    }
}

- (IBAction)okAction:(id)sender
{
    BOOL isCash = self.textField1.text.length > 0;
    
    NSString *string = isCash ? self.textField1.text : self.textField2.text;
    NSString *payTye = isCash ? @"现金" : @"刷卡";
    
    NSInteger inputNumber = [string integerValue];
    NSInteger actualNumber = [self.totalMoney integerValue];
    
    if (inputNumber < actualNumber)
    {
        [self showMessage: @"支付金额不足！"];
        return;
    }
    
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
