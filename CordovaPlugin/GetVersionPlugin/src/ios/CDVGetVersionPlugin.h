//
//  CDVGetVersionPlugin.h
//  weather
//
//  Created by mac on 14-3-20.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface CDVGetVersionPlugin : CDVPlugin

   @property (nonatomic,copy) NSString *callbackID;

-(void) get:(CDVInvokedUrlCommand*)command;
;

@end
