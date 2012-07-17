//
//  FEServerAPI.h
//  EventApp
//
//  Created by zhenglin li on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FEServerAPI : NSObject

@end


extern NSString *const API_BASE;
extern NSString *const API_LOGIN;
extern NSString *const API_LOGOUT;
extern NSString *const API_REGISTER;


NSString *const API_BASE = @"http://10.0.2.1:8888/event";
NSString *const API_LOGIN = @"/user/login";
NSString *const API_LOGOUT = @"/user/logout";
NSString *const API_REGISTER = @"/user/register";


