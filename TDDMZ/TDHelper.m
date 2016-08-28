//
//  TDHelper.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/27/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDHelper.h"

@interface TDHelper()

@property (nonatomic, strong) NSDateFormatter *outputFormatter;

@end

@implementation TDHelper

+ (instancetype) sharedInstance;
{
    static TDHelper *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [TDHelper new];
    });
    
    return sharedInstance;
}

- (instancetype) init;
{
    self = [super init];
    
    if (self) {
        self.outputFormatter = [[NSDateFormatter alloc] init];
    }
    
    return self;
}

- (NSString *) dateFormatedString;
{
    NSDate *date = [NSDate date];
    [self.outputFormatter setLocale:[NSLocale currentLocale]];
    [self.outputFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *str = [self.outputFormatter stringFromDate:date];
    return str;
}

@end
