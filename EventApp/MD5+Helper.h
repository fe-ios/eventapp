//
//  MD5+Helper.h
//  EventApp
//
//  Created by zhenglin li on 12-7-25.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(MD5Extension)

- (NSString *)md5;

@end


@interface NSData(MD5Extension)

- (NSString *)md5;

@end
