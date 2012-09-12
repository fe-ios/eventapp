//
//  FEUser.m
//  EventApp
//
//  Created by zhenglin li on 12-9-7.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEUser.h"

@implementation FEUser

@synthesize user_id, username, avatarURL;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self){
        self.user_id = [aDecoder decodeIntForKey:@"user_id"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.avatarURL = [aDecoder decodeObjectForKey:@"avatarURL"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.avatarURL forKey:@"avatarURL"];
}

@end
