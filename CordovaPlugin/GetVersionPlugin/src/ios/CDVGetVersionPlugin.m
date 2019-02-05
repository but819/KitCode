//
//  CDVGetVersionPlugin.m
//  weather
//
//  Created by mac on 14-3-20.
//
//

#import "CDVGetVersionPlugin.h"

@implementation CDVGetVersionPlugin

@synthesize callbackID;

-(void) get:(CDVInvokedUrlCommand*)command;
{
    
    NSLog(@ "plgin......1");
    //获取mainbudle的字典
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    //获取版本号
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    //获取应用名字
    NSString*appName =[infoDict objectForKey:@"CFBundleDisplayName"];
    //整合为显示内容
    NSDictionary *result;
    //压入数据
    result=[NSDictionary dictionaryWithObjectsAndKeys:versionNum,@"VersionName",appName,@"VersionCode", nil];
    //实例化返回结果
    CDVPluginResult* pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    
    [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
}

@end
