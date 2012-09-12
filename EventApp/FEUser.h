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
@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSString *avatarURL;

@end
