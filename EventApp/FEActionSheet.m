//
//  FEActionSheet.m
//  EventApp
//
//  Created by zhenglin li on 12-7-16.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEActionSheet.h"
#import <QuartzCore/QuartzCore.h>

@implementation FEActionSheet

@synthesize backgroundImage = _backgroundImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) dealloc
{
    [_backgroundImage release];
    [super dealloc];
}

- (void) drawRect:(CGRect)rect
{
    if(self.backgroundImage){
        UIGraphicsGetCurrentContext();
        [self.backgroundImage drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    }
}

-(UIButton *) buttonAtIndex: (int) index
{
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        if (i == index + 1 && [view isKindOfClass:NSClassFromString(@"UIButton")]) {
            return (UIButton *) view;
        }
    }
    
    return nil;
}


@end
