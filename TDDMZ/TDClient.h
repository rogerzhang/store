//
//  TDClient.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/28/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#if NDEBUG
#define BASEURL [NSURL URLWithString:@"http://dev.dmuzhi.cn/CashierService"]
#else
#define BASEURL [NSURL URLWithString:@"http://dev.dmuzhi.cn/CashierService"]
#endif

typedef void (^TDCompletionHandler) (BOOL success, NSError *error, id userInfo);

@interface TDClient : NSObject

@property (nonatomic, readonly, strong) NSString *userId;
@property (nonatomic, readonly, strong) NSString *userName;
@property (nonatomic, readonly, strong) NSString *storeName;
@property (nonatomic, readonly, strong) AFHTTPSessionManager *httpSessionManager;

+ (instancetype) sharedInstance;

- (void) loginWithAccount: (NSString *)account password: (NSString *)password completionHandler: (TDCompletionHandler)completionHandler;
- (void) logoutWithCompletionHandler: (TDCompletionHandler)completionHandler;
- (void) getIndexNumWithCompletionHandler: (TDCompletionHandler)completionHandler;
- (void) getCategoryListWithCategoryId: (NSString *)cat_id completionHandler: (TDCompletionHandler)completionHandler;
- (void) getCategorygoodsWithId: (NSString *)categoryId withCompletionHandler: (TDCompletionHandler)completionHandler;
- (void) getGoodInfo: (NSString *)goodId withCompletionHandler: (TDCompletionHandler) completionHandler;
- (void) submitorderGoods: (NSArray *)Goods orderMoney: (NSString *)ordermoney withCompletionHandler: (TDCompletionHandler)completionHandler;
- (void) saveOrderWithOrderMomeny: (NSString *)ordermoney payMomney: (NSString *)payMomeny payType: (NSString *)payType goods: (NSArray *)goods completionHandler: (TDCompletionHandler)completionHandler;
- (void) checkorderWithId: (NSString *)orderId status: (NSString *)status completionHandler:(TDCompletionHandler)completionHandler;
- (void) getStorelistWithCompletionHandler:(TDCompletionHandler)completionHandler;
- (void) deliverToStoreId: (NSString *)toStore goods: (NSArray *)goods completionHandler:(TDCompletionHandler)completionHandler;
@end
