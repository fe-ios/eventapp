//
//  FECreateEventToolbar.h
//  EventApp
//
//  Created by zhenglin li on 12-8-15.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CreateEventNoneAction = 0,
    CreateEventBasicAction = 1,
    CreateEventIconAction = 2,
    CreateEventTagAction = 3,
    CreateEventDetailAction = 4,
    CreateEventMemberAction = 5,
    CreateEventPrivacyAction = 6
} CreateEventAction;

typedef enum {
    CreateEventPrivacyPrivate = 0,
    CreateEventPrivacyPublic = 1
} CreateEventPrivacy;

@interface FECreateEventToolbar : UIControl

@property(nonatomic, assign) int lastAction;
@property(nonatomic, assign) int action;
@property(nonatomic, readonly) int privacy;

- (void)showOrHideActions:(BOOL)hidden;
- (void)completeAction:(int)action completed:(BOOL)complete;
- (void)switchToAction:(int)action;

@end
