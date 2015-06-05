//
//  CurrencyExchange.h
//  iExchange
//
//  Created by JIN on 15/6/5.
//  Copyright (c) 2015年 JIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyExchange : NSObject

@property (nonatomic, strong) NSString *localeCurrencyCode;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *currencySymbol;
@property (nonatomic, strong) NSDecimalNumber *exchangeRate;

-(void)configureForCurrency;

@end
