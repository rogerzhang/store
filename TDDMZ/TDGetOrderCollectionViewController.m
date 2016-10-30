//
//  TDGetOrderCollectionViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/28/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDGetOrderCollectionViewController.h"

@interface TDGetOrderCollectionViewController ()

@end

@implementation TDGetOrderCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"挂单提取";
    
    UINib *nib = [UINib nibWithNibName: @"TDOrderPreviewCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.leftBarButtonItem = [self backButton];
    
    [self.collectionView reloadData];
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
    CGSize size = CGSizeMake (350, 250);
    
    return size;
}

- (NSArray *)tempLists;
{
    return [[TDClient sharedInstance] list];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self tempLists].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TDOrderPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *userName = [TDClient sharedInstance].userName;
    NSDictionary *dic = [self tempLists][indexPath.row];
    NSDate *date = dic[@"time"];
    NSString *dateString =[[TDHelper sharedInstance] date:date formatedWithString:@"yyyy年MM月dd日 HH:mm"];
    NSNumber *count = dic[@"count"];
    
    cell.label1.text = [NSString stringWithFormat:@"挂单时间：%@", dateString];
    cell.label2.text = [NSString stringWithFormat:@"数量：%@", [count stringValue]];
    cell.label3.text = [NSString stringWithFormat:@"金额：%@", dic[@"money"]];
    cell.label4.text = [NSString stringWithFormat:@"开单人员：%@", userName];
    cell.label5.text = [NSString stringWithFormat:@"导购员：%@", userName];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    TDCashierViewController *cashVC = appDelegate.mainVC.cashierViewController;
    
    NSArray *list = [[TDClient sharedInstance] list];
    NSDictionary *dic = list[indexPath.row];
    [[[TDClient sharedInstance] list] removeObject:dic];
    NSArray *goods = dic[@"goods"];
    [cashVC setDatasource:goods];
    [self.navigationController popViewControllerAnimated: YES];
}

@end
