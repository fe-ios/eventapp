//
//  FEEentListController.h
//  EventApp
//
//  Created by zhenglin li on 12-7-19.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import <Foundation/Foundation.h>

@interface FEEentListController : UITableViewController <ASIHTTPRequestDelegate>


@property(nonatomic, retain) NSOperationQueue *downloadQueue;
@property(nonatomic, retain) NSMutableArray *eventData;

@end
