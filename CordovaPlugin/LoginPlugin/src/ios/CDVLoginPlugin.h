//
//  CDVToastPlugin.h
//  weather
//
//  Created by mac on 14-4-2.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "PublicFuction.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface CDVLoginPlugin : CDVPlugin <TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
    
    NSArray *_permissions;
    
    APIResponse *ReturnMsg;
    
    NSDictionary *result;
}
@property (nonatomic,copy) NSString *callbackID;
@property (nonatomic,retain)PublicFuction *MyFunction;

- (void)login:(CDVInvokedUrlCommand*)command;
- (void)finish:(CDVInvokedUrlCommand *)command;


@end
