//
//  FEDetailViewCell.m
//  EventApp
//
//  Created by zhenglin li on 12-9-6.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEDetailViewCell.h"

@implementation FEDetailViewCell

@synthesize imageAlign;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageAlign == UIViewContentModeTop) {
        CGRect frame = self.imageView.frame;
        self.imageView.frame = CGRectMake(frame.origin.x, 12, frame.size.width, frame.size.height);
    }
}


@end
