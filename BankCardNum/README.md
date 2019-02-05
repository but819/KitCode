### 1.前言

对于当下很多App来说，业务场景或多或少都会牵涉到银行卡，一般都会有绑定银行卡的场景。输入框普遍都是以四位为一组的格式进行显示，例如`1111 1111 1111 1111 111`。以下是使用`UITextField`做的一些尝试。

### 2.解决思路

#### 2.1 设置UITextField代理

我们需要知道用户每次输入的情况，首先就需要监听`UITextField`的代理`UITextFieldDelegate`方法。

首先设置`UITextField`代理

```    
self.bankCardInput.delegate = self;
```

其次再监听输入变化代理方法。

```
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string { 
    return YES;
}
```

代理方法说明。

- textField
    - 输入控件
- range
    - 输入框内要被替换的文字起点与文字长度
- string
    - 用户将要输入的内容
- return
    - YES:接收用户输入内容
    - NO:忽略用户输入内容

#### 2.2 控制用户输入类型

银行卡输入框键盘一般都是以数字键盘`UIKeyboardTypeNumberPad(UIKeyboardType)`为主，或者有特殊要求的是其他类型。

不管输入键盘的类型，对于实际情况银行卡的输入，只能接收数字，所以我们必须要做一个非法字符过滤的逻辑，控制输入字符只能是数字，如果不是则不进行操作并且忽略用户输入。

``` 
//可接收字符串类型，\b是删除符的意思
NSCharacterSet *canInputSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];

//确保输入内容有效
if ([string rangeOfCharacterFromSet:[canInputSet invertedSet]].location != NSNotFound) {
    return NO;
}
```

#### 2.3 处理用户输入后的内容

确认用户输入内容合法之后，则需要提取用户输入后的内容。通过入参的`range`来获取用户最后输入后的字符串。

由于我们每4位数字的间隔是通过**追加空格符**来是实现的。所以我们处理最后的字符前，需要去除所有空格才是用户修改后真正的银行卡号。

```
//原本的数据
NSString *baseStr = textField.text;
    
//操作后的数据
NSString *replaceStr = [baseStr stringByReplacingCharactersInRange:range withString:string];

//重新格式化数字
NSString *lastStr = [self getFormatBankCardNum:bankCardStr];
```

去除空格函数

```
+(NSString *)getBankCardNumFromFormatStr:(NSString *)baseStr{
    baseStr = [baseStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return baseStr;
}
```

#### 2.4 重新格式化修改后的银行卡号

拿到最后的银行卡后，就可以用作重新格式化的字符串。整个流程是：

通过字符串截取方式生成新的格式化字符，具体是以4位作为一组进行截取，如果少于4位则通过可用字符串长度进行截取，直到整个字符串截取完毕。

在截取过程，如果截取位数为4位则在新字符串后追加一个空格。

得出最后结果后，还需要通过去除新的格式化字符串**前后**不需要的内容（数字以外的内容）。

```
//按照四位为一组的形式格式化银行卡号
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
```

#### 2.5 光标处理

设置了新字符到`UITextField`后，由于用户新编辑导致，可能会导致光标会错乱，所以需要重新调整光标位置。

先提取原来输入框内光标右侧的字符，去除空格后，得出纯数字，用作计算光标右边有效字符所用。

再计算新字符对应光标位置，用**2.3**中最后修改的银行卡号算出整个卡号数字该有的空格数，再通过减去光标右边有效字符数计算得出光标左边该有的空格数，将两个空格数相减就是光标右边该有的空格数。

再加上原本光标右侧的有效数字，就是新字符光标从右往左，光标移动步数。

这么说可能有点复杂，举个例子一步一步说明会比较好理解，我们就举用户在中间输入的例子来说。

用户已经输入内容如下，光标在最后

```
1234 1234 1|
```

用户将要在第二个1后输入内容，光标如下，而将要输入内容是7890。

```
1234 1|234 1
```

输入后的最新光标应该在7890的0后面

```
1234 1789 0|234 1
```

处理数据逻辑流程

```
原本内容：1234 1234 1
格式化后：123412341

原光标右：234 1
格式化后：2341

插入内容：1234 1789 0234 1
格式化后：1234178902341
总空格数：3个

除去右边：123417890
应有格数：2个

右边字数：2341->4个
右边格数：3-2=1
右边光标：从右往左移动4+1个单位
```

关键逻辑代码如下
```

//计算不带空格的卡号按照四位为一组得出可分割组数
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
```

#### 2.6 设置光标

在**2.5**获取光标位置后，还需要设置到`UITextField`中，由于`UITextField`没有直接设置光标位置的函数，但可以通过`setSelectedTextRange`设置选择位置。其实此方法是设置选择一段文字的方法，但是可以通过设置选取字符长度为0即可达到移动光标的效果。因此封装了一个方法，方便直接通过`NSRange`设置`UITextField`光标。

```
//通过NSRange设置setSelectedTextRange
- (void)setSelectedRange:(NSRange)range{
    
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}
```

有了封装方法后，就到了真正设置的步骤：由于在**2.4**中已经处理并设置了最新输入的用户输入值。所以`textField.text`已经是最新的值了。

然后我们用最新值的长度减去**2.5**中计算出光标右边该有字符长度的值，就是光标最新的位置。

但是可以想象一下，重新设置光标后，我们的光标有可能是在空格的后面，建议遇到这种情况直接让光标再往前移一位以提升体验。

```
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
```

### 3.复制粘贴出现的问题

从效果上看上去，格式化跟光标定位好像没问题，但是发现在用户发生复制粘贴的场景下，光标会在不同情况下发生错乱，测试得出，是因为设置不同的键盘方式所引起的。

由于我们每隔四位数字会手动追加一个空格，但是对于数字键盘来说，是不支持输入空格，所以假如遇到以下情况，是会发生问题的。

```
//原本已输入
1234 1

//在其他地方复制的数字
9876

//在原来输入框发起粘贴后理论效果
1234 1987 61|

//在原来输入框发起粘贴后实际效果
1234 1987 6|1
```

根本原因就是上面所说的，被复制的字符个数是四位，在原来输入的地方（**1234 1**）粘贴**9876**会因为格式而追加一个空格，字符个数变成五个，导致超过复制字符个数，并且粘贴出来的字符不支持原键盘，所以导致光标不在期待位置上。

> 解决方案1

将`UIKeyboardType`改成支持空格的类型，一般对于银行卡业务，大家都是选择数字键盘，但也有特殊情况，因为上面有介绍过滤非数字的方法，所以可以根据自身情况进行斟酌。

> 解决方案2

在设置了数字键盘的情况下，遇到复制粘贴时，则通过延时重设一次光标。但要注意的是，如果延时过长会看出光标连续跳转的情况，所以我采用了零延时设置。

```
//用户发生粘贴的情况
if ([string isEqualToString:[UIPasteboard generalPasteboard].string]) {
    //0延时重设一次光标
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField setSelectedRange:newRange];
    });
}
```