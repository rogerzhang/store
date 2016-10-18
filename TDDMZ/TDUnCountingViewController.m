//
//  TDUnCountingViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 10/5/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDUnCountingViewController.h"
#import "TDUnCountingHeader.h"
#import "TDUncountTableViewCell.h"

static NSString * const cellIdentifer = @"uncountcell";
static NSString * const headerdentifer = @"uncountheader";

@interface TDUnCountingViewController ()<UIActionSheetDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *beginLabel;
@property (weak, nonatomic) IBOutlet UITextField *endLabel;
@property (weak, nonatomic) IBOutlet UITextField *statusLabel;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation TDUnCountingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"盘点未审核";
    
    UINib *cellNib = [UINib nibWithNibName:@"TDUncountTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellIdentifer];
    [self.tableView registerClass:[TDUnCountingHeader class] forHeaderFooterViewReuseIdentifier:headerdentifer];
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

- (void) viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.beginLabel.frame) + 10;
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height - y;
    self.tableView.frame = CGRectMake(x, y, w, h);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.datasource.count;
}

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TDUncountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifer];
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    TDUnCountingHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerdentifer];
    
    if (!headerView)
    {
        headerView = [[TDUnCountingHeader alloc] initWithReuseIdentifier: headerdentifer];
    }
    
    NSArray *attrs = [self attrs];
    [headerView setAttributes:attrs];
    
    return headerView;
}

- (NSArray *)attrs;
{
    return @[@"商品编码", @"商品名称", @"规格", @"单价", @"数量"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TDCDTableViewController *detailVC = [[TDCDTableViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)searchAction:(id)sender
{
    if (self.beginDate == nil) {
        [self showErrorMessage:@"请选择开始时间" title:nil];
        return;
    }
    if (self.endDate == nil)
    {
        [self showErrorMessage:@"请选择结束时间" title:nil];
        return;
    }
    
    if (self.status == nil) {
        [self showErrorMessage:@"请选择状态" title:nil];
        return;
    }
}

- (void) showErrorMessage: (NSString *)message title: (NSString *)title;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == self.beginLabel || textField == self.endLabel)
    {
        TDDateViewController *vc = [[TDDateViewController alloc] initWithNibName:nil bundle:nil];
        vc.changeHandler = ^(NSDate *date){
            NSString *dateString = [[TDHelper sharedInstance] date: date formatedWithString: TDFormatDateString];
            textField.text = dateString;
            if (textField == self.beginLabel) {
                self.beginDate = date;
            }
            else
            {
                self.endDate = date;
            }
        };
        
        UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:vc];
        popOver.popoverContentSize = CGSizeMake(320, 200);
        popOver.delegate = self;
        [popOver presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else
    {
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *unverifiedAction = [UIAlertAction actionWithTitle:@"未审核" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            self.status = @"未审核";
            textField.text = self.status;
            [alertController dismissViewControllerAnimated:YES completion:NULL];
        }];
        
       UIAlertAction *verifiedAction = [UIAlertAction actionWithTitle:@"审核" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
           self.status = @"审核";
           textField.text = self.status;
           [alertController dismissViewControllerAnimated:YES completion:NULL];
       }];
   
        alertController.popoverPresentationController.sourceView = textField;
        alertController.popoverPresentationController.sourceRect = textField.bounds;
        [alertController addAction:unverifiedAction];
        [alertController addAction:verifiedAction];
        [self presentViewController:alertController animated:YES completion:NULL];
    }

    return NO;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    
}

@end
