//
//  TDSaveBanner.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/23/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDSaveBanner.h"

@implementation TDSaveBanner

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self showLabel: NO];
    }
    
    return self;
}

- (void) layoutSubviews;
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGPoint center = self.key1Label.center;
    center.y = bounds.size.height / 2.0f;
    self.key1Label.center = center;
    
    center = self.key2Label.center;
    center.y = bounds.size.height / 2.0f;
    self.key2Label.center = center;
    
    center = self.value1Label.center;
    center.y = bounds.size.height / 2.0f;
    self.value1Label.center = center;
    
    center = self.value2Label.center;
    center.y = bounds.size.height / 2.0f;
    self.value2Label.center = center;
    
    center = self.saveButton.center;
    center.y = bounds.size.height / 2.0f;
    self.saveButton.center = center;
}

- (void) showLabel: (BOOL)show;
{
    self.key1Label.hidden = !show;
    self.value1Label.hidden = !show;
    self.key2Label.hidden = !show;
    self.value2Label.hidden = !show;
}

- (IBAction)saveAction:(id)sender {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
