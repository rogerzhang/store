//
//  TDChooseBaseViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/5/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDChooseBaseViewController.h"

@interface TDChooseBaseViewController ()<RATreeViewDelegate, RATreeViewDataSource>
@property (weak, nonatomic) RATreeView *treeView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (strong, nonatomic) UIBarButtonItem *editButton;
@end

@implementation TDChooseBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
    
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
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = NSLocalizedString(@"Things", nil);
    [self updateNavigationItemButton];
    
    [self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RATableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];
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
    
    self.treeView.frame = self.view.bounds;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(self) weakSelf = self;
    cell.additionButtonTapAction = ^(id sender){
        if (![weakSelf.treeView isCellForItemExpanded:dataObject] || weakSelf.treeView.isEditing) {
            return;
        }
        RADataObject *newDataObject = [[RADataObject alloc] initWithName:@"Added value" children:@[]];
        [dataObject addChild:newDataObject];
        [weakSelf.treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:0] inParent:dataObject withAnimation:RATreeViewRowAnimationLeft];
        [weakSelf.treeView reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
    };
    
    cell.separatorInset = UIEdgeInsetsZero;
    
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
//    RADataObject *adata = item;
//    
//    if (adata)
//    {
//        TDCategory *category = adata.userInfo;
//        if (category.children)
//        {
//            [[TDClient sharedInstance] getCategoryListWithCategoryId:category.cat_id completionHandler:^(BOOL success, NSError *error, id userInfo){
//                if (userInfo)
//                {
//                    NSArray *res = userInfo;
//                    for (NSDictionary *dic in res)
//                    {
//                        TDCategory *cat = [TDCategory new];
//                        [cat setValuesForKeysWithDictionary:dic];
//                        RADataObject *children = [RADataObject dataObjectWithName:cat.cat_name children:nil];
//                        children.userInfo = cat;
//                        [adata addChild:children];
//                    }
//                }
//            }];
//        }
//    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
