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
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation TDSearchGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.scrollView = [[UIScrollView alloc] init];
    [self.contentView addSubview:self.scrollView];
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
    
    CGRect frame = self.contentView.bounds;
    frame.origin.x = CGRectGetMaxX(self.attr1Label.frame);
    frame.size.width = frame.size.width - frame.origin.x;
    self.scrollView.frame = frame;
    
    [self.labels removeAllObjects];
    
    for (NSString *key in allkeys) {
        UILabel *label = [UILabel new];
        NSNumber *number = attrs[key];
        NSString *text = [NSString stringWithFormat:@"%ld", (long)[number integerValue]];
        label.text = text;
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.scrollView addSubview:label];
        
        CGFloat index = [allkeys indexOfObject:key];
        
        CGFloat w = 50;
        CGFloat h = self.frame.size.height;
        CGFloat x = [self gap] + index * ([self gap] + w);
        CGFloat y = 0;

        label.frame = CGRectMake(x, y, w, h);
        
        [self.labels addObject:label];
    }
    
    CGFloat w = 50;
    CGFloat cw = [self gap] + allkeys.count * ([self gap] + w);
    self.scrollView.contentSize = CGSizeMake(cw, frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
