//
//  TDOrderDetailTableViewCell.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 17/10/2016.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDOrderDetailTableViewCell.h"

@implementation TDOrderDetailTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void) prepareForReuse;
{
    [super prepareForReuse];
    
    self.label1.text = nil;
    self.label2.text = nil;
    self.label3.text = nil;
    self.label4.text = nil;
    self.label5.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
