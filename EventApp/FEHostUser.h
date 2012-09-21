//
//  FEHostUser.h
//  EventApp
//
//  Created by zhenglin li on 12-9-21.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEUser.h"

@interface FEHostUser : FEUser

@property(nonatomic, copy) NSString *password;
@property(nonatomic, retain) UIImage *avatarImage;

-(void)loadAvatar;

@end
