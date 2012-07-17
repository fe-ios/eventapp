//
//  BOEventQuickAddInputAccessoryView.m
//  Events
//
//  Created by Yin Zhengbo on 7/16/12.
//  Copyright (c) 2012 SNDA. All rights reserved.
//

#import "BOEventQuickAddInputAccessoryView.h"

@implementation BOEventQuickAddInputAccessoryView

@synthesize toolbar,toolbarBackground;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.toolbar = [[UIToolbar alloc] initWithFrame:frame];
		//bg
		self.toolbarBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WKToolbarBackground"]];
		[toolbarBackground setFrame:frame];
		[self.toolbar insertSubview:toolbarBackground atIndex:1];
		//buttons
		UIButton *buttonA =  [UIButton buttonWithType:UIButtonTypeCustom];
		[buttonA setImage:[UIImage imageNamed:@"WKIconDate"] forState:UIControlStateNormal];
		[buttonA setImage:[UIImage imageNamed:@"WKIconDateSelected"] forState:UIControlStateSelected];
		[buttonA addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
		[buttonA setFrame:CGRectMake(10, 6, 32, 32)];
		[toolbar addSubview:buttonA];

		UIButton *buttonB =  [UIButton buttonWithType:UIButtonTypeCustom];
		[buttonB setImage:[UIImage imageNamed:@"WKIconHuman"] forState:UIControlStateNormal];
		[buttonB setImage:[UIImage imageNamed:@"WKIconHumanSelected"] forState:UIControlStateSelected];
		[buttonB addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
		[buttonB setFrame:CGRectMake(71, 6, 32, 32)];
		[toolbar addSubview:buttonB];

		UIButton *buttonC =  [UIButton buttonWithType:UIButtonTypeCustom];
		[buttonC setImage:[UIImage imageNamed:@"WKIconList"] forState:UIControlStateNormal];
		[buttonC setImage:[UIImage imageNamed:@"WKIconListSelected"] forState:UIControlStateSelected];
		[buttonC addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
		[buttonC setFrame:CGRectMake(138, 6, 32, 32)];
		[toolbar addSubview:buttonC];

		UIButton *buttonD =  [UIButton buttonWithType:UIButtonTypeCustom];
		[buttonD setImage:[UIImage imageNamed:@"WKIconTag"] forState:UIControlStateNormal];
		[buttonD setImage:[UIImage imageNamed:@"WKIconTagSelected"] forState:UIControlStateSelected];
		[buttonD addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
		[buttonD setFrame:CGRectMake(205, 6, 32, 32)];
		[toolbar addSubview:buttonD];

		UIButton *buttonE =  [UIButton buttonWithType:UIButtonTypeCustom];
		[buttonE setImage:[UIImage imageNamed:@"WKIconStar"] forState:UIControlStateNormal];
		[buttonE setImage:[UIImage imageNamed:@"WKIconStarSelected"] forState:UIControlStateSelected];
		[buttonE addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
		[buttonE setFrame:CGRectMake(272, 6, 32, 32)];
		[toolbar addSubview:buttonE];
		
		//NSArray *buttons = [NSArray arrayWithObjects:button,flex,buttonB,flex,buttonC,flex,buttonD,flex,buttonE, nil];
		//self.toolbar.items = buttons;
		
		[self addSubview:self.toolbar];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
