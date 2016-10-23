//
//  TDUncountTableViewCell.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 18/10/2016.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TDUncountTableViewCell;

@protocol TDUncountTableViewCellDelegate <NSObject>

- (void)button1Action:(TDUncountTableViewCell *)cell;
- (void)button2Action:(TDUncountTableViewCell *)cell;

@end

@interface TDUncountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *labe16;
@property (weak, nonatomic) IBOutlet UILabel *label8;
@property (weak,nonatomic) NSObject<TDUncountTableViewCellDelegate> *delegate;
@end
