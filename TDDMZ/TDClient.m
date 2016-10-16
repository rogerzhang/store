//
//  TDClient.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/28/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDClient.h"

@interface TDClient()

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation TDClient

+ (instancetype) sharedInstance;
{
    static TDClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [TDClient new];
        NSURL *URL = BASEURL;
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        client.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL sessionConfiguration:configuration];
        client.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        client.list = [NSMutableArray array];
    });
    
    return client;
}

- (void) addOrder: (NSDictionary *)dict;
{
    [self.list addObject: dict];
}

- (void) removeAllOrder;
{
    [self.list removeAllObjects];
}

- (void)loginWithAccount: (NSString *)account password: (NSString *)password completionHandler: (TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:account forKey:@"user"];
    [params setValue:password forKey:@"pwd"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    [self.manager
        POST:@"login"
        parameters:@{@"code":jsonString}
        progress:^(NSProgress *uploadProgress){}
        success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
            TD_LOG(@"%@", responseObject);
            [self.list removeAllObjects];
            
            NSDictionary *result = (NSDictionary *)responseObject;
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"failed"])
            {
                NSString *errorMsg = [result objectForKey:@"error_msg"];
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"error" code:101 userInfo:details];
                
                if (completionHandler) {
                    completionHandler(NO, error, nil);
                }
            }
            else
            {
                NSString *userId = [result objectForKey:@"user_id"];
                NSString *storeName = [result objectForKey:@"store"];
                NSString *userName = [result objectForKey:@"user_name"];
                
                self.userId = userId;
                self.storeName = storeName;
                self.userName = userName;
                
                if (completionHandler) {
                    completionHandler(YES, nil, nil);
                }
            }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
            TD_LOG(@"%@", error);
            [self.list removeAllObjects];
            if (completionHandler) {
                completionHandler(NO, error, nil);
            }
        }];
}

- (void) logoutWithCompletionHandler: (TDCompletionHandler)completionHandler;
{
    self.userName = nil;
    self.storeName = nil;
    self.userId = nil;
    
    if (completionHandler) {
        completionHandler(YES, nil, nil);
    }
}

- (void) getIndexNumWithCompletionHandler: (TDCompletionHandler)completionHandler
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
         POST:@"indexnum"
         parameters:@{@"code":jsonString}
         progress:^(NSProgress *uploadProgress){}
         success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
             TD_LOG(@"%@", responseObject);
             NSDictionary *result = (NSDictionary *)responseObject;
             NSString *status = [result objectForKey:@"status"];
             if ([status isEqualToString:@"failed"])
             {
                 NSString *errorMsg = [result objectForKey:@"error_msg"];
                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                 [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:@"error" code:102 userInfo:details];
                 
                 if (completionHandler) {
                     completionHandler(NO, error, nil);
                 }
             }
             else
             {
                 if (result)
                 {
                     TD_LOG(@"%@", result);
                 }
                 
                 if (completionHandler) {
                     completionHandler(YES, nil, result);
                 }
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
             TD_LOG(@"%@", error);
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }];
}

- (void) getCategoryListWithCategoryId: (NSString *)cat_id completionHandler: (TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:cat_id forKey:@"cat_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
         POST:@"categorylist"
         parameters:@{@"code":jsonString}
         progress:^(NSProgress *uploadProgress){}
         success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
             TD_LOG(@"%@", responseObject);
             NSDictionary *result = (NSDictionary *)responseObject;
             NSString *status = [result objectForKey:@"status"];
             if ([status isEqualToString:@"failed"])
             {
                 NSString *errorMsg = [result objectForKey:@"error_msg"];
                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                 [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:@"error" code:103 userInfo:details];
                 
                 if (completionHandler) {
                     completionHandler(NO, error, nil);
                 }
             }
             else
             {
                 NSArray *categories = [result objectForKey:@"category"];
                 if (categories)
                 {
                     TD_LOG(@"%@", categories);
                 }
                 
                 if (completionHandler) {
                     completionHandler(YES, nil, categories);
                 }
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
             TD_LOG(@"%@", error);
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }];
}

- (void) getCategorygoodsWithId: (NSString *)categoryId withCompletionHandler: (TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:categoryId forKey:@"cat_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
         POST:@"categorygoods"
         parameters:@{@"code":jsonString}
         progress:^(NSProgress *uploadProgress){}
         success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
             TD_LOG(@"%@", responseObject);
             NSDictionary *result = (NSDictionary *)responseObject;
             NSString *status = [result objectForKey:@"status"];
             if ([status isEqualToString:@"failed"])
             {
                 NSString *errorMsg = [result objectForKey:@"error_msg"];
                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                 [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:@"error" code:104 userInfo:details];
                 
                 if (completionHandler) {
                     completionHandler(NO, error, nil);
                 }
             }
             else
             {
                 NSArray *goodslist = [result objectForKey:@"goodslist"];
                 if (goodslist)
                 {
                     TD_LOG(@"%@", goodslist);
                 }
                 
                 if (completionHandler) {
                     completionHandler(YES, nil, goodslist);
                 }
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
             TD_LOG(@"%@", error);
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }];
}

