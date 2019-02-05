//
//  CDVDataPlugin.h
//  weather
//
//  Created by mac on 14-3-27.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>


@interface CDVDataPlugin : CDVPlugin

@property (nonatomic,copy)NSString *callbackID;

@property (nonatomic,copy) NSString *LocalCity;
@property (nonatomic,copy) NSString *CityChangeState;


//获取方法
- (void)get:(CDVInvokedUrlCommand*)command;
//保存方法
- (void)save:(CDVInvokedUrlCommand*)command;

@end
