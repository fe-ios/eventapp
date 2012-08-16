//
//  FESwitch.h
//  EventApp
//
//  Created by zhenglin li on 12-8-15.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface FESwitch : UIControl

@property (nonatomic, getter=isOn) BOOL on;

- (void)setOn:(BOOL)newOn animated:(BOOL)animated;

@end
