//
//  TDChooseProductLayout.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 9/10/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDChooseProductLayout.h"

@implementation TDChooseProductLayout

- (id) init;
{
    self = [super init];
    
    if (self)
    {
        [self setScrollDirection: UICollectionViewScrollDirectionVertical];
        self.itemSize = CGSizeMake (0.1, 0.1);
        self.sectionInset = UIEdgeInsetsMake(10, 40, 0, 40);
        self.minimumLineSpacing = 20;
        self.minimumInteritemSpacing = 10;
    }
    
    return self;
}

@end
