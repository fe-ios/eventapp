//
//  AppDelegate.h
//  EventApp
//
//  Created by zhenglin li on 12-7-2.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WrapController.h"

@class BOCenterViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) WrapController *wrapController;
@property (strong, nonatomic) UINavigationController *navigationController;

- (void)startMainView;

@end
