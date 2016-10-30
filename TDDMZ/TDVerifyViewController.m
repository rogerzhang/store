//
//  TDVerifyViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/17/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDVerifyViewController.h"

@interface TDVerifyViewController ()<TDScanViewDelegate>
@property (weak, nonatomic) IBOutlet TDScanView *scanView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) NSString *type;
@property (nonatomic, strong) NSArray *typeButtons;
@property (nonatomic, strong) NSString *ticketId;

@end

@implementation TDVerifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"核 销";
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.cornerRadius = 10.0;
    self.textView.text = nil;
    
    CGRect frame = self.scanView.frame;
    [self.scanView removeFromSuperview];
    self.scanView = [[[NSBundle mainBundle] loadNibNamed:@"TDScanView" owner:self options:nil] objectAtIndex:0];
    self.scanView.frame = frame;
    self.scanView.delegate = self;
    [self.view addSubview: self.scanView];
    
    self.typeButtons = @[self.button1, self.button2, self.button3];
    self.type = @"bonus";
    [self button1Action: self.button1];
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

- (IBAction)okButtonAction:(id)sender
{
    if (!self.ticketId) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"券号为空" message: @"请输入券号并确认" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [[TDClient sharedInstance] writeoffWithType:self.type ticketNumber:self.ticketId completionHandler:^(BOOL success, NSError *error, id userInfo){
        if (success)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"核销成功" message: nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"核销失败" message:error.description delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

- (IBAction)button1Action:(id)sender {
    [self selectButton: sender];
    self.type = @"bonus";
}

- (IBAction)button2Action:(id)sender {
    [self selectButton: sender];
    self.type = @"goods";
}

- (IBAction)button3Action:(id)sender {
    [self selectButton: sender];
    self.type = @"game";
}

- (void) selectButton: (id)button;
{
    for (UIButton *btn in self.typeButtons) {
        btn.selected = button == btn;
    }
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

- (void) scanAction: (TDScanView *)scanView;
{
    [[TDZbarReaderManager sharedInstance] startToScanBarcodeOnViewController: self withCompletionHandler: ^(BOOL success, id result){
        if (success)
        {
            TD_LOG(@"%@", result);
            NSString *ticketId = result;
            [self searchTicket: ticketId];
        }
        else
        {
             [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }];
}

- (void) searchTicket: (NSString *)ticketId;
{
    [[TDClient sharedInstance] serachticketWithType:self.type ticketNumber:ticketId completionHandler:^(BOOL success, NSError *error, id userInfo){
        if (success)
        {
            self.textView.text = userInfo;
            self.ticketId = ticketId;
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"查询错误" message:error.description delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

- (void) okAction: (TDScanView *)scanView;
{
    NSString *ticketId = [self.scanView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (ticketId.length < 1) {
        [self showMessage: @"劵号为空"];
        return;
    }
    
    [self searchTicket: ticketId];
}

- (void) showMessage: (NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