- (void) getGoodsDetailInfoWithId: (NSString *)goodsId withCompletionHandler: (TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:goodsId forKey:@"goods_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"goods"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:105 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSArray *goodslist = [result objectForKey:@"goods"];
             if (goodslist)
             {
                 TD_LOG(@"%@", goodslist);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, goodslist);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

// ???
- (void) addgoods: (NSString *)goodId attributes: (NSArray *)attributes withCompletionHandler: (TDCompletionHandler) completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:goodId forKey:@"goods_id"];
    
    NSString *attr1 = attributes[0];
    NSString *attr2 = attributes[1];
    [params setValue:attr1 forKey:@"attr1"];
    [params setValue:attr2 forKey:@"Attr2"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"addgoods"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:106 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSDictionary *goodInfo = [result objectForKey:@"goods"];
             
             if (goodInfo)
             {
                 TD_LOG(@"%@", goodInfo);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, goodInfo);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) getGoodInfo: (NSString *)goodId withCompletionHandler: (TDCompletionHandler) completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:goodId forKey:@"barcode"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
         POST:@"goodsinfo"
         parameters:@{@"code":jsonString}
         progress:^(NSProgress *uploadProgress){}
         success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
             TD_LOG(@"%@", responseObject);
             NSDictionary *result = (NSDictionary *)responseObject;
             NSString *status = [result objectForKey:@"status"];
             if ([status isEqualToString:@"failed"])
             {
                 NSString *errorMsg = [result objectForKey:@"error_msg"];
                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                 [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:@"error" code:107 userInfo:details];
                 
                 if (completionHandler) {
                     completionHandler(NO, error, nil);
                 }
             }
             else
             {
                 NSDictionary *goodInfo = [result objectForKey:@"goods"];
                 
                 if (goodInfo)
                 {
                     TD_LOG(@"%@", goodInfo);
                 }
                 
                 if (completionHandler) {
                     completionHandler(YES, nil, goodInfo);
                 }
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
             TD_LOG(@"%@", error);
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }];
}

- (void) submitorderGoods: (NSArray *)Goods orderMoney: (NSString *)ordermoney withCompletionHandler: (TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:ordermoney forKey:@"ordermoney"];
    [params setValue:Goods forKey:@"goods"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
         POST:@"submitorder"
         parameters:@{@"code":jsonString}
         progress:^(NSProgress *uploadProgress){}
         success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
             TD_LOG(@"%@", responseObject);
             NSDictionary *result = (NSDictionary *)responseObject;
             NSString *status = [result objectForKey:@"status"];
             if ([status isEqualToString:@"failed"])
             {
                 NSString *errorMsg = [result objectForKey:@"error_msg"];
                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                 [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:@"error" code:108 userInfo:details];
                 
                 if (completionHandler) {
                     completionHandler(NO, error, nil);
                 }
             }
             else
             {
                 NSString *orderId = [result objectForKey:@"order_id"];
                 NSString *qrcode = [result objectForKey:@"qrcode"];
                 
                 NSDictionary *dict = @{@"order_id":orderId, @"qrcode":qrcode};
                 if (dict)
                 {
                     TD_LOG(@"%@", dict);
                 }
                 
                 if (completionHandler) {
                     completionHandler(YES, nil, dict);
                 }
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
             TD_LOG(@"%@", error);
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }];
}

- (void) saveOrderWithOrderMomeny: (NSString *)ordermoney payMomney: (NSString *)payMomeny payType: (NSString *)payType goods: (NSArray *)goods completionHandler: (TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:ordermoney forKey:@"ordermoney"];
    [params setValue:payMomeny forKey:@"pay_money"];
    [params setValue:payType forKey:@"pay_type"];
    [params setValue:goods forKey:@"goods"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
         POST:@"saveorder"
         parameters:@{@"code":jsonString}
         progress:^(NSProgress *uploadProgress){}
         success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
             TD_LOG(@"%@", responseObject);
             NSDictionary *result = (NSDictionary *)responseObject;
             NSString *status = [result objectForKey:@"status"];
             if ([status isEqualToString:@"failed"])
             {
                 NSString *errorMsg = [result objectForKey:@"error_msg"];
                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                 [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:@"error" code:109 userInfo:details];
                 
                 if (completionHandler) {
                     completionHandler(NO, error, nil);
                 }
             }
             else
             {
                 if (completionHandler) {
                     completionHandler(YES, nil, nil);
                 }
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
             TD_LOG(@"%@", error);
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }];
}

