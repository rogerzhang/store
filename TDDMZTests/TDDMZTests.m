//
//  TDDMZTests.m
//  TDDMZTests
//
//  Created by Roger (Wei) Zhang on 8/1/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TDParser.h"
#import "TDGood.h"
#import "TDStore.h"
#import "TDCategory.h"

@interface TDDMZTests : XCTestCase
@property(nonatomic, strong) TDParser *parser;
@end

@implementation TDDMZTests

- (void)setUp {
    [super setUp];
    self.parser = [TDParser new];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSDictionary *dict = @ {
        @"goods_id": @(12381),
        @"goodattr_id": @(12381),
        @"goods_sn": @"100045",
        @"goods_name": @"灰色立领衬衫",
        @"goods_attr": @"",
        @"shop_price": @"200.00",
        @"goods_img": @"http://dev.dmuzhi.cn/uploads/goods/2542/FEKFElVs6H/1469711166165.jpg"
    };
    
    TDGood *good = [self.parser goodWithDictionary: dict];
    
    
    NSLog(@"%@", good);
    
    NSDictionary *dic = [self.parser dictionaryWithGood:good];
    
    NSLog(@"%@", dic);
    
    NSDictionary *dt = @{
        @"cat_id":@(538),
        @"cat_name": @"Polo衫和T恤",
        @"children": @[
                     @{
                         @"cat_id":@(552),
                         @"cat_name": @"短袖T恤",
                         @"children": @[]
                     },
                     @{
                         @"cat_id":@(553),
                         @"cat_name": @"长袖T恤",
                         @"children":@[]
                     }
                     ]
        };
    
    TDCategory *cat = [self.parser categoryWithDictionary:dt];
    
    if (cat) {
        NSLog(@"");
    }
    
    TDCategory *c1 = [TDCategory new];
    c1.cat_name = @"n1";
    c1.cat_id = @"1";
    
    TDCategory *c2 = [TDCategory new];
    c2.cat_name = @"n2";
    c2.cat_id = @"2";
    
    TDCategory *c = [TDCategory new];
    c.cat_name = @"n";
    c.cat_id = @"0";
    c.children = @[c1, c2];
    
    dict = [self.parser dictionaryWithCategory:c];
    
    NSError *writeError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:c options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", result);
    
    NSLog(@"%@", dict);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
