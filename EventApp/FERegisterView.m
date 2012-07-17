//
//  FERegisterView.m
//  EventApp
//
//  Created by zhenglin li on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FERegisterView.h"

@implementation FERegisterView
@synthesize nameField;
@synthesize passwordField;
@synthesize password2Field;
@synthesize registerButton;
@synthesize goLoginButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [nameField release];
    [passwordField release];
    [password2Field release];
    [registerButton release];
    [goLoginButton release];
    [super dealloc];
}

@end
