//
//  CollectionViewCell.h
//  iExchange
//
//  Created by JIN on 15/6/5.
//  Copyright (c) 2015年 JIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *currencyCodeLabel;

@end
