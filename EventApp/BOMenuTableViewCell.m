//
//  BOMenuTableViewCell.m
//  EventApp
//
//  Created by Yin Zhengbo on 7/20/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import "BOMenuTableViewCell.h"

@implementation BOMenuTableViewCell

@synthesize backgroundImageView,menuLabel,detailLabel,menuIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"menuCellBackground"];
		backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
		[backgroundImageView setFrame:CGRectMake(0, 0, 320, 44)];
		self.backgroundView = backgroundImageView;
		menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 100, 24)];
		menuLabel.backgroundColor = [UIColor clearColor];
		menuLabel.shadowColor = [UIColor blackColor];
		menuLabel.shadowOffset = CGSizeMake(0, 1);
		menuLabel.textColor = [UIColor whiteColor];
		menuIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 21, 25)];
		[self.contentView addSubview:menuIcon];
		[self.contentView addSubview:menuLabel];
    }
    return self;
}

- (void)layoutSubviews
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	UIView *bgColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	[bgColorView setBackgroundColor:[UIColor colorWithRed:116.0/255.0 green:179.0/255.0 blue:25.0/255.0 alpha:1.0f]];
	[self setSelectedBackgroundView:bgColorView];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:NO animated:animated];
}

@end
