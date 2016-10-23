//
//  TDUncountTableViewCell.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 18/10/2016.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDUncountTableViewCell.h"

@implementation TDUncountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)button1Action:(id)sender {
    if ([self.delegate respondsToSelector:@selector(button1Action:)]) {
        [self.delegate button1Action: self];
    }
}
- (IBAction)button2Action:(id)sender {
    if ([self.delegate respondsToSelector:@selector(button2Action:)]) {
        [self.delegate button2Action: self];
    }
}

@end
