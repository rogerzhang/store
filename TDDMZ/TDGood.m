//
//  TDGood.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/1/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDGood.h"

@implementation TDGood

- (BOOL) isEqualGoods: (TDGood *)goods;
{
    return ([self.goods_id integerValue] == [goods.goods_id integerValue]) && [self.goodattr_id isEqualToString:self.goodattr_id];
}
@end
