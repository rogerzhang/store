//
//  NSDictionary+TDConvertToJson.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/29/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "NSDictionary+TDConvertToJson.h"

@implementation NSDictionary (TDConvertToJson)

-(NSString*)jsonStringWithPrettyPrint:(BOOL) prettyPrint
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:self
                            options:(NSJSONWritingOptions)    (prettyPrint ?
                            NSJSONWritingPrettyPrinted : 0)
                            error:&error];
    
    if (! jsonData)
    {
        TD_LOG(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
