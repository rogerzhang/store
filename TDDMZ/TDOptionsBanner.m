//
//  TDOptionsBanner.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/25/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDOptionsBanner.h"

@implementation TDOptionsBanner

- (IBAction)buttonAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(getStoreListAction:)])
    {
        [self.delegate getStoreListAction: self];
    }
}

@end
