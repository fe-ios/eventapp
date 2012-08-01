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
    //self.backgroundView.frame = CGRectMake(10, 10, 320-10*2, 125);
    self.backgroundView.frame = CGRectMake(0, 0, 320, 80);
}

@end
