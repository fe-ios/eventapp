//
//  FEEventDetailViewController.h
//  EventApp
//
//  Created by Yin Zhengbo on 8/13/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEEvent.h"
#import "UIAsyncImageView.h"

@interface FEEventDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) FEEvent *event;


@end
