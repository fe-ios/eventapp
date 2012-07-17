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
		[buttonA addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
		[buttonA setFrame:CGRectMake(0, 0, 32, 32)];
		[toolbar addSubview:buttonA];
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
