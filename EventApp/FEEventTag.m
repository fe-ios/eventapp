//
//  FEEventTag.m
//  EventApp
//
//  Created by zhenglin li on 12-8-24.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEEventTag.h"

@implementation FEEventTag

@synthesize tag_id = _tag_id, value = _value;

- (id)initWithData:(int)tagId value:(NSString *)value
{
    self = [super init];
    if(self){
        self.tag_id = tagId;
        self.value = value;
    }
    return self;
}

@end
