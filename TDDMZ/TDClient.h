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

typedef void (^TDCompletionHandler) (BOOL success, NSError *error);

@interface TDClient : NSObject

@property (nonatomic, readonly, strong) NSString *userId;
@property (nonatomic, readonly, strong) NSString *userName;
@property (nonatomic, readonly, strong) NSString *storeName;
@property (nonatomic, readonly, strong) AFHTTPSessionManager *httpSessionManager;

+ (instancetype) sharedInstance;

- (void)loginWithAccount: (NSString *)account password: (NSString *)password completionHandler: (TDCompletionHandler)completionHandler;
- (void) logoutWithCompletionHandler: (TDCompletionHandler)completionHandler;

@end
