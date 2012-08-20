//
//  FEAddEventIconView.m
//  EventApp
//
//  Created by zhenglin li on 12-8-15.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEAddEventIconView.h"

@implementation FEAddEventIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initView];
    }
    return self;
}

- (void)initView
{
    //undertoolbar
    UIImageView *underKeyboard = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)] autorelease];
    [underKeyboard setImage:[UIImage imageNamed:@"actionsheetBg2"]];
    [self addSubview:underKeyboard];
    
    //photoPicker Button
    UIButton *pickFromCamera = [[[UIButton alloc] initWithFrame:CGRectMake(55, 76, 88, 60)] autorelease];
    [pickFromCamera setImage:[UIImage imageNamed:@"button_photo_camera2"] forState:UIControlStateNormal];
    [pickFromCamera setImage:[UIImage imageNamed:@"button_photo_camera2_pressed"] forState:UIControlStateHighlighted];
    [self addSubview:pickFromCamera];
    
    UIButton *pickFromLibrary = [[[UIButton alloc] initWithFrame:CGRectMake(182, 76, 88, 60)] autorelease];
    [pickFromLibrary setImage:[UIImage imageNamed:@"button_photo_library2"] forState:UIControlStateNormal];
    [pickFromLibrary setImage:[UIImage imageNamed:@"button_photo_library2_pressed"] forState:UIControlStateHighlighted];
    [self addSubview:pickFromLibrary];
}

@end
