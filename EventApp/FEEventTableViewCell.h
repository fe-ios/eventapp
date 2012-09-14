//
//  FEEventTableViewCell.h
//  EventApp
//
//  Created by zhenglin li on 12-7-19.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAsyncImageView.h"

@interface FEEventTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIAsyncImageView *eventIcon;
@property (retain, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *eventTagLabel;

@property(retain, nonatomic) UIButton *watchButton;

@end
