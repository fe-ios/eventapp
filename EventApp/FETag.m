//
//  FETag.m
//  EventApp
//
//  Created by zhenglin li on 12-9-7.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FETag.h"

@implementation FETag

@synthesize tag_id, name;

- (id)initWithData:(int)tagId name:(NSString *)tagName
{
    self = [super init];
    if(self){
        self.tag_id = tagId;
        self.name = tagName;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self){
        self.tag_id = [aDecoder decodeIntForKey:@"tag_id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.tag_id forKey:@"tag_id"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (NSString *)description
{
    return self.name;
}


@end
