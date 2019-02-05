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

@interface CDVToastPlugin : CDVPlugin

@property (nonatomic,copy) NSString *callbackID;
@property (nonatomic,retain)PublicFuction *MyFunction;

- (void)toast:(CDVInvokedUrlCommand*)command;

@end
