//
//  TDUnCountingHeader.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 18/10/2016.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDUnCountingHeader : UITableViewHeaderFooterView
@property (nonatomic, strong) NSMutableArray *labels;
- (void) setAttributes: (NSArray *)attrs;
@end
