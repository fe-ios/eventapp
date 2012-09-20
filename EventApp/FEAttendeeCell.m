//
//  FEAttendeeCell.m
//  EventApp
//
//  Created by zhenglin li on 12-9-19.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEAttendeeCell.h"

@interface FEAttendeeCell ()

@property(nonatomic, retain) UIButton *confirmButton;
@property(nonatomic, retain) UIButton *rejectButton;
@property(nonatomic, retain) UIImageView *approvedMark;

@end

@implementation FEAttendeeCell

@synthesize nameLabel, avatarView, type, controller, index;
@synthesize confirmButton, rejectButton, approvedMark;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [nameLabel release];
    [avatarView release];
    [confirmButton release];
    [rejectButton release];
    [approvedMark release];
    [controller release];
    [super dealloc];
}

- (void)setup
{
    UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
	[separator setImage:[UIImage imageNamed:@"attendee_separator"]];
	[self.contentView addSubview:separator];
    
    self.avatarView = [[UIAsyncImageView alloc] init];
    self.avatarView.frame = CGRectMake(4, 4, 36, 36);
    [self.contentView addSubview:self.avatarView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 14, 160, 20)];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
	[self.contentView addSubview:self.nameLabel];
    
}

- (void)setType:(AttendeeCellType)newType
{
    if(type == newType) return;
    type = newType;
    
    if(self.type == AttendeeCellTypeApproved){
        [self.rejectButton removeFromSuperview];
        [self.rejectButton removeTarget:self action:@selector(reject) forControlEvents:UIControlEventTouchUpInside];
        self.rejectButton = nil;
        [self.confirmButton removeFromSuperview];
        [self.confirmButton removeTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        self.confirmButton = nil;
        
        self.approvedMark = [[UIImageView alloc] initWithFrame:CGRectMake(320-24-10, 10, 24, 24)];
        self.approvedMark.image = [UIImage imageNamed:@"checkmark"];
        [self.contentView addSubview:self.approvedMark];
    }else {
        [self.approvedMark removeFromSuperview];
        self.approvedMark = nil;
        
        self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(320-10-56, 8, 56, 28)];
        [self.confirmButton setBackgroundImage:[[UIImage imageNamed:@"attendee_btn_approve"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 16, 14, 16)] forState:UIControlStateNormal];
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [self.contentView addSubview:self.confirmButton];
        [self.confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        self.rejectButton = [[UIButton alloc] initWithFrame:CGRectMake(320-10-56-5-56, 8, 56, 28)];
        [self.rejectButton setBackgroundImage:[[UIImage imageNamed:@"attendee_btn_reject"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 16, 14, 16)] forState:UIControlStateNormal];
        self.rejectButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.rejectButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [self.contentView addSubview:self.rejectButton];
        [self.rejectButton addTarget:self action:@selector(reject) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)confirm
{
    if(self.controller != nil && [self.controller respondsToSelector:@selector(confirm:)]){
        [self.controller performSelector:@selector(confirm:) withObject:[NSNumber numberWithInt:self.index]];
    }
}

- (void)reject
{
    if(self.controller != nil && [self.controller respondsToSelector:@selector(reject:)]){
        [self.controller performSelector:@selector(reject:) withObject:[NSNumber numberWithInt:self.index]];
    }
}


@end
