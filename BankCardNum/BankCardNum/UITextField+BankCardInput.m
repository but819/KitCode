//
//  UITextField+BankCardInput.m
//  BankCardNum
//
//  Created by but-MacBook on 2019/1/30.
//  Copyright © 2019 xxx. All rights reserved.
//

#import "UITextField+BankCardInput.h"

@implementation UITextField (BankCardInput)

//处理方法
+ (BOOL)bankCardInputTextField:(UITextField *)textField
       shouldChangeCharactersInRange:(NSRange)range
                   replacementString:(NSString *)string{
    

    //可用字符串
    NSCharacterSet *canInputSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    
    //去除多余空格
    string = [self getBankCardNumFromFormatStr:string];
    
    //确保输入内容有效
    if ([string rangeOfCharacterFromSet:[canInputSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    //原本的数据
    NSString *baseStr = textField.text;
    
    //操作后的数据
    NSString *replaceStr = [baseStr stringByReplacingCharactersInRange:range withString:string];

    //操作后的数据格式化（去除空格）
    NSString *bankCardStr = [self getBankCardNumFromFormatStr:replaceStr];
    
    //重新格式化数字
    NSString *lastStr = [self getFormatBankCardNum:bankCardStr];
    
    //超过限定显示逻辑
    if (lastStr.length<24) {
        //设置字符串
        [textField setText:lastStr];
    }
    
    //获取原本光标右边字符
    NSString *rightStr = [baseStr substringFromIndex:range.location+range.length];
    
    //获取光标右边有效数字（去除空格）
    NSString *rightNumStr = [self getBankCardNumFromFormatStr:rightStr];

    //新光标后字符长度
    NSInteger rightStrNum = [self getCursorRightStrLengthWithBankCardNumLength:bankCardStr.length
                                                              AndRightNumCount:rightNumStr.length];
    
    //创建光标(预测光标)
    NSRange newRange = NSMakeRange(textField.text.length - rightStrNum, 0);
    
    //光标前字符
    NSRange cursorLeftRange = NSMakeRange(newRange.location - 1, 1);

    //遇到空格则往前移一位
    if (newRange.location > 0) {
        //获取光标前一个字符
        NSString *cursorLeftStr = [textField.text substringWithRange:cursorLeftRange];
        if ([cursorLeftStr isEqualToString:@" "]) {
            newRange.location = newRange.location - 1;
        }
    }
    
    //设置光标
    [textField setSelectedRange:newRange];

    //用户发生粘贴的情况
    if ([string isEqualToString:[UIPasteboard generalPasteboard].string]) {
        //0延时重设一次光标
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [textField setSelectedRange:newRange];
        });
    }
    
    return NO;
}

//按照四位为一组的格式化银行卡号
+(NSString *)getFormatBankCardNum:(NSString *)bankCardNum{
   
    NSString *result = @"";
   
    while (bankCardNum.length > 0) {
        
        //提取可用字符
        NSString *sub = [bankCardNum substringToIndex:MIN(bankCardNum.length, 4)];
        
        //追加字符
        result = [result stringByAppendingString:sub];
        
        //如果是4位则在后面追加空格
        if (sub.length == 4) {
            result = [result stringByAppendingString:@" "];
        }
        //提取后面元素，作为要处理字符
        bankCardNum = [bankCardNum substringFromIndex:MIN(bankCardNum.length, 4)];
    }
    
    //去除不需要字符
    NSCharacterSet *canInputSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];

    result = [result stringByTrimmingCharactersInSet:[canInputSet invertedSet]];

    return result;
}


//替换所有空格
+(NSString *)getBankCardNumFromFormatStr:(NSString *)baseStr{
    baseStr = [baseStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return baseStr;
}

//计算不带空格的卡号按照四位为一组可分割组数
+(NSInteger)getGroupCount:(NSInteger)length{
    return (NSInteger)ceilf((CGFloat)length /4);
}

//获取新字符光标右边字符数长度
//右边总字符数=原右边字符串长度+右边应有空格数
//右边应有空格数=总字符应有空格-光标左边剩余字符空格
+(NSInteger)getCursorRightStrLengthWithBankCardNumLength:(NSInteger)toTalLength AndRightNumCount:(NSInteger)rightNumCount{
    
    //所有空格数
    NSInteger totalGroupCount = [self getGroupCount:toTalLength];
    
    //原光标左边空格数
    NSInteger leftGroupCount = [self getGroupCount:toTalLength - rightNumCount];
    
    //调节
    NSInteger totalSpaces = 0;
    if (totalGroupCount -1 > 0) {
        totalSpaces = totalGroupCount -1;
    }
    
    //调节
    NSInteger leftSpaces = 0;
    if (leftGroupCount -1 > 0) {
        leftSpaces = leftGroupCount -1;
    }
    
    //右边总字符数+右边总空格数
    return rightNumCount + (totalSpaces - leftSpaces);
}

//通过NSRange设置setSelectedTextRange
- (void)setSelectedRange:(NSRange)range{
    
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

@end
