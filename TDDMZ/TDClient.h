//
//  TDClient.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/28/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString * const TDFormatDateString = @"yyyy-MM-dd";
#if NDEBUG
//#define BASEURL [NSURL URLWithString:@"http://dev.dmuzhi.cn/CashierService"]
#define BASEURL [NSURL URLWithString:@"http://www.dmuzhi.cn/CashierService"]
#else
#define BASEURL [NSURL URLWithString:@"http://www.dmuzhi.cn/CashierService"]
#endif

typedef void (^TDCompletionHandler) (BOOL success, NSError *error, id userInfo);

@interface TDClient : NSObject

@property (nonatomic, readonly, strong) NSString *userId;
@property (nonatomic, readonly, strong) NSString *userName;
@property (nonatomic, readonly, strong) NSString *storeName;
@property (nonatomic, readonly, strong) NSMutableArray *list;
@property (nonatomic, readonly, strong) AFHTTPSessionManager *httpSessionManager;

@property (nonatomic, strong) NSString *unreadCountOfOrder;
@property (nonatomic, strong) NSString *unreadCountOfDB;
@property (nonatomic, strong) NSString *unreadCountOfPD;

+ (instancetype) sharedInstance;

- (void) addOrder: (NSDictionary *)dict;
- (void) removeAllOrder;
- (void) loginWithAccount: (NSString *)account password: (NSString *)password completionHandler: (TDCompletionHandler)completionHandler;
- (void) logoutWithCompletionHandler: (TDCompletionHandler)completionHandler;
- (void) getIndexNumWithCompletionHandler: (TDCompletionHandler)completionHandler;
- (void) getCategoryListWithCategoryId: (NSString *)cat_id completionHandler: (TDCompletionHandler)completionHandler;
- (void) getCategorygoodsWithId: (NSString *)categoryId withCompletionHandler: (TDCompletionHandler)completionHandler;
- (void) getGoodsDetailInfoWithId: (NSString *)goodsId withCompletionHandler: (TDCompletionHandler)completionHandler;
- (void) addgoods: (NSString *)goodId attributes: (NSArray *)attributes withCompletionHandler: (TDCompletionHandler) completionHandler;
- (void) chooseattr1: (NSString *)attr1Id attr2: (NSString *)attr2Id forGoods: (NSString *)goodId completionHandler: (TDCompletionHandler) completionHandler;
- (void) getGoodInfo: (NSString *)goodId withCompletionHandler: (TDCompletionHandler) completionHandler;
- (void) submitorderGoods: (NSArray *)Goods orderMoney: (NSString *)ordermoney withCompletionHandler: (TDCompletionHandler)completionHandler;
- (void) saveOrderWithOrderMomeny: (NSString *)ordermoney payMomney: (NSString *)payMomeny payType: (NSString *)payType goods: (NSArray *)goods completionHandler: (TDCompletionHandler)completionHandler;
- (void) checkorderWithId: (NSString *)orderId status: (NSString *)status completionHandler:(TDCompletionHandler)completionHandler;
- (void) getStorelistWithCompletionHandler:(TDCompletionHandler)completionHandler;
- (void) deliverToStoreId: (NSString *)toStore goods: (NSArray *)goods completionHandler:(TDCompletionHandler)completionHandler;
- (void) checkdborderWithId:(NSString *)orderId completionHandler:(TDCompletionHandler)completionHandler;
- (void) canceldborderbillWithId:(NSString *)orderId completionHandler:(TDCompletionHandler)completionHandler;
- (void) getPendingdborderWithCompletionHandler: (TDCompletionHandler)completionHandler;
- (void) searchdborderFormDate: (NSDate *)fromDate to: (NSDate *)toDate type: (NSString *)type status: (NSString *)status withCompletionHandler: (TDCompletionHandler)completionHandler;
- (void) getPendingrkorderWithCompletionHandler:(TDCompletionHandler)completionHandler;
- (void) checkrkorderWithId: (NSString *)orderId withCompletionHandler:(TDCompletionHandler)completionHandler;
- (void) getDborderinfoWithId: (NSString *)orderId withCompletionHander: (TDCompletionHandler)completionHandler;
- (void) getRkorderinfoWithId: (NSString *)orderId withCompletionHander: (TDCompletionHandler)completionHandler;
- (void) serachticketWithType:(NSString *)type ticketNumber: (NSString *)tickeNumber completionHandler:(TDCompletionHandler)completionHandler;
- (void) writeoffWithType:(NSString *)type ticketNumber: (NSString *)tickeNumber completionHandler:(TDCompletionHandler)completionHandler;
- (void) addPdorderWithListData: (NSArray *)listData completionHandler: (TDCompletionHandler)completionHandler;
- (void) getPendingpdorderWithCompletionHandler:(TDCompletionHandler)completionHandler;
- (void) getPdorderinfoWithId: (NSString *)orderId WithCompletionHandler:(TDCompletionHandler)completionHandler;
- (void) checkpdorder: (NSString *)orderId withCompletionHandler:(TDCompletionHandler)completionHandler;
- (void) recheckpdorderWithId: (NSString *)orderId withCompletionHandler:(TDCompletionHandler)completionHandler;
- (void) searchpdorderFormDate: (NSDate *)fromDate to: (NSDate *)toDate status: (NSString *)status withCompletionHandler: (TDCompletionHandler)completionHandler;
- (void) searchgoodsWithBarcode: (NSString *)barcode orGoodsId: (NSString *)goodsId orGoodattrId: (NSString *)goodattr_id withCompletionHandler: (TDCompletionHandler)completionHandler;
- (void) lspaystatus: (NSString *)orderId withCompletionHandler:(TDCompletionHandler)completionHandler;
- (void) getUncheckorderlistWithCompletionHandler:(TDCompletionHandler)completionHandler;
- (void) getOrderDetailWithOrderId: (NSString *)orderId completionHandler:(TDCompletionHandler)completionHandler;
- (void) searchGoodsWithKeyword: (NSString *)keyword completionHandler:(TDCompletionHandler)completionHandler;
@end
