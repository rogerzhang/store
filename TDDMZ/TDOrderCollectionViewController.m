//
//  TDOrderCollectionViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/28/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDOrderCollectionViewController.h"

@interface TDOrderCollectionViewController ()<TDOrderCollectionViewCellDeleagate>
@property (nonatomic, strong) NSArray *datasource;
@end

@implementation TDOrderCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"订单确认";
    
    UINib *nib = [UINib nibWithNibName: @"TDOrderCollectionViewCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = [self backButton];
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self refresh];
}

- (void) refresh;
{
    [[TDClient sharedInstance] getUncheckorderlistWithCompletionHandler: ^(BOOL success, NSError *error, id userInfo){
        if (success) {
            TD_LOG(@"%@", userInfo);
            self.datasource = userInfo;
            [self.collectionView reloadData];
        }
        else
        {
            [self showMessage: error.description];
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
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGSize) collectionView: (UICollectionView *)collectionView
                   layout: (UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath: (NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake (300, 300);
    
    return size;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TDOrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.delegate = self;
    
    cell.label1.text = [NSString stringWithFormat:@"%ld", (long)[indexPath row]];
    
    NSDictionary *dic = self.datasource[indexPath.row];
    
    NSString *date = dic[@"order_date"];
    NSString *orderId = dic[@"order_code"];
    NSString *money = dic[@"order_money"];
    NSString *count = dic[@"order_number"];
    NSString *nickname = dic[@"nickname"];
//    NSString *status = dic[@"pay_status"];
    
    cell.label1.text = [NSString stringWithFormat:@"日期：%@", date];
    cell.label2.text = [NSString stringWithFormat:@"订单号：%@", orderId];
    cell.label3.text = [NSString stringWithFormat:@"金额：%@", money];
    cell.label4.text = [NSString stringWithFormat:@"件数：%@", count];
    cell.label5.text = [NSString stringWithFormat:@"昵称：%@", nickname];
    cell.label6.text = [NSString stringWithFormat:@"状态：未支付"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{}

- (void) orderDetailAction: (TDOrderCollectionViewCell*)cell;
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell: cell];
    
    TD_LOG(@"indexPath is %ld", (long)[indexPath row]);
}

- (void) orderOKAction: (TDOrderCollectionViewCell*)cell;
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell: cell];
    
    NSDictionary *dic = self.datasource[indexPath.row];
    
    NSString *orderId = dic[@"order_id"];
    NSString *status = dic[@"pay_status"];
    
    [[TDClient sharedInstance] checkorderWithId:orderId status:status completionHandler:^(BOOL success, NSError *error, id userInfo){
        if (success)
        {
            [self showMessage:@"订单确认成功"];
            [self refresh];
        }
        else
        {
            [self showMessage:error.description];
        }
    }];
    
    TD_LOG(@"indexPath is %ld", (long)[indexPath row]);
}

@end
