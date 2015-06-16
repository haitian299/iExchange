//
//  AmountLabel.m
//  iExchange
//
//  Created by JIN on 15/6/12.
//  Copyright (c) 2015年 JIN. All rights reserved.
//

#import "AmountLabel.h"
#import "CollectionViewController.h"

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
    if ([self.text isEqualToString:@"0"]) {
        self.text = @"";
    }
    self.text = [self.text stringByAppendingString:text];
    [self notificationMethod:self];
}

- (void)deleteBackward {
    if (self.text.length == 0 || [self.text isEqualToString:@"0"]) {
        return;
    }
    NSRange range = NSMakeRange(self.text.length - 1, 1);
    self.text = [self.text stringByReplacingCharactersInRange:range withString:@""];
    if (self.text.length == 0) {
        self.text = @"0";
    }
    [self notificationMethod:self];
}

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeDecimalPad;
}

#pragma NotificationCenter for passing amount

- (IBAction)notificationMethod:(id)sender {
    if (self.text.length > 0) {
        NSLog(@"success");
        NSLog(@"current thread in notification1: %@", [NSThread currentThread]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PassAmountNotification" object:self userInfo:@{@"amount":self.text}];
        NSLog(@"%@", self);
        NSLog(@"current thread in notification2: %@", [NSThread currentThread]);
        [self becomeFirstResponder];
    }
}


@end
