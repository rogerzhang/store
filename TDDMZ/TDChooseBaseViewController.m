//
//  TDChooseBaseViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/5/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDChooseBaseViewController.h"
#import "TDChooseProductLayout.h"
#import "TDChooseProductCollectionViewCell.h"

@interface TDChooseBaseViewController ()<RATreeViewDelegate, RATreeViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) RATreeView *treeView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *goodList;
@property (strong, nonatomic) id expanded;
@property (strong, nonatomic) UIBarButtonItem *editButton;
@property (strong, nonatomic) UICollectionView *collectionView;
@end

static NSString * const reuseIdentifier = @"Cell";

@implementation TDChooseBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
    
    UICollectionViewLayout *layout = [TDChooseProductLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview: self.collectionView];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.treeFooterView = [UIView new];
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshControlChanged:) forControlEvents:UIControlEventValueChanged];
    [treeView.scrollView addSubview:refreshControl];
    
    [treeView reloadData];
    [treeView setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1.0]];
    
    
    self.treeView = treeView;
    self.treeView.frame = self.view.bounds;
    self.treeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:treeView atIndex:0];
    self.treeView.cellLayoutMarginsFollowReadableWidth = NO;
    self.treeView.backgroundColor = UIColorFromRGB(0xeaebec);
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = NSLocalizedString(@"Things", nil);
    [self updateNavigationItemButton];
    
    [self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RATableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];
    UINib *nib = [UINib nibWithNibName: @"TDChooseProductCollectionViewCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    int systemVersion = [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue];
    if (systemVersion >= 7 && systemVersion < 8) {
        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
        self.treeView.scrollView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
        self.treeView.scrollView.contentOffset = CGPointMake(0.0, -heightPadding);
    }
    
    CGRect bounds = self.view.bounds;
    CGRect tRect = bounds;
    tRect.size.width = 180;
    self.treeView.frame = tRect;
    
    tRect.origin.x = CGRectGetMaxX(self.treeView.frame);
    tRect.size.width = bounds.size.width - CGRectGetWidth(self.treeView.frame);
    self.collectionView.frame = tRect;
}

#pragma mark - Actions

- (void)refreshControlChanged:(UIRefreshControl *)refreshControl
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshControl endRefreshing];
    });
}

- (void)editButtonTapped:(id)sender
{
    [self.treeView setEditing:!self.treeView.isEditing animated:YES];
    [self updateNavigationItemButton];
}

- (void)updateNavigationItemButton
{
    UIBarButtonSystemItem systemItem = self.treeView.isEditing ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit;
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(editButtonTapped:)];
    self.navigationItem.rightBarButtonItem = self.editButton;
}


#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    return 44;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return YES;
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
{
    RATableViewCell *cell = (RATableViewCell *)[treeView cellForItem:item];
    [cell setAdditionButtonHidden:NO animated:YES];
}

- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item
{
    RATableViewCell *cell = (RATableViewCell *)[treeView cellForItem:item];
    [cell setAdditionButtonHidden:YES animated:YES];
}

- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    RADataObject *parent = [self.treeView parentForItem:item];
    NSInteger index = 0;
    
    if (parent == nil) {
        index = [self.data indexOfObject:item];
        NSMutableArray *children = [self.data mutableCopy];
        [children removeObject:item];
        self.data = [children copy];
        
    } else {
        index = [parent.children indexOfObject:item];
        [parent removeChild:item];
    }
    
    [self.treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent withAnimation:RATreeViewRowAnimationRight];
    if (parent) {
        [self.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    RADataObject *dataObject = item;
    
    NSInteger level = [self.treeView levelForCellForItem:item];
    NSInteger numberOfChildren = [dataObject.children count];
    NSString *detailText = [NSString localizedStringWithFormat:@"Number of children %@", [@(numberOfChildren) stringValue]];
    BOOL expanded = [self.treeView isCellForItemExpanded:item];
    
    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:dataObject.name detailText:detailText level:level additionButtonHidden:!expanded];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    
    return data.children[index];
}

#pragma mark - Helpers

- (void)loadData
{
    NSMutableArray *categories = [NSMutableArray array];
    
    [[TDClient sharedInstance] getCategoryListWithCategoryId:@"0" completionHandler:^(BOOL success, NSError *error, id userInfo){
        if (userInfo)
        {
            NSArray *res = userInfo;
            for (NSDictionary *dic in res)
            {
                TDCategory *cat = [TDCategory new];
                [cat setValuesForKeysWithDictionary:dic];
                RADataObject *data = [RADataObject dataObjectWithName:cat.cat_name children:nil];
                data.userInfo = cat;
                [categories addObject:data];
                [self rescursiveGetChildrenForCategory: data];
            }
            
            self.data = categories;
            [self.treeView reloadData];
        }
    }];
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item;
{
    RADataObject *adata = item;
    
    if (adata)
    {
        TDCategory *category = adata.userInfo;
        if (!category.children)
        {
            [[TDClient sharedInstance] getCategorygoodsWithId:category.cat_id withCompletionHandler:^(BOOL success, NSError *error, id userInfo){
                if (userInfo)
                {
                    NSArray *res = userInfo;
                    NSMutableArray *goodList = [NSMutableArray array];
                    for (NSDictionary *dic in res)
                    {
                        TDGood *cat = [TDGood new];
                        [cat setValuesForKeysWithDictionary:dic];
                        [goodList addObject: cat];
                    }
                    if (goodList.count) {
                        self.goodList = goodList;
                        [self.collectionView reloadData];
                    }
                }
            }];
        }
    }
    
    UITableViewCell *cell = [treeView cellForItem:item];
    [cell setSelected: YES];
}

- (void) rescursiveGetChildrenForCategory: (RADataObject *)adata;
{
    if (adata)
    {
        TDCategory *category = adata.userInfo;
        if (category.children)
        {
            [[TDClient sharedInstance] getCategoryListWithCategoryId:category.cat_id completionHandler:^(BOOL success, NSError *error, id userInfo){
                if (userInfo)
                {
                    NSArray *res = userInfo;
                    for (NSDictionary *dic in res)
                    {
                        TDCategory *cat = [TDCategory new];
                        [cat setValuesForKeysWithDictionary:dic];
                        RADataObject *children = [RADataObject dataObjectWithName:cat.cat_name children:nil];
                        children.userInfo = cat;
                        [adata addChild:children];
                        
                        if (cat.children) {
                            [self rescursiveGetChildrenForCategory: children];
                        }
                    }
                }
            }];
        }
    }
}

- (CGSize) collectionView: (UICollectionView *)collectionView
                   layout: (UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath: (NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake (210, 186);
    
    return size;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TDChooseProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    TDGood *good = self.goodList[indexPath.row];
    cell.label.text = good.goods_name;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL* aURL = [NSURL URLWithString: good.goods_img];
        NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = image;
        });
    });
    
    return cell;
}

- (void) orderDetailAction: (TDOrderCollectionViewCell*)cell;
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell: cell];
    
    TD_LOG(@"indexPath is %ld", (long)[indexPath row]);
}

- (void) orderOKAction: (TDOrderCollectionViewCell*)cell;
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell: cell];
    
    TD_LOG(@"indexPath is %ld", (long)[indexPath row]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
