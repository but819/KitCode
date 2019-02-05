//
//  CDVSharePlugin.m
//  weather
//
//  Created by mac on 14-3-21.
//
//

#import "CDVSharePlugin.h"

#import <ShareSDK/ShareSDK.h>


@implementation CDVSharePlugin

@synthesize callbackID;



-(void)share:(CDVInvokedUrlCommand*)command
{
    
    //得到js传输回来的数据
    NSString *ShareTitle=[command.arguments objectAtIndex:0];
    NSString *ShareText=[command.arguments objectAtIndex:1];
    NSString *ShareImgurl=[command.arguments objectAtIndex:2];
    NSString *ShareUrl=[command.arguments objectAtIndex:3];
    
    
    NSLog(@ "share---title%@ text%@ imgurl%@ url%@",ShareTitle,ShareText,ShareImgurl,ShareUrl);
    
    //获取路径
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:ShareText
                                       defaultContent:ShareText
                                                image:[ShareSDK imageWithUrl:ShareImgurl]
                                                title:ShareTitle
                                                  url:ShareUrl
                                          description:ShareText
                                            mediaType:SSPublishContentMediaTypeNews];

    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
            [ShareSDK showShareActionSheet:nil
                                 shareList:nil
                                   content:publishContent
                             statusBarTips:YES
                               authOptions:nil
                              shareOptions: nil
                                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                        if (state == SSResponseStateSuccess)
                                        {
                                            NSLog(@"分享成功");
                                        }
                                        else if (state == SSResponseStateFail)
                                        {
                                             NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                        }
                                    }];
    }
    else
    {
        //获取屏幕内容
        CGRect rect = [[UIScreen mainScreen] bounds];
        //屏幕尺寸
        CGSize size = rect.size;
        //屏幕宽度
        CGFloat ScreenWith = (NSInteger)size.width;
        //屏幕高度
        CGFloat ScreenHeight = (NSInteger)size.height;
        
        //实例化一个按钮
        UIButton *btn;
        //实例化单个按钮
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置按钮尺寸
        btn.frame = CGRectMake(ScreenWith-40,50 , 0, 0);
        //设置内容
        [btn setTitle:@"" forState:UIControlStateNormal];
        //设置tag
        [btn setTag:9999];
        //视图压入对应的按钮
        [self.viewController.view addSubview:btn];
        
        
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:[self.viewController.view viewWithTag:9999]
                                arrowDirect:UIPopoverArrowDirectionUp];
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        NSLog(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    }
                                }];
    }

}
@end
