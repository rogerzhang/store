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

@end
