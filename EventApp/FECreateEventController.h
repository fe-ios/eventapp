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
#import "FEEvent.h"

typedef enum{
    EventEditorTypeCreate = 0,
    EventEditorTypeModify = 1
} EventEditorType;


@interface FECreateEventController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, FEAddEventTagViewDelegate, FEAddEventDetailViewDelegate, FEAddEventViewDelegate>

@property(nonatomic, assign) EventEditorType type;
@property(nonatomic, retain) FEEvent *event;

@property(nonatomic, retain) UIViewController *parentController;

@end
