//
//  FEEventTag.h
//  EventApp
//
//  Created by zhenglin li on 12-8-24.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FEEventTag : NSObject

@property(nonatomic, assign) int tag_id;
@property(nonatomic, retain) NSString *value;

- (id)initWithData:(int)tagId value:(NSString *)value;

@end
