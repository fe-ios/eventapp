//
//  FEEventTableViewCell.m
//  EventApp
//
//  Created by zhenglin li on 12-7-19.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEEventTableViewCell.h"

@implementation FEEventTableViewCell
@synthesize eventNameLabel;
@synthesize eventDateLabel;
@synthesize eventTagLabel;
@synthesize eventIcon;
@synthesize watchButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];
}

- (void)dealloc
{
    [eventNameLabel release];
    [watchButton release];
    [eventIcon release];
    [eventDateLabel release];
    [eventTagLabel release];
    [super dealloc];
}

- (void)layoutSubviews
{
    self.backgroundView.frame = CGRectMake(0, 0, 320, 138);
}

@end
