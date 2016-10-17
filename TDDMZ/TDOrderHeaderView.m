//
//  TDOrderHeaderView.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 17/10/2016.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDOrderHeaderView.h"

@interface TDOrderHeaderView ()

@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation TDOrderHeaderView

- (void) prepareForReuse;
{
    [super prepareForReuse];
    
    for (UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    
    [self.labels removeAllObjects];
}

- (void) setAttributes: (NSArray *)attrs;
{
    if (!self.labels) {
        self.labels = [NSMutableArray new];
    }
    
    for (UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    
    [self.labels removeAllObjects];
    
    for (NSInteger i = 0; i < attrs.count; i++) {
        NSString *attr = attrs[i];
        UILabel *label = [UILabel new];
        label.text = attr;
        label.textAlignment = NSTextAlignmentCenter;
        
        CGFloat w = 70;
        CGFloat h = 44;
        CGFloat x = 44 + [self gap] + i * ([self gap] + w);
        CGFloat y = 0;
        
        label.frame = CGRectMake(x, y, w, h);
        [self addSubview:label];
    }
}

- (CGFloat) gap;
{
    return 40;
}

@end
