//
//  CollectionViewCell.m
//  iExchange
//
//  Created by JIN on 15/6/5.
//  Copyright (c) 2015年 JIN. All rights reserved.
//

#import "CollectionViewCell.h"
#import "CurrencyExchange.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)configureForCell:(CurrencyExchange *)currenyExchange {
    self.currencyNameLabel.text = currenyExchange.currencyName;
    self.label.text = [NSString stringWithFormat:@"%@", currenyExchange.exchangeRate];
}

@end
