//
//  TDCategory.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/1/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDCategory : NSObject
@property (nonatomic, strong) NSString *cat_id;
@property (nonatomic, strong) NSString *cat_name;
@property (nonatomic, assign) BOOL children;
@end
