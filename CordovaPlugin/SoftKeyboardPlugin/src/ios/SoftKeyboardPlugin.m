//
//  CDVSoftKeyboardPlugin.m
//  weather
//
//  Created by mac on 14-9-18.
//
//

#import "SoftKeyboardPlugin.h"


@implementation SoftKeyboardPlugin


- (void)show:(CDVInvokedUrlCommand *)command
{
    NSLog(@"CDVSoftKeyboardPlugin---show");
    
    //关闭输入法
    [[UIApplication sharedApplication] sendAction:@selector(canResignFirstResponder) to:nil from:nil forEvent:nil];

    // 整合为显示内容
    NSDictionary *result;
    // 压入数据
    result = [NSDictionary dictionaryWithObjectsAndKeys:nil, @"done", nil];
    // 实例化返回结果
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)hide:(CDVInvokedUrlCommand *)command
{
    NSLog(@"CDVSoftKeyboardPlugin---hide");
    
    //关闭输入法
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

}


@end
