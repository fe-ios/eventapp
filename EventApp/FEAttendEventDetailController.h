//
//  FEAttendEventDetailController.h
//  EventApp
//
//  Created by zhenglin li on 12-9-14.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEEvent.h"
#import "UIAsyncImageView.h"

@interface FEAttendEventDetailController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) FEEvent *event;

@end
