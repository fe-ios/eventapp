//
//  FEUser.m
//  EventApp
//
//  Created by zhenglin li on 12-9-7.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEUser.h"

@implementation FEUser

@synthesize user_id, username, avatarURL, email;

-(void)dealloc
{
    [username release];
    [avatarURL release];
    [email release];
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self){
        self.user_id = [aDecoder decodeIntForKey:@"user_id"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.avatarURL = [aDecoder decodeObjectForKey:@"avatarURL"];
    }
    return self;
}

- (id)initWithJSONObject:(NSDictionary *)object
{
    self = [super init];
    if(self){
        [self translateFromJSONObject:object];
    }
    return self;
}

- (void)translateFromJSONObject:(NSDictionary *)object
{
    self.user_id = [[object objectForKey:@"user_id"] intValue];
    self.username = [object objectForKey:@"username"];
    self.email = [object objectForKey:@"email"];
    self.avatarURL = [object objectForKey:@"avatar"];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.avatarURL forKey:@"avatarURL"];
}

@end
