//
//  FELoginController.h
//  EventApp
//
//  Created by zhenglin li on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FELoginViewController.h"

@interface FELoginController : UIViewController

@property(nonatomic, assign) Boolean isRegistration;

@property(nonatomic, retain) FELoginViewController *loginController;

- (void)prepareView;

@end

