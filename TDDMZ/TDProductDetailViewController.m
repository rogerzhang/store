//
//  TDProductDetailViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 10/5/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDProductDetailViewController.h"

@interface TDProductDetailViewController ()<TDSaveBannerDelegate, TDSaveBannerDelegate>
@property (nonatomic, strong) NSString *attr1Id;
@property (nonatomic, strong) NSString *attr2Id;
@property (nonatomic, strong) NSArray *attr1List;
@property (nonatomic, strong) NSArray *attr2List;
@end

@implementation TDProductDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"商品详情";
    
    self.saveBanner = [[[NSBundle mainBundle] loadNibNamed:@"TDSaveBanner" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.saveBanner];
    self.saveBanner.delegate = self;
    self.saveBanner.backgroundColor = RGBColor(247, 247, 247);
    [self.saveBanner showLabel: NO];
}

- (void) remvoeAttrViews;
{
    for (UIView *view in self.view.subviews) {
        if (view.tag > 109) {
            [view removeFromSuperview];
        }
    }
}

- (void) attr1ButtonClicked: (id)sender;
{
    for (UIButton *btn in self.view.subviews) {
        if (btn.tag > 110 && btn.tag < 200) {
            btn.selected = NO;
        }
    }
    TDInfoButton *btn = (TDInfoButton*)sender;
    btn.selected = YES;
    self.attr1Id = btn.userInfo[@"attr_id"];
    
    [self chooseattrAction];
}

- (void) attr2ButtonClicked: (id)sender;
{
    for (UIButton *btn in self.view.subviews) {
        if (btn.tag > 220 && btn.tag < 300) {
            btn.selected = NO;
        }
    }
    TDInfoButton *btn = (TDInfoButton*)sender;
    btn.selected = YES;
    
    self.attr2Id = btn.userInfo[@"attr_id"];
    
    [self chooseattrAction];
}

- (void) chooseattrAction;
{
    if (self.attr1List.count && !self.attr1Id) {
        return;
    }
    
    if (self.attr2List.count && !self.attr2Id) {
        return;
    }
    
    if (!self.attr1Id && !self.attr2Id)
    {
        return;
    }
    
    [[TDClient sharedInstance] chooseattr1:self.attr1Id attr2:self.attr2Id forGoods:self.goods.goods_id completionHandler:^(BOOL success, NSError *error, id userInfo){
        if (success)
        {
            self.goods = [[TDParser sharedInstance] goodWithDictionary:userInfo];
            
            if (!self.goods.goods_number) {
                self.goods.goods_number = 1;
            }
            
            self.priceLabel.text = userInfo[@"shop_price"];
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

- (void) viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void) viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    CGFloat height = TDBANNER_HEIGHT;
    CGRect frame = CGRectMake(0, bounds.size.height - height, bounds.size.width, height);
    self.saveBanner.frame = frame;
}

- (void) refresh;
{
    if (self.goods)
    {
        [[TDClient sharedInstance] getGoodsDetailInfoWithId:self.goods.goods_id withCompletionHandler:^(BOOL success, NSError *error, id userInfo){
            if (success) {
                NSDictionary *res = userInfo;
                self.nameLabel.text = res[@"goods_name"];
                self.priceLabel.text = res[@"shop_price"];
                NSString *urlString = res[@"goods_img"];
                NSURL *url = [NSURL URLWithString:urlString];
                
                [self remvoeAttrViews];
                
                NSString *attr1Name = res[@"attr1_name"];
                NSArray *attr1Values = res[@"attr1"];
                
                self.attr1List = attr1Values;
                
                NSString *attr2Name = res[@"attr2_name"];
                NSArray *attr2Values = res[@"attr2"];
                
                self.attr2List = attr2Values;
                
                if (attr1Name && attr1Values.count)
                {
                    UILabel *label1 = [UILabel new];
                    label1.tag = 110;
                    label1.text = attr1Name;
                    [self.view addSubview:label1];
                    [label1 sizeToFit];
                    
                    CGFloat x = CGRectGetMinX(self.nameLabel.frame);
                    CGFloat y = CGRectGetMaxY(self.nameLabel.frame) + 25;
                    label1.frame = CGRectMake(x, y, label1.frame.size.width, 30);
                    
                    for (NSInteger i = 0; i < attr1Values.count; i++) {
                        NSString *attr = attr1Values[i][@"attr_value"];
                        TDInfoButton *btn = [TDInfoButton buttonWithType:UIButtonTypeCustom];
                        [btn addTarget:self action:@selector(attr1ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        [btn setTitle:attr forState:UIControlStateNormal];
                        [btn setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
                        [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateSelected];
                        [self.view addSubview:btn];
                        
                        UIImage *normalImage = [UIImage imageNamed:@"商品详情框1"];
                        UIImage *selectedImage = [UIImage imageNamed:@"商品详情框2"];
                        
                        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
                        [btn setBackgroundImage:selectedImage forState:UIControlStateSelected];
                        btn.userInfo = attr1Values[i];
                        
                        CGFloat w = 60;
                        CGFloat h = 30;
                        CGFloat bx = CGRectGetMaxX(label1.frame) + 10 + (w + 10) * i;
                        btn.frame = CGRectMake(bx, y, w, h);
                        btn.tag = 111 + i;
                    }
                    
                    if (attr2Name && attr2Values.count)
                    {
                        UILabel *label2 = [UILabel new];
                        label2.tag = 220;
                        label2.text = attr2Name;
                        [self.view addSubview:label2];
                        [label2 sizeToFit];
                        
                        CGFloat x = CGRectGetMinX(label1.frame);
                        CGFloat y = CGRectGetMaxY(label1.frame) + 25;
                        label2.frame = CGRectMake(x, y, label2.frame.size.width, 30);
                        
                        for (NSInteger i = 0; i < attr2Values.count; i++) {
                            NSString *attr = attr2Values[i][@"attr_value"];
                            TDInfoButton *btn2 = [TDInfoButton buttonWithType:UIButtonTypeCustom];
                            [btn2 addTarget:self action:@selector(attr2ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                            [btn2 setTitle:attr forState:UIControlStateNormal];
                            [btn2 setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
                            [btn2 setTitleColor: [UIColor whiteColor] forState:UIControlStateSelected];
                            UIImage *normalImage = [UIImage imageNamed:@"商品详情框1"];
                            UIImage *selectedImage = [UIImage imageNamed:@"商品详情框2"];
                            
                            [btn2 setBackgroundImage:normalImage forState:UIControlStateNormal];
                            [btn2 setBackgroundImage:selectedImage forState:UIControlStateSelected];
                            [self.view addSubview:btn2];
                            btn2.userInfo = attr2Values[i];
                            
                            CGFloat w = 60;
                            CGFloat h = 30;
                            CGFloat bx = CGRectGetMaxX(label2.frame) + 10 + (w + 10) * i;;
                            btn2.frame = CGRectMake(bx, y, w, h);
                            btn2.tag = 221 + i;
                        }
                    }
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData* data = [[NSData alloc] initWithContentsOfURL:url];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.imagView.image = image;
                    });
                });
                
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"查询错误" message:error.description delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) saveActionWithSaveBanner: (TDSaveBanner *)banner;
{
    if (!self.attr1Id || !self.attr2Id)
    {
        [self showMessage:@"请选择规格"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(saveActionWithDetailViewController:)]) {
        [self.delegate saveActionWithDetailViewController:self];
    }
}

@end
