//
//  CDVToastPlugin.h
//  weather
//
//  Created by mac on 14-4-2.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>


@interface CDVActivityPlugin : CDVPlugin

@property (nonatomic,copy) NSString *callbackID;

- (void)open:(CDVInvokedUrlCommand*)command;

@end
