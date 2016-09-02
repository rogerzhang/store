//
//  TDProductPreviewTableViewCell.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/23/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDProductPreviewTableViewCell.h"

@implementation TDProductPreviewTableViewCell

- (void)prepareForReuse;
{
    [super prepareForReuse];
    self.count = 1;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.count = 1;
}

- (void)setCount:(NSInteger)count;
{
    _count = count;
    [self update];
}

- (void)update;
{
    self.countLabel.text = [NSString stringWithFormat:@"%ld", self.count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)addAction:(id)sender
{
    self.count++;
}

- (IBAction)reduceAction:(id)sender
{
    if (self.count < 0) {
        return;
    }
    self.count--;
}

@end
