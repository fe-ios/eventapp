//
//  BOMenuTableViewCell.m
//  EventApp
//
//  Created by Yin Zhengbo on 7/20/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import "BOMenuTableViewCell.h"

@implementation BOMenuTableViewCell

@synthesize backgroundImageView,menuLabel,detailLabel,menuIcon,menuIconHighlighted,menuSeparator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//      UIImage *backgroundImage = [UIImage imageNamed:@"menuCellBackground"];
//		backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
//		[backgroundImageView setFrame:CGRectMake(0, 0, 320, 44)];
//		self.backgroundView = backgroundImageView;
		menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 10, 100, 24)];
		[menuLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
		menuLabel.backgroundColor = [UIColor clearColor];
		menuLabel.shadowColor = [UIColor blackColor];
		menuLabel.shadowOffset = CGSizeMake(0, 1);
		menuLabel.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
		menuLabel.highlightedTextColor = [UIColor whiteColor];
		
		menuIcon = [[UIImageView alloc] initWithFrame:CGRectMake(25, 6, 30, 30)];
		menuIconHighlighted = [[UIImageView alloc] initWithFrame:CGRectMake(25, 6, 30, 30)];
		menuIconHighlighted.hidden = YES;
		
		menuSeparator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu-separator"]];
		[menuSeparator setFrame:CGRectMake(15, 41, 170, 3)];

		[self setSelectionStyle:UITableViewCellEditingStyleNone];
		[self.contentView addSubview:menuSeparator];
		[self.contentView addSubview:menuIcon];
		[self.contentView addSubview:menuIconHighlighted];
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
	[self.menuIconHighlighted setHidden:!selected];
	[menuLabel setHighlighted:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
	[self.menuIconHighlighted setHidden:!highlighted];
	[menuLabel setHighlighted:highlighted];
}

@end