- (void) checkorderWithId: (NSString *)orderId status: (NSString *)status completionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:orderId forKey:@"order_id"];
    [params setValue:status forKey:@"order_status"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
         POST:@"checkorder"
         parameters:@{@"code":jsonString}
         progress:^(NSProgress *uploadProgress){}
         success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
             TD_LOG(@"%@", responseObject);
             NSDictionary *result = (NSDictionary *)responseObject;
             NSString *status = [result objectForKey:@"status"];
             if ([status isEqualToString:@"failed"])
             {
                 NSString *errorMsg = [result objectForKey:@"error_msg"];
                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                 [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:@"error" code:110 userInfo:details];
                 
                 if (completionHandler) {
                     completionHandler(NO, error, nil);
                 }
             }
             else
             {
                 if (completionHandler) {
                     completionHandler(YES, nil, nil);
                 }
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
             TD_LOG(@"%@", error);
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }];
}

- (void) getStorelistWithCompletionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
         POST:@"storelist"
         parameters:@{@"code":jsonString}
         progress:^(NSProgress *uploadProgress){}
         success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
             TD_LOG(@"%@", responseObject);
             NSDictionary *result = (NSDictionary *)responseObject;
             NSString *status = [result objectForKey:@"status"];
             if ([status isEqualToString:@"failed"])
             {
                 NSString *errorMsg = [result objectForKey:@"error_msg"];
                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                 [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:@"error" code:111 userInfo:details];
                 
                 if (completionHandler) {
                     completionHandler(NO, error, nil);
                 }
             }
             else
             {
                 NSDictionary *storelist = [result objectForKey:@"storelist"];
                 
                 if (storelist)
                 {
                     TD_LOG(@"%@", storelist);
                 }
                 
                 if (completionHandler) {
                     completionHandler(YES, nil, storelist);
                 }
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
             TD_LOG(@"%@", error);
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }];
}

- (void) deliverToStoreId: (NSString *)toStore goods: (NSArray *)goods completionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:toStore forKey:@"tostore_id"];
    [params setValue:goods forKey:@"goods"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
         POST:@"dborder"
         parameters:@{@"code":jsonString}
         progress:^(NSProgress *uploadProgress){}
         success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
             TD_LOG(@"%@", responseObject);
             NSDictionary *result = (NSDictionary *)responseObject;
             NSString *status = [result objectForKey:@"status"];
             if ([status isEqualToString:@"failed"])
             {
                 NSString *errorMsg = [result objectForKey:@"error_msg"];
                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                 [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:@"error" code:112 userInfo:details];
                 
                 if (completionHandler) {
                     completionHandler(NO, error, nil);
                 }
             }
             else
             {
                 NSString *orderId = [result objectForKey:@"order_id"];
                 
                 if (orderId)
                 {
                     TD_LOG(@"%@", orderId);
                 }
                 
                 if (completionHandler) {
                     completionHandler(YES, nil, orderId);
                 }
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
             TD_LOG(@"%@", error);
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }];
}

- (void) checkdborderWithId:(NSString *)orderId completionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:orderId forKey:@"order_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
        POST:@"checkdborder"
        parameters:@{@"code":jsonString}
        progress:^(NSProgress *uploadProgress){}
        success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:113 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *orderId = [result objectForKey:@"order_id"];
             
             if (orderId)
             {
                 TD_LOG(@"%@", orderId);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, orderId);
             }
         }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
        }];
}

- (void) canceldborderbillWithId:(NSString *)orderId completionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:orderId forKey:@"order_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
        POST:@"canceldborderbill"
        parameters:@{@"code":jsonString}
        progress:^(NSProgress *uploadProgress){}
        success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:114 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *orderId = [result objectForKey:@"order_id"];
             
             if (orderId)
             {
                 TD_LOG(@"%@", orderId);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, orderId);
             }
         }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
        }];
}

