//
//  FEUser.h
//  EventApp
//
//  Created by zhenglin li on 12-9-7.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FEUser : NSObject <NSCoding>

@property(nonatomic, assign) int user_id;
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *avatarURL;

@end
