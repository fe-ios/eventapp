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
    CreateEventIconAction = 1,
    CreateEventTagAction = 2,
    CreateEventDetailAction = 3,
    CreateEventMemberAction = 4,
    CreateEventPrivacyAction = 5
} CreateEventAction;

typedef enum {
    CreateEventPrivacyPrivate = 0,
    CreateEventPrivacyPublic = 1
} CreateEventPrivacy;

@interface FECreateEventToolbar : UIControl

@property(nonatomic, readonly) int action;
@property(nonatomic, readonly) int privacy;

-(void)resetAction;

@end
