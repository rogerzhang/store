//
//  NSDictionary+TDConvertToJson.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/29/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (TDConvertToJson)
-(NSString*)jsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end
