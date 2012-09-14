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

@interface FECreateEventToolbar()

@property(nonatomic, retain) UIButton *activeButton;

@end

@implementation FECreateEventToolbar

@synthesize action = _action, lastAction = _lastAction;
@synthesize privacy = _privacy, activeButton = _activeButton;


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

- (void)dealloc
{
    [_activeButton release];
    [super dealloc];
}

- (void)initView
{
    //bg
    UIImageView *toolbarBg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
	[toolbarBg setImage:[UIImage imageNamed:@"tool_bar_lightgray"]];
	[self addSubview:toolbarBg];
	
	//bar items
    int start = 9, padding = 50, top = 1, w = 45, h = 42;
    UIButton *buttonSetBasic = [[[UIButton alloc] initWithFrame:CGRectMake(start, top, w, h)] autorelease];
	[buttonSetBasic setImage:[UIImage imageNamed:@"tool_bar_icon_list"] forState:UIControlStateNormal];
	[buttonSetBasic setImage:[UIImage imageNamed:@"tool_bar_icon_list_s"] forState:UIControlStateSelected];
	[buttonSetBasic addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
    buttonSetBasic.adjustsImageWhenHighlighted = NO;
    buttonSetBasic.tag = CreateEventBasicAction;
	[self addSubview:buttonSetBasic];
    
	UIButton *buttonSetIcon = [[[UIButton alloc] initWithFrame:CGRectMake(start+padding, top, w, h)] autorelease];
	[buttonSetIcon setImage:[UIImage imageNamed:@"tool_bar_icon_gallery"] forState:UIControlStateNormal];
	[buttonSetIcon setImage:[UIImage imageNamed:@"tool_bar_icon_gallery_s"] forState:UIControlStateSelected];
	[buttonSetIcon addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
    buttonSetIcon.adjustsImageWhenHighlighted = NO;
    buttonSetIcon.tag = CreateEventIconAction;
	[self addSubview:buttonSetIcon];
    
	UIButton *buttonSetTag = [[[UIButton alloc] initWithFrame:CGRectMake(start+padding*2, top, w, h)] autorelease];
	[buttonSetTag setImage:[UIImage imageNamed:@"tool_bar_icon_tag"] forState:UIControlStateNormal];
	[buttonSetTag setImage:[UIImage imageNamed:@"tool_bar_icon_tag_s"] forState:UIControlStateSelected];
	[buttonSetTag addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
    buttonSetTag.adjustsImageWhenHighlighted = NO;
    buttonSetTag.tag = CreateEventTagAction;
	[self addSubview:buttonSetTag];
    
	UIButton *buttonSetDetail = [[[UIButton alloc] initWithFrame:CGRectMake(start+padding*3, top, w, h)] autorelease];
	[buttonSetDetail setImage:[UIImage imageNamed:@"tool_bar_icon_info"] forState:UIControlStateNormal];
	[buttonSetDetail setImage:[UIImage imageNamed:@"tool_bar_icon_info_s"] forState:UIControlStateSelected];
	[buttonSetDetail addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
    buttonSetDetail.adjustsImageWhenHighlighted = NO;
    buttonSetDetail.tag = CreateEventDetailAction;
	[self addSubview:buttonSetDetail];
    
//	UIButton *buttonSetMember = [[[UIButton alloc] initWithFrame:CGRectMake(start+padding*4, top, w, h)] autorelease];
//	[buttonSetMember setImage:[UIImage imageNamed:@"tool_bar_icon_people"] forState:UIControlStateNormal];
//	[buttonSetMember setImage:[UIImage imageNamed:@"tool_bar_icon_people_s"] forState:UIControlStateSelected];
//	[buttonSetMember addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
//    buttonSetMember.adjustsImageWhenHighlighted = NO;
//    buttonSetMember.tag = CreateEventMemberAction;
//	[self addSubview:buttonSetMember];
    
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
    
    _privacy = CreateEventPrivacyPublic;
    [self toggleButton:buttonSetBasic];
}

- (void)toggleButton:(UIButton *)sender
{
    _lastAction = _action;
    _action = sender.tag;
    
    if(self.activeButton != sender){
        if(self.activeButton){
            [self.activeButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
        self.activeButton = sender;
        [self.activeButton setBackgroundImage:[UIImage imageNamed:@"toolbar_selected_bg"] forState:UIControlStateNormal];
    }
    
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

- (void)switchToAction:(int)action
{
    UIButton *actionButton = (UIButton *)[self viewWithTag:action];
    if(actionButton){
        [self toggleButton:actionButton];
    }
}

@end
