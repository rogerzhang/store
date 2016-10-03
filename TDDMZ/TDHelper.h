//
//  TDHelper.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/27/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDHelper : NSObject

+ (instancetype) sharedInstance;

- (NSString *) dateFormatedString;
- (NSString *) date: (NSDate *)date formatedWithString: (NSString *const)formatString;

@end
