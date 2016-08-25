//
//  TDItemsBar.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/18/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDItemsBar.h"

@implementation TDItemsBar

- (instancetype) initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        self.chooseGoodButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.chooseGoodButton setTitle: @"选择商品" forState: UIControlStateNormal];
        [self.chooseGoodButton setTitle: @"选择商品" forState: UIControlStateSelected];
        [self.chooseGoodButton setTitleColor: RGBColor(47,47,47) forState:UIControlStateNormal];
        [self.chooseGoodButton setTitleColor: RGBColor(237,84,22) forState:UIControlStateSelected];
        self.chooseGoodButton.frame = CGRectMake(0, 0, frame.size.width / 2, frame.size.height);
        [self.chooseGoodButton addTarget:self action:@selector(tapChooseGoodAction:) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: self.chooseGoodButton];
        self.chooseGoodButton.showsTouchWhenHighlighted = YES;
        
        self.chooseScanerButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.chooseScanerButton setTitle: @"选择扫码" forState: UIControlStateNormal];
        [self.chooseScanerButton setTitle: @"选择扫码" forState: UIControlStateSelected];
        [self.chooseScanerButton setTitleColor: RGBColor(47,47,47) forState:UIControlStateNormal];
        [self.chooseScanerButton setTitleColor: RGBColor(237,84,22) forState:UIControlStateSelected];
        [self.chooseScanerButton setTitleShadowColor: [UIColor greenColor] forState: UIControlStateSelected];
        [self.chooseScanerButton addTarget:self action:@selector(tapChooseScanerAction:) forControlEvents: UIControlEventTouchUpInside];
        CGFloat dx = frame.size.width / 2;
        self.chooseScanerButton.frame = CGRectMake(dx, 0, frame.size.width / 2, frame.size.height);
        [self addSubview: self.chooseScanerButton];
        self.chooseScanerButton.showsTouchWhenHighlighted = YES;
        self.chooseScanerButton.selected = YES;
    }
    
    return self;
}

- (void) layoutSubviews;
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    self.chooseGoodButton.frame = CGRectMake(0, 0, bounds.size.width / 2, bounds.size.height);
    CGFloat dx = bounds.size.width / 2;
    self.chooseScanerButton.frame = CGRectMake(dx, 0, bounds.size.width / 2, bounds.size.height);
}

- (IBAction) tapChooseGoodAction: (id)sender;
{
    [self chooseButton: sender];
    if ([self.delegate respondsToSelector:@selector(chooseGoodButtonAction:)]) {
        [self.delegate chooseGoodButtonAction: self];
    }
}

- (IBAction) tapChooseScanerAction: (id)sender;
{
    [self chooseButton: sender];
    if ([self.delegate respondsToSelector:@selector(chooseScanerButtonAction:)]) {
        [self.delegate chooseScanerButtonAction: self];
    }
}

- (void) chooseButton: (UIButton *)button;
{
    self.chooseGoodButton.selected = button == self.chooseGoodButton;
    self.chooseScanerButton.selected = button == self.chooseScanerButton;
}

@end
