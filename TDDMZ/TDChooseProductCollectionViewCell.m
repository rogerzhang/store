//
//  TDChooseProductCollectionViewCell.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/10/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDChooseProductCollectionViewCell.h"

@implementation TDChooseProductCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void) prepareForReuse;
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
    self.label.text = nil;
}

@end
