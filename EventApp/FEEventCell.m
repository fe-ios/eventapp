//
//  FEEventCell.m
//  EventApp
//
//  Created by zhenglin li on 12-7-19.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEEventCell.h"

@implementation FEEventCell

@synthesize bgImage = _bgImage;

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

//- (void)drawRect:(CGRect)rect
//{
//    if(!self.bgImage){
//        self.bgImage = [UIImage imageNamed:@"eventCellBackground"];
//    }
//    [self.bgImage drawAtPoint:CGPointMake(0, 0)];
//}

@end
