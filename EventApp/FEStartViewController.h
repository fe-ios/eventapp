//
//  FEStartViewController.h
//  EventApp
//
//  Created by zhenglin li on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FELoginViewController.h"
#import "FERegisterViewController.h"

@interface FEStartViewController : UIViewController <UIScrollViewDelegate>

@property(nonatomic, retain) FELoginViewController *loginController;
@property(nonatomic, retain) FERegisterViewController *registerController;

@end
