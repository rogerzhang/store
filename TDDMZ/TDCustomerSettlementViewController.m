//
//  TDCustomerSettlementViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/6/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDCustomerSettlementViewController.h"

@interface TDCustomerSettlementViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

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