- (void) getPendingdborderWithCompletionHandler: (TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"pendingdborder"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:115 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"order_list"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) searchdborderFormDate: (NSDate *)fromDate to: (NSDate *)toDate type: (NSString *)type status: (NSString *)status withCompletionHandler: (TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    
    NSString *from = [[TDHelper sharedInstance] date:fromDate formatedWithString:TDFormatDateString];
    NSString *to = [[TDHelper sharedInstance] date:toDate formatedWithString:TDFormatDateString];
    
    [params setValue:from forKey:@"begin"];
    [params setValue:to forKey:@"end"];
    [params setValue:type forKey:@"type"];
    [params setValue:status forKey:@"checked"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"searchdborder"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:116 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"order_list"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) getPendingrkorderWithCompletionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"pendingrkorder"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:117 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"order_list"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) checkrkorderWithId: (NSString *)orderId withCompletionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:orderId forKey:@"order_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"checkrkorder"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:118 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"order_id"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) getDborderinfoWithId: (NSString *)orderId withCompletionHander: (TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:orderId forKey:@"order_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"dborderinfo"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:119 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"order_info"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) getRkorderinfoWithId: (NSString *)orderId withCompletionHander: (TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:orderId forKey:@"order_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"rkorderinfo"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:120 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"order_info"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) serachticketWithType:(NSString *)type ticketNumber: (NSString *)tickeNumber completionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:type forKey:@"type"];
    [params setValue:tickeNumber forKey:@"number"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
        POST:@"serachticket"
        parameters:@{@"code":jsonString}
        progress:^(NSProgress *uploadProgress){}
        success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:121 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *description = [result objectForKey:@"ticket"];
             
             if (description)
             {
                 TD_LOG(@"%@", description);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, description);
             }
         }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
        }];
}

- (void) writeoffWithType:(NSString *)type ticketNumber: (NSString *)tickeNumber completionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:type forKey:@"type"];
    [params setValue:tickeNumber forKey:@"number"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
        POST:@"writeoff"
        parameters:@{@"code":jsonString}
        progress:^(NSProgress *uploadProgress){}
        success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:122 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             if (completionHandler) {
                 completionHandler(YES, nil, nil);
             }
         }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
        }];
}

- (void) addPdorderWithListData: (NSArray *)listData completionHandler: (TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:listData forKey:@"order_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"addpdorder"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:123 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"order_id"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) getPendingpdorderWithCompletionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"pendingpdorder"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:124 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"order_list"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) getPdorderinfoWithId: (NSString *)orderId WithCompletionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:orderId forKey:@"order_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"pdorderinfo"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:125 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"order_info"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) checkpdorder: (NSString *)orderId withCompletionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:orderId forKey:@"order_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"checkpdorder"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:126 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"order_id"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) recheckpdorderWithId: (NSString *)orderId withCompletionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:orderId forKey:@"order_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"recheckpdorder"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:127 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"order_id"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) searchpdorderFormDate: (NSDate *)fromDate to: (NSDate *)toDate status: (NSString *)status withCompletionHandler: (TDCompletionHandler)completionHandler;
{
    NSString *from = [[TDHelper sharedInstance] date:fromDate formatedWithString:TDFormatDateString];
    NSString *to = [[TDHelper sharedInstance] date:toDate formatedWithString:TDFormatDateString];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:from forKey:@"begin"];
    [params setValue:to forKey:@"end"];
    [params setValue:status forKey:@"checked"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"searchpdorder"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:128 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"order_list"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) searchgoodsWithBarcode: (NSString *)barcode orGoodsId: (NSString *)goodsId orGoodattrId: (NSString *)goodattr_id withCompletionHandler: (TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:barcode forKey:@"barcode"];
    [params setValue:goodsId forKey:@"goods_id"];
    [params setValue:goodattr_id forKey:@"goodattr_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"searchgoods"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:129 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"goods"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) lspaystatus: (NSString *)orderId withCompletionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    [params setValue:orderId forKey:@"order_id"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"lspaystatus"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:127 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSString *res = [result objectForKey:@"pay_status"];
             
             if (res)
             {
                 TD_LOG(@"%@", res);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, res);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

- (void) getUncheckorderlistWithCompletionHandler:(TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.userId forKey:@"userid"];
    
    NSString *jsonString = [params jsonStringWithPrettyPrint: NO];
    
    [self.manager
     POST:@"uncheckorder"
     parameters:@{@"code":jsonString}
     progress:^(NSProgress *uploadProgress){}
     success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
         TD_LOG(@"%@", responseObject);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *status = [result objectForKey:@"status"];
         if ([status isEqualToString:@"failed"])
         {
             NSString *errorMsg = [result objectForKey:@"error_msg"];
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:@"error" code:111 userInfo:details];
             
             if (completionHandler) {
                 completionHandler(NO, error, nil);
             }
         }
         else
         {
             NSDictionary *storelist = [result objectForKey:@"order_list"];
             
             if (storelist)
             {
                 TD_LOG(@"%@", storelist);
             }
             
             if (completionHandler) {
                 completionHandler(YES, nil, storelist);
             }
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
         TD_LOG(@"%@", error);
         if (completionHandler) {
             completionHandler(NO, error, nil);
         }
     }];
}

@end
