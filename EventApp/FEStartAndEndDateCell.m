//
//  FEStartAndEndDateCell.m
//  EventApp
//
//  Created by zhenglin li on 12-8-14.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEStartAndEndDateCell.h"

@implementation FEStartAndEndDateCell

@synthesize startInput;
@synthesize endInput;

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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:NO animated:animated];
}

- (void)dealloc
{
    [startInput release];
    [endInput release];
    [super dealloc];
}

@end
