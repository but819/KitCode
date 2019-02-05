//
//  CDVDataPlugin.m
//  weather
//
//  Created by mac on 14-3-27.
//
//

#import "CDVDataPlugin.h"
#import "PublicData.h"
#import "SlideMenuAppDelegate.h"


@implementation CDVDataPlugin

@synthesize LocalCity;
@synthesize CityChangeState;

@synthesize callbackID;


//提供数据到前端
-(void)get:(CDVInvokedUrlCommand*)command
{
    //获取需要键
    NSString *NeedKey =[command.arguments objectAtIndex:0];
    
    //实例化共享数据
    SlideMenuAppDelegate *PublicData=(SlideMenuAppDelegate*)[[UIApplication sharedApplication]delegate];
    //获取值
    NSObject *NeedValue=[PublicData.PublicDictionary objectForKey:NeedKey];

    //实例化返回结果
    CDVPluginResult* pluginResult=[CDVPluginResult alloc];
    
    //0-null--
    if (NeedValue==nil)
    {
        //实例化返回结果
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
            NSLog(@"插件····get：null  Value:%@",NeedValue);
    }
    //1-string--
    else if ([NeedValue isKindOfClass:[NSString class]])
    {
        //实例化返回结果
       pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:(NSString *)NeedValue];
        NSLog(@"插件····get：string Value:%@",NeedValue);
    }
    //2-array--
    else if ([NeedValue isKindOfClass:[NSArray class]])
    {
        //实例化返回结果
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:(NSArray*)NeedValue];
                NSLog(@"插件····get：array Value:%@",NeedValue);
    }
    //3-int
    else if (([NeedValue class] == [NSNumber class]))
    {
        //实例化返回结果
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:NeedValue];
        
                        NSLog(@"插件····get：int Value:%@",NeedValue);
    }
    //4-Double
    else if ([NeedValue isKindOfClass:[NSString class]])
    {
        //实例化返回结果
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:(NSString *)NeedValue];
        NSLog(@"插件····get：Double Value:%@",NeedValue);
    }
    //5-bool
    else if ([NeedValue class] == [NSNumber class])
    {
        //实例化返回结果
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:NeedValue];
        
        NSLog(@"插件····get：bool Value:%@",NeedValue);
    }
    //6-NSDictionary--
    else if ([NeedValue isKindOfClass:[NSDictionary class]])
    {
        //实例化返回结果
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:(NSDictionary *)NeedValue];
    }
    //7-nsdata--
    else if ([NeedValue isKindOfClass:[NSData class]])
    {
        //实例化返回结果
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:(NSData *)NeedValue];
    }
    //提交数据
    [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
}

//储存数据
-(void)save:(CDVInvokedUrlCommand*)command
{
    //实例化共享数据
    SlideMenuAppDelegate *PublicData=(SlideMenuAppDelegate*)[[UIApplication sharedApplication]delegate];

    //填充键值
    [PublicData.PublicDictionary setObject:[command.arguments objectAtIndex:1] forKey: [command.arguments objectAtIndex:0]];

    //保存后关闭输入法
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    NSLog(@"插件····PublicData.product.url:%@",[PublicData.PublicDictionary objectForKey:@"item_product_url"]);

}


- (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


- (BOOL)isPureFloat:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}
@end
