//
//  FEEventTableViewCell.m
//  EventApp
//
//  Created by zhenglin li on 12-7-19.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEEventTableViewCell.h"

@implementation FEEventTableViewCell
@synthesize eventImage1;
@synthesize eventImage2;
@synthesize eventImage3;
@synthesize eventImage4;
@synthesize eventNameLabel;
@synthesize peopleCountLabel;
@synthesize pictureCountLabel;

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
    [eventImage1 release];
    [eventImage2 release];
    [eventImage3 release];
    [eventImage4 release];
    [eventNameLabel release];
    [peopleCountLabel release];
    [pictureCountLabel release];
    [super dealloc];
}

- (void)layoutSubviews
{
    self.backgroundView.frame = CGRectMake(5, 0, 310, 189);
}

@end
