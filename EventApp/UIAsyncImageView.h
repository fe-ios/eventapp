//
//  UIAsyncImageView.h
//  EventApp
//
//  Created by zhenglin li on 12-7-20.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface UIAsyncImageView : UIView <ASIHTTPRequestDelegate>

@property(nonatomic, retain) UIImage *image;
@property(nonatomic, copy, readonly) NSString *imagePath;

- (void)loadImageAsync:(NSString *)imageURL withQueue:(NSOperationQueue *)queue;

@end
