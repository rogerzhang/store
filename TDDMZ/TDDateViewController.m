//
//  TDDateViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 10/5/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDDateViewController.h"

@interface TDDateViewController ()
@property (nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation TDDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:self.view.frame];
    NSLocale *chineseLocale = [NSLocale localeWithLocaleIdentifier:@"zh_cn"];
    [datePicker setLocale:chineseLocale];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventValueChanged];
    self.datePicker = datePicker;
    [self.view addSubview:self.datePicker];
}

- (void)changeTime:(UIDatePicker*)sender
{
    if (self.changeHandler) {
        self.changeHandler([sender date]);
    }
}

- (void) viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    
    self.datePicker.frame = self.view.bounds;
}

- (void) viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    if (self.changeHandler) {
        self.changeHandler([self.datePicker date]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
