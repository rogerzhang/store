//
//  TDProductPreviewTableViewCell.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/23/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDProductPreviewTableViewCell;

@protocol TDProductPreviewTableViewCellDelegate <NSObject>

- (void) countDidChanged: (TDProductPreviewTableViewCell *)cell;

@end

@interface TDProductPreviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (assign, nonatomic) NSInteger count;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) NSObject<TDProductPreviewTableViewCellDelegate> *delegate;
@end
