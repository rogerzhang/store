//
//  TDInfoButton.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 16/10/2016.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDInfoButton.h"

@implementation TDInfoButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) layoutSubviews;
{
    [super layoutSubviews];
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.cornerRadius = 3;
}

@end
