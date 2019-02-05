//
//  CDVToastPlugin.m
//  weather
//
//  Created by mac on 14-4-2.
//
//

#import "CDVKalengoPlugin.h"
#import "PublicFuction.h"

@implementation CDVKalengoPlugin
@synthesize callbackID;
@synthesize MyFunction;


- (void) todayopen:(CDVInvokedUrlCommand*)command
{
    NSLog(@"todayopen");

    [self.viewController.mainSlideMenu closeLeftMenu];
}

- (void) todayclose:(CDVInvokedUrlCommand*)command
{
    NSLog(@"todayclose");
    
    [self.viewController.mainSlideMenu openLeftMenu];
}

@end
