//
//  TDSearchGoodsTableViewCell.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 10/7/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDSearchGoodsTableViewCell.h"
@interface TDSearchGoodsTableViewCell()
@property (nonatomic, strong) NSMutableArray *labels;
@end

@implementation TDSearchGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) prepareForReuse;
{
    [super prepareForReuse];
    
    for (UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    
    [self.labels removeAllObjects];
}

- (CGFloat) gap;
{
    return 40;
}

- (void) setAttributes: (NSDictionary *)attrs keys: (NSArray *)keys;
{
    NSArray *allkeys = keys;
    
    if (!self.labels) {
        self.labels = [NSMutableArray new];
    }
    
    for (UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    
    [self.labels removeAllObjects];
    
    for (NSString *key in allkeys) {
        UILabel *label = [UILabel new];
        NSNumber *number = attrs[key];
        NSString *text = [NSString stringWithFormat:@"%ld", [number integerValue]];
        label.text = text;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        CGFloat index = [allkeys indexOfObject:key];
        
        CGFloat w = 50;
        CGFloat h = self.frame.size.height;
        CGFloat x = CGRectGetMaxX(self.attr1Label.frame) + [self gap] + index * ([self gap] + w);
        CGFloat y = 0;

        label.frame = CGRectMake(x, y, w, h);
        
        [self.labels addObject:label];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
