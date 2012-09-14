//
//  FECreateEventController.h
//  EventApp
//
//  Created by zhenglin li on 12-7-24.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEAddEventTagView.h"
#import "FEAddEventDetailView.h"
#import "FEAddEventView.h"
#import "FEEventListController.h"

@interface FECreateEventController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, FEAddEventTagViewDelegate, FEAddEventDetailViewDelegate, FEAddEventViewDelegate>

@property(nonatomic, retain) FEEventListController *listController;

@end
