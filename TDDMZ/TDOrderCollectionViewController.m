//
//  TDOrderCollectionViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/28/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDOrderCollectionViewController.h"

@interface TDOrderCollectionViewController ()<TDOrderCollectionViewCellDeleagate>

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
}

- (UIBarButtonItem *)backButton;
{
    UIImage *image = [UIImage imageNamed:@"Arrows-Back-icon"];
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
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TDOrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.delegate = self;
    cell.label1.text = [NSString stringWithFormat:@"%ld", [indexPath row]];
    return cell;
}

- (void) orderDetailAction: (TDOrderCollectionViewCell*)cell;
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell: cell];
    
    TD_LOG(@"indexPath is %ld", [indexPath row]);
}

- (void) orderOKAction: (TDOrderCollectionViewCell*)cell;
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell: cell];
    
    TD_LOG(@"indexPath is %ld", [indexPath row]);
}

@end
