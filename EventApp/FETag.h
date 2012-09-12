//
//  FETag.h
//  EventApp
//
//  Created by zhenglin li on 12-9-7.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FETag : NSObject <NSCoding>

@property(nonatomic, assign) int tag_id;
@property(nonatomic, retain) NSString *name;

- (id)initWithData:(int)tagId name:(NSString *)tagName;

@end
