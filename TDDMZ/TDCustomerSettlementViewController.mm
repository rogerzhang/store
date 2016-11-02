//
//  TDCustomerSettlementViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/6/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDCustomerSettlementViewController.h"
#import "QREncoder.h"
#import "DataMatrix.h"

@interface TDCustomerSettlementViewController ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TDCustomerSettlementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"待顾客扫描";
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.leftBarButtonItem = [self backButton];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginScan) userInfo:nil repeats:YES];
}

- (void) viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    
    if (self.urlString) {

        DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:self.urlString];
        
        int qrcodeImageDimension = 250;
        //then render the matrix
        UIImage* qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeImageDimension];
        
        self.imageView.image = qrcodeImage;
    }
}

- (void) beginScan;
{
    NSString *orderId = self.orderId;
    [[TDClient sharedInstance] lspaystatus: orderId withCompletionHandler:^(BOOL success, NSError *error, id userInfo){
        if (success) {
            if ([userInfo isEqualToString:@"1"])
            {
                [self.scanVC clean];
                [self showMessage:@"亲，支付成功！"];
                [self.navigationController popViewControllerAnimated: YES];
                [self.timer invalidate];
            }
        }
        else
        {
            [self showMessage:error.description];
        }
    }];
}

- (void) showMessage: (NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (UIBarButtonItem *)backButton;
{
    UIImage *image = [UIImage imageNamed:@"arrow"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage: image style: UIBarButtonItemStylePlain target: self action: @selector(backAction)];
    
    return backButton;
}

- (void) backAction
{
    [self.timer invalidate];
    self.timer = nil;
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) dealloc;
{
    [self.timer invalidate];
}

@end
