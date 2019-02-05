//
//  UITextField+BankCardInput.h
//  BankCardNum
//
//  Created by but-MacBook on 2019/1/30.
//  Copyright © 2019 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (BankCardInput)

+ (BOOL)bankCardInputTextField:(UITextField *)textField
 shouldChangeCharactersInRange:(NSRange)range
             replacementString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
