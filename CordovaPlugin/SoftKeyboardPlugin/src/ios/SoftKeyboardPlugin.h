//
//  CDVSoftKeyboardPlugin.h
//  weather
//
//  Created by mac on 14-9-18.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "PublicFuction.h"

@interface SoftKeyboardPlugin : CDVPlugin

@property (nonatomic,copy) NSString *callbackID;
@property (nonatomic,retain)PublicFuction *MyFunction;

- (void)show:(CDVInvokedUrlCommand*)command;

- (void)hide:(CDVInvokedUrlCommand*)command;

- (void)done:(CDVInvokedUrlCommand*)command;


@end