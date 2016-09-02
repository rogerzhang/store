//
//  TDParser.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/1/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDParser.h"

@implementation TDParser

+ (instancetype)sharedInstance;
{
    static TDParser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [TDParser new];
    });
    
    return sharedInstance;
}

- (TDGood *)goodWithDictionary: (NSDictionary *)dict;
{
    TDGood *good = [TDGood new];
    [good setValuesForKeysWithDictionary:dict];
    return good;
}

- (NSDictionary *)dictionaryWithGood: (TDGood *)good;
{
    NSDictionary *dict = [good dictionaryWithValuesForKeys:@[@"goods_id",@"goods_name",@"shop_price",@"goods_img",@"goods_sn",@"goodattr_id",@"goods_attr"]];
    return dict;
}

- (TDStore *)storeWithDictionary: (NSDictionary *)dict;
{
    TDStore *good = [TDStore new];
    [good setValuesForKeysWithDictionary:dict];
    return good;
}

- (NSDictionary *)dictionaryWithStore: (TDStore *)store;
{
    NSDictionary *dict = [store dictionaryWithValuesForKeys:@[@"store_id",@"store_name"]];
    return dict;
}

- (TDCategory *)categoryWithDictionary: (NSDictionary *)dict;
{
    TDCategory *category = [TDCategory new];
    [category setValuesForKeysWithDictionary:dict];
    return category;
}

- (NSDictionary *)dictionaryWithCategory: (TDCategory *)category;
{
    NSDictionary *dict = [category dictionaryWithValuesForKeys:@[@"cat_id",@"cat_name",@"children"]];
    return dict;
}

@end
