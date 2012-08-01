//
//  FEEvent.h
//  EventApp
//
//  Created by zhenglin li on 12-7-25.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FEEvent : NSObject

@property(nonatomic, assign) int event_id;
@property(nonatomic, assign) int owner_id;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *desc;
@property(nonatomic, retain) NSDate *start_date;
@property(nonatomic, retain) NSDate *end_date;
@property(nonatomic, retain) NSString *venue;
@property(nonatomic, retain) NSString *detail;
@property(nonatomic, retain) NSString *logoURL;

- (id)initWithJSONObject:(NSDictionary *)object;

+ (NSMutableArray *)translateJSONEvents:(NSMutableArray *)jsonData;

@end
