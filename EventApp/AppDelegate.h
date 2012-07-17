//
//  AppDelegate.h
//  EventApp
//
//  Created by zhenglin li on 12-7-2.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BOCenterViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//BO
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) BOCenterViewController *viewController;

@end
