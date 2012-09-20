//
//  FEAttendeeCell.h
//  EventApp
//
//  Created by zhenglin li on 12-9-19.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAsyncImageView.h"

typedef enum {
    AttendeeCellTypeApproved = 1,
    AttendeeCellTypeNeedToApprove = 2
} AttendeeCellType;

@interface FEAttendeeCell : UITableViewCell

@property(nonatomic, retain) UIAsyncImageView *avatarView;
@property(nonatomic, retain) UILabel *nameLabel;

@property(nonatomic, assign) AttendeeCellType type;
@property(nonatomic, assign) int index;
@property(nonatomic, retain) UIViewController *controller;

@end