//
//  FEMyEventListController.h
//  EventApp
//
//  Created by zhenglin li on 12-9-14.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface FEMyEventListController : UITableViewController <ASIHTTPRequestDelegate>

@property(nonatomic, retain) NSMutableArray *eventData;

@end
