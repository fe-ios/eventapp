//
//  FELoginView.m
//  EventApp
//
//  Created by zhenglin li on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FELoginView.h"

@implementation FELoginView
@synthesize nameField;
@synthesize passwordField;
@synthesize loginButton;
@synthesize goRegisterButton;

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
    [loginButton release];
    [goRegisterButton release];
    [super dealloc];
    
}

@end
