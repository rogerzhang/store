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
    });
    
    return client;
}

- (void)loginWithAccount: (NSString *)account password: (NSString *)password completionHandler: (TDCompletionHandler)completionHandler;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:account forKey:@"user"];
    [params setValue:password forKey:@"pwd"];
    
    [self.manager
        POST:@"login"
        parameters:params
        progress:^(NSProgress *uploadProgress){}
        success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
            NSLog(@"%@", responseObject);
            NSDictionary *result = (NSDictionary *)responseObject;
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"failed"])
            {
                NSString *errorMsg = [result objectForKey:@"error_msg"];
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"error" code:101 userInfo:details];
                
                if (completionHandler) {
                    completionHandler(NO, error);
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
                    completionHandler(YES, nil);
                }
            }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
            NSLog(@"%@", error);
            if (completionHandler) {
                completionHandler(NO, error);
            }
        }];
}

- (void) logoutWithCompletionHandler: (TDCompletionHandler)completionHandler;
{
    self.userName = nil;
    self.storeName = nil;
    self.userId = nil;
    
    if (completionHandler) {
        completionHandler(YES, nil);
    }
}

@end
