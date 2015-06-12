//
//  AmountLabel.m
//  iExchange
//
//  Created by JIN on 15/6/12.
//  Copyright (c) 2015年 JIN. All rights reserved.
//

#import "AmountLabel.h"

@implementation AmountLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

- (BOOL)hasText {
    return self.text.length >0;
}

- (void)insertText:(NSString *)text {
    self.text = [self.text stringByAppendingString:text];
}

- (void)deleteBackward {
    if (self.text.length == 0) {
        return;
    }
    NSRange range = NSMakeRange(self.text.length - 1, 1);
    self.text = [self.text stringByReplacingCharactersInRange:range withString:@""];
}

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

@end
