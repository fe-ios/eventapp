//
//  FELoginTableViewCell.m
//  EventApp
//
//  Created by zhenglin li on 12-7-13.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FELoginTableViewCell.h"

@implementation FELoginTableViewCell

@synthesize fieldLabel;
@synthesize fieldInput;

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

- (void)dealloc {
    [fieldLabel release];
    [fieldInput release];
    [super dealloc];
}
@end
