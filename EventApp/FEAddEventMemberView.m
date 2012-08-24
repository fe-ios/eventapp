//
//  FEAddEventMemberView.m
//  EventApp
//
//  Created by zhenglin li on 12-8-23.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEAddEventMemberView.h"

@implementation FEAddEventMemberView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.alwaysBounceVertical = YES;
}

#pragma mark - UIKeyInput

- (void)deleteBackward
{
    return;
}

- (BOOL)hasText
{
    return NO;
}

- (void)insertText:(NSString *)text
{
    return;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
