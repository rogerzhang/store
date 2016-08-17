//
//  TDScanView.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/15/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDScanView.h"

@implementation TDScanView

- (IBAction)okAction:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(okAction:)]) {
        [self.delegate okAction: self];
    }
}

- (IBAction)scanAction:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(scanAction:)]) {
        [self.delegate scanAction: self];
    }
}

@end
