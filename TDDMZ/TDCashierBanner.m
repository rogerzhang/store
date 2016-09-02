//
//  TDCashierBanner.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/23/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDCashierBanner.h"

@implementation TDCashierBanner

- (void) layoutSubviews;
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGPoint center = self.label.center;
    center.y = bounds.size.height / 2.0f;

    self.label.center = center;
    
    center = self.gdButton.center;
    center.y = bounds.size.height / 2.0f;
    self.gdButton.center = center;
    
    center = self.jsButton.center;
    center.y = bounds.size.height / 2.0f;
    self.jsButton.center = center;
    
    center = self.dsButton.center;
    center.y = bounds.size.height / 2.0f;
    self.dsButton.center = center;
}

- (IBAction)hold:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(holdListAction:)]) {
        [self.delegate holdListAction:self];
    }
}

- (IBAction)customerSettlementAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(customerSettlementAction:)]) {
        [self.delegate customerSettlementAction:self];
    }
}

- (IBAction)userSettlementAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(userSettlementAction:)]) {
        [self.delegate userSettlementAction:self];
    }
}

@end
