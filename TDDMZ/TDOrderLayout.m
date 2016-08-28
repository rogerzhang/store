//
//  TDOrderLayout.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/28/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDOrderLayout.h"

@implementation TDOrderLayout

- (id) init;
{
    self = [super init];
    
    if (self)
    {
        [self setScrollDirection: UICollectionViewScrollDirectionVertical];
        self.itemSize = CGSizeMake (0.1, 0.1);
        self.sectionInset = UIEdgeInsetsMake(100, 100, 0, 100);
        self.minimumLineSpacing = 80;
        self.minimumInteritemSpacing = 10;
    }
    
    return self;
}

@end
