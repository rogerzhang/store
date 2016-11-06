//
//  TDOrderCollectionViewCell.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/28/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDOrderCollectionViewCell;

@protocol TDOrderCollectionViewCellDeleagate <NSObject>

- (void) orderDetailAction: (TDOrderCollectionViewCell*)cell;
- (void) orderOKAction: (TDOrderCollectionViewCell*)cell;

@end

@interface TDOrderCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (weak, nonatomic) NSObject<TDOrderCollectionViewCellDeleagate> *delegate;

@end
