//
//  CDVToastPlugin.m
//  weather
//
//  Created by mac on 14-4-2.
//
//

#import "CDVLoginPlugin.h"
#import "PublicFuction.h"
#import "SlideMenuAppDelegate.h"

@implementation CDVLoginPlugin
@synthesize callbackID;
@synthesize MyFunction;

// 登陆功能
- (void)login:(CDVInvokedUrlCommand *)command
{
    NSLog(@"QQ_login---Plugin");

    MyFunction = [[PublicFuction alloc] init];

    [self InitTencent];

    [self onClickLoginWithPath:[command.arguments objectAtIndex:0]];
}

// 页面返回功能
- (void)finish:(CDVInvokedUrlCommand *)command
{
    SlideMenuAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    [appDelegate.nav popViewControllerAnimated:YES];
}

// 初始化配置
- (void)InitTencent
{
    NSString *appid = @"1101192238";

    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:appid andDelegate:self];
}

// 登陆
- (void)onClickLoginWithPath:(NSString *)path
{
    _permissions = [NSArray arrayWithObjects:@"get_user_info", @"add_t", nil];

    if ([path isEqualToString:@"qq"]) {
        if ([self iphoneQQSupportSSO]) {
            // 启动登陆
            [_tencentOAuth authorize:_permissions inSafari:NO];
            // 获取用户信息
            [self getUserInfo];
        }
    }
}

// 注销
- (void)onClickLogout
{
    [_tencentOAuth logout:self];
}

// 调用获取信息函数
- (void)getUserInfo
{
    BOOL isOAuthOK = [_tencentOAuth getUserInfo];

    if (!isOAuthOK) {
        // 注销掉
        [_tencentOAuth logout:self];

        NSLog(@"......OAuth过期 请重新授权后再调用接口");
    } else {
        NSLog(@"......获取用户数据 正在获取用户数据，请稍后...");
    }
}

// 接收用户信息
- (void)getUserInfoResponse:(APIResponse *)response
{
    // 赋值
    ReturnMsg = response;

    if (response.retCode == 0) {
        NSLog(@"......获取用户数据成功");

        // 压入数据
        result = [NSDictionary dictionaryWithObjectsAndKeys:[
                _tencentOAuth openId], @"uid",
            [ReturnMsg.jsonResponse objectForKey:@"nickname"], @"nick",
            [ReturnMsg.jsonResponse objectForKey:@"figureurl_qq_2"], @"img",
            @"qq", @"path",
            nil];

        // 实例化返回结果
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
        // 发送到前端
        [self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
    } else {
        NSLog(@"......获取用户数据失败");
    }
}

// 登录成功：
- (void)tencentDidLogin;
{
    NSLog(@"登陆完成");

    if (_tencentOAuth.accessToken && (0 != [_tencentOAuth.accessToken length])) {
        //  记录登录用户的OpenID、Token以及过期时间
        NSLog(@"记录登录用户的OpenID、Token以及过期时间 %@", [_tencentOAuth openId]);
    } else {
        NSLog(@"登陆不成功 没有获取accesstoken");
    }
}

// 非网络错误导致登录失败
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        NSLog(@"用户取消登录");
    } else {
        NSLog(@"登录失败");

        // 压入数据
        result = [NSDictionary dictionaryWithObjectsAndKeys:[
                _tencentOAuth openId], @"uid",
            @"", @"nick",
            @"", @"img",
            @"qq", @"path",
            nil];

        // 实例化返回结果
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
        // 发送到前端
        [self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
    }
}

// 网络错误导致登录失败
- (void)tencentDidNotNetWork
{
    NSLog(@"无网络连接，请设置网络");
}

// 手机没有安装QQ
- (BOOL)iphoneQQSupportSSO
{
    NSString    *msg = nil;
    BOOL        iphoneQQSupportSSOState;

    if ([TencentOAuth iphoneQQInstalled]) {
        msg = [TencentOAuth iphoneQQSupportSSOLogin] ? (@"手机QQ支持SSO登陆") : (@"手机QQ不支持SSO登陆");
        iphoneQQSupportSSOState = YES;
    } else {
        msg = @"手机QQ未安装";
        iphoneQQSupportSSOState = NO;

        [MyFunction ShowToast:self.viewController WithContent:@"手机QQ暂未安装"];
    }

    return iphoneQQSupportSSOState;
}

// 手机不支持QQ_Api
- (BOOL)iphoneQQSupportTencentApiSdk
{
    NSString *msg = [TencentOAuth iphoneQZoneSupportSSOLogin] ? (@"手机QQ支持腾讯API") : (@"手机QQ不支持腾讯API");

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"result" message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];

    [alertView show];
}

@end