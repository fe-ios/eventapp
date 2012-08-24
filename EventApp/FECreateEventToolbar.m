//
//  FECreateEventToolbar.m
//  EventApp
//
//  Created by zhenglin li on 12-8-15.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FECreateEventToolbar.h"
#import "FESwitch.h"

@interface FECreateEventToolbar(){
    UIButton* _activeButton;
}

@end

@implementation FECreateEventToolbar

@synthesize action = _action, lastAction = _lastAction;
@synthesize privacy = _privacy;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initView];
    }
    return self;
}

- (void)initView
{
    //bg
    UIImageView *toolbarBg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
	[toolbarBg setImage:[UIImage imageNamed:@"tool_bar_lightgray"]];
	[self addSubview:toolbarBg];
	
	//bar items
    int start = 8, padding = 42;
    UIButton *buttonSetBasic = [[[UIButton alloc] initWithFrame:CGRectMake(start, 0, 36, 44)] autorelease];
	[buttonSetBasic setImage:[UIImage imageNamed:@"tool_bar_icon_list"] forState:UIControlStateNormal];
	[buttonSetBasic setImage:[UIImage imageNamed:@"tool_bar_icon_list_s"] forState:UIControlStateSelected];
	[buttonSetBasic addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
    buttonSetBasic.tag = CreateEventBasicAction;
	[self addSubview:buttonSetBasic];
    
	UIButton *buttonSetIcon = [[[UIButton alloc] initWithFrame:CGRectMake(start+padding, 0, 36, 44)] autorelease];
	[buttonSetIcon setImage:[UIImage imageNamed:@"tool_bar_icon_gallery"] forState:UIControlStateNormal];
	[buttonSetIcon setImage:[UIImage imageNamed:@"tool_bar_icon_gallery_s"] forState:UIControlStateSelected];
	[buttonSetIcon addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
    buttonSetIcon.tag = CreateEventIconAction;
	[self addSubview:buttonSetIcon];
    
	UIButton *buttonSetTag = [[[UIButton alloc] initWithFrame:CGRectMake(start+padding*2, 0, 36, 44)] autorelease];
	[buttonSetTag setImage:[UIImage imageNamed:@"tool_bar_icon_tag"] forState:UIControlStateNormal];
	[buttonSetTag setImage:[UIImage imageNamed:@"tool_bar_icon_tag_s"] forState:UIControlStateSelected];
	[buttonSetTag addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
    buttonSetTag.tag = CreateEventTagAction;
	[self addSubview:buttonSetTag];
    
	UIButton *buttonSetDetail = [[[UIButton alloc] initWithFrame:CGRectMake(start+padding*3, 0, 36, 44)] autorelease];
	[buttonSetDetail setImage:[UIImage imageNamed:@"tool_bar_icon_info"] forState:UIControlStateNormal];
	[buttonSetDetail setImage:[UIImage imageNamed:@"tool_bar_icon_info_s"] forState:UIControlStateSelected];
	[buttonSetDetail addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
    buttonSetDetail.tag = CreateEventDetailAction;
	[self addSubview:buttonSetDetail];
    
	UIButton *buttonSetMember = [[[UIButton alloc] initWithFrame:CGRectMake(start+padding*4, 0, 36, 44)] autorelease];
	[buttonSetMember setImage:[UIImage imageNamed:@"tool_bar_icon_people"] forState:UIControlStateNormal];
	[buttonSetMember setImage:[UIImage imageNamed:@"tool_bar_icon_people_s"] forState:UIControlStateSelected];
	[buttonSetMember addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
    buttonSetMember.tag = CreateEventMemberAction;
	[self addSubview:buttonSetMember];
    
	//switch
	FESwitch *privacySwitch = [[[FESwitch alloc] init] autorelease];
    privacySwitch.frame = CGRectMake(243, 5, 70, 32);
    [privacySwitch setToggleImage:[UIImage imageNamed:@"share_switch_bar"]];
    [privacySwitch setOutlineImage:[UIImage imageNamed:@"switch_inner_shadow"]];
    [privacySwitch setKnobImage:[UIImage imageNamed:@"switch_handle"]];
    [privacySwitch setOnImage:[UIImage imageNamed:@"share_switch_on"]];
    [privacySwitch setOffImage:[UIImage imageNamed:@"share_switch_off"]];
    privacySwitch.on = YES;
    [privacySwitch addTarget:self action:@selector(privacyChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:privacySwitch];
    
    _lastAction = CreateEventNoneAction;
    _action = CreateEventBasicAction;
    _privacy = CreateEventPrivacyPublic;
}

- (void)toggleButton:(UIButton *)sender
{
    _lastAction = _action;
    _action = sender.tag;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)privacyChanged:(FESwitch *)sender
{
    _action = CreateEventPrivacyAction;
    _privacy = sender.on ? CreateEventPrivacyPublic : CreateEventPrivacyPrivate;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)showOrHideActions:(BOOL)hidden
{
    for(int i = 1; i < self.subviews.count; i++){
        [[self.subviews objectAtIndex:i] setHidden:hidden];
    }
}

- (void)completeAction:(int)action completed:(BOOL)complete
{
    UIButton *actionButton = (UIButton *)[self viewWithTag:action];
    if(actionButton){
        actionButton.selected = complete;
    }
}

@end
