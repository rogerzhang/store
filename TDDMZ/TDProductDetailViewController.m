//
//  TDProductDetailViewController.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 10/5/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDProductDetailViewController.h"

@interface TDProductDetailViewController ()<TDSaveBannerDelegate>

@end

@implementation TDProductDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.saveBanner = [[[NSBundle mainBundle] loadNibNamed:@"TDSaveBanner" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview: self.saveBanner];
    self.saveBanner.backgroundColor = RGBColor(247, 247, 247);
    
    if (self.goodsId)
    {
        [[TDClient sharedInstance] getGoodsDetailInfoWithId:self.goodsId withCompletionHandler:^(BOOL success, NSError *error, id userInfo){
            if (success) {
                NSDictionary *res = userInfo;
                self.nameLabel.text = res[@"goods_name"];
                self.priceLabel.text = res[@"shop_price"];
                NSString *urlString = res[@"goods_img"];
                NSURL *url = [NSURL URLWithString:urlString];
                
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

- (void) viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    CGFloat height = TDBANNER_HEIGHT;
    CGRect frame = CGRectMake(0, bounds.size.height - height, bounds.size.width, height);
    self.saveBanner.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) saveActionWithSaveBanner: (TDSaveBanner *)banner;
{
    if ([self.delegate respondsToSelector:@selector(saveActionWithDetailViewController:)]) {
        [self.delegate saveActionWithDetailViewController:self];
    }
}

@end
