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

@synthesize action = _action;
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
	UIButton *buttonSetIcon = [[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 36, 44)] autorelease];
	[buttonSetIcon setImage:[UIImage imageNamed:@"tool_bar_icon_gallery"] forState:UIControlStateNormal];
	[buttonSetIcon setImage:[UIImage imageNamed:@"tool_bar_icon_gallery_s"] forState:UIControlStateSelected];
	[buttonSetIcon addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
    buttonSetIcon.tag = CreateEventIconAction;
	[self addSubview:buttonSetIcon];
    
	UIButton *buttonSetTag = [[[UIButton alloc] initWithFrame:CGRectMake(60, 0, 36, 44)] autorelease];
	[buttonSetTag setImage:[UIImage imageNamed:@"tool_bar_icon_tag"] forState:UIControlStateNormal];
	[buttonSetTag setImage:[UIImage imageNamed:@"tool_bar_icon_tag_s"] forState:UIControlStateSelected];
	[buttonSetTag addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
    buttonSetTag.tag = CreateEventTagAction;
	[self addSubview:buttonSetTag];
    
	UIButton *buttonSetDetail = [[[UIButton alloc] initWithFrame:CGRectMake(110, 0, 36, 44)] autorelease];
	[buttonSetDetail setImage:[UIImage imageNamed:@"tool_bar_icon_info"] forState:UIControlStateNormal];
	[buttonSetDetail setImage:[UIImage imageNamed:@"tool_bar_icon_info_s"] forState:UIControlStateSelected];
	[buttonSetDetail addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
    buttonSetDetail.tag = CreateEventDetailAction;
	[self addSubview:buttonSetDetail];
    
	UIButton *buttonSetMember = [[[UIButton alloc] initWithFrame:CGRectMake(160, 0, 36, 44)] autorelease];
	[buttonSetMember setImage:[UIImage imageNamed:@"tool_bar_icon_people"] forState:UIControlStateNormal];
	[buttonSetMember setImage:[UIImage imageNamed:@"tool_bar_icon_people_s"] forState:UIControlStateSelected];
	[buttonSetMember addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchDown];
    buttonSetMember.tag = CreateEventMemberAction;
	[self addSubview:buttonSetMember];
    
	//switch
	FESwitch *privacySwitch = [[[FESwitch alloc] init] autorelease];
    privacySwitch.frame = CGRectMake(320-10-5-52, 12, 52, 23);
    [privacySwitch setToggleImage:[UIImage imageNamed:@"share_switch_bar"]];
    [privacySwitch setOutlineImage:[UIImage imageNamed:@"switch_inner_shadow"]];
    [privacySwitch setKnobImage:[UIImage imageNamed:@"switch_handle"]];
    [privacySwitch setOnImage:[UIImage imageNamed:@"share_switch_on"]];
    [privacySwitch setOffImage:[UIImage imageNamed:@"share_switch_off"]];
    [self addSubview:privacySwitch];
    privacySwitch.on = YES;
    [privacySwitch addTarget:self action:@selector(privacyChanged:) forControlEvents:UIControlEventValueChanged];
    
    _action = CreateEventNoneAction;
    _privacy = CreateEventPrivacyPrivate;
}

- (void)toggleButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if(_activeButton && _activeButton != sender){
        _activeButton.selected = NO;
    }
    _activeButton = sender;
    
    _action = sender.selected ? sender.tag : 0;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)resetAction
{
    if(_activeButton){
        _activeButton.selected = NO;
        _activeButton = nil;
    }
    _action = CreateEventNoneAction;
}

- (void)privacyChanged:(FESwitch *)sender
{
    _action = CreateEventPrivacyAction;
    _privacy = sender.on ? CreateEventPrivacyPublic : CreateEventPrivacyPrivate;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
