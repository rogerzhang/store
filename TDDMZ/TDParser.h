//
//  TDParser.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/1/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TDGood,TDStore,TDCategory;

@interface TDParser : NSObject

+ (instancetype)sharedInstance;
- (TDGood *)goodWithDictionary: (NSDictionary *)dict;
- (NSDictionary *)dictionaryWithGood: (TDGood *)good;
- (TDStore *)storeWithDictionary: (NSDictionary *)dict;
- (NSDictionary *)dictionaryWithStore: (TDStore *)store;
- (TDCategory *)categoryWithDictionary: (NSDictionary *)dict;
- (NSDictionary *)dictionaryWithCategory: (TDCategory *)category;
@end
