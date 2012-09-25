//
//  FEEventAttendeeViewController.h
//  EventApp
//
//  Created by Yin Zhengbo on 9/17/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEEvent.h"

@interface FEEventAttendeeViewController : UITableViewController

@property(nonatomic, retain) FEEvent *event;
@property(nonatomic, retain) id delegate;
@property(nonatomic, assign) BOOL onlyShowAttendees;

- (void)confirm:(NSNumber *)index;
- (void)reject:(NSNumber *)index;

@end