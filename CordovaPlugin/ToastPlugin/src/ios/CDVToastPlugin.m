//
//  CDVToastPlugin.m
//  weather
//
//  Created by mac on 14-4-2.
//
//

#import "CDVToastPlugin.h"
#import "PublicFuction.h"

@implementation CDVToastPlugin
@synthesize callbackID;
@synthesize MyFunction;



- (void) toast:(CDVInvokedUrlCommand*)command
{
    
    MyFunction=[[PublicFuction alloc] init];
    
    [MyFunction ShowToast:self.viewController WithContent:[command.arguments objectAtIndex:0]];
}

@end
