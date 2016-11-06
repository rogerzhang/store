//
//  TDOrderCollectionViewCell.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/28/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDOrderCollectionViewCell.h"

@implementation TDOrderCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.label7.text = nil;
}

- (IBAction)orderDetail:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(orderDetailAction:)]) {
        [self.delegate orderDetailAction: self];
    }
}

- (IBAction)orderOK:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(orderOKAction:)]) {
        [self.delegate orderOKAction: self];
    }
}

@end
