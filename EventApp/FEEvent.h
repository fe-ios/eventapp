//
//  FEEvent.h
//  EventApp
//
//  Created by zhenglin li on 12-7-25.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FEEvent : NSObject <NSCoding>

@property(nonatomic, assign) int event_id;
@property(nonatomic, assign) int owner_id;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSDate *start_date;
@property(nonatomic, copy) NSDate *end_date;
@property(nonatomic, copy) NSString *venue;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *detail;
@property(nonatomic, copy) NSString *logoURL;
@property(nonatomic, copy) NSString *bannerURL;
@property(nonatomic, assign) BOOL isWatched;
@property(nonatomic, retain) NSMutableArray *tags;
@property(nonatomic, retain) NSMutableArray *attendees;

- (id)initWithJSONObject:(NSDictionary *)object;

+ (NSMutableArray *)translateJSONEvents:(NSMutableArray *)jsonData;

@end
