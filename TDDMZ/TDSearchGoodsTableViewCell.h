//
//  TDSearchGoodsTableViewCell.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 10/7/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDSearchGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *attr1Label;

- (void) setAttributes: (NSDictionary *)attrs keys: (NSArray *)keys;

@end
