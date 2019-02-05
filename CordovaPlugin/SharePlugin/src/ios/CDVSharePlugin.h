//
//  CDVSharePlugin.h
//  weather
//
//  Created by mac on 14-3-21.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

#import "PublicData.h"

@interface CDVSharePlugin :CDVPlugin

@property(nonatomic,copy)NSString *callbackID;



-(void)share:(CDVInvokedUrlCommand*)command;

@end
