//
//  FEEvent.m
//  EventApp
//
//  Created by zhenglin li on 12-7-25.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEEvent.h"

@implementation FEEvent

@synthesize event_id;
@synthesize owner_id;
@synthesize name = _name;
@synthesize start_date = _start_date;
@synthesize end_date = _end_date;
@synthesize venue = _venue;
@synthesize desc = _desc;
@synthesize detail = _detail;
@synthesize logoURL = _logoURL;


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
    self.event_id = [[object objectForKey:@"event_id"] intValue];
    self.owner_id = [[object objectForKey:@"owner_id"] intValue];
    self.name = [object objectForKey:@"name"];
    self.start_date = [object objectForKey:@"start_date"];
    self.end_date = [object objectForKey:@"end_date"];
    self.venue = [object objectForKey:@"venue"];
    self.desc = [object objectForKey:@"desc"];
    self.detail = [object objectForKey:@"detail"];
    self.logoURL = [self getStringValue:object withKey:@"logo"];
}

+ (NSMutableArray *)translateJSONEvents:(NSMutableArray *)jsonData
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(int i = 0; i < jsonData.count; i++){
        FEEvent *event = [[FEEvent alloc] initWithJSONObject:[jsonData objectAtIndex:i]];
        [result addObject:event];
        [event release];
    }
    return result;
}

- (NSString *)getStringValue:(NSDictionary *)jsonObject withKey:(NSString *)key
{
    id value = [jsonObject objectForKey:key];
    if(value == nil){
        return  nil;
    }else if ([value isEqual:[NSNull null]]) {
        return  nil;
    }else if ([value isEqualToString:@"0"]) {
        return  nil;
    }
    return (NSString *)value;
}

@end