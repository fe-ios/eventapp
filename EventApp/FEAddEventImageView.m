//
//  FEAddEventImageView.m
//  EventApp
//
//  Created by zhenglin li on 12-8-15.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEAddEventImageView.h"

@implementation FEAddEventImageView

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
    [underKeyboard setImage:[UIImage imageNamed:@"actionsheetBg"]];
    [self addSubview:underKeyboard];
    
    UIImage *actionMaskImage = [[UIImage imageNamed:@"actionsheetMask"] resizableImageWithCapInsets:UIEdgeInsetsMake(100, 0, 100, 0)];
    UIImageView *actionMask = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)] autorelease];
    [actionMask setImage:actionMaskImage];
    [self addSubview:actionMask];
    
    //photoPicker Button
    UIButton *pickFromCamera = [[[UIButton alloc] initWithFrame:CGRectMake(55, 76, 85, 60)] autorelease];
    [pickFromCamera setImage:[UIImage imageNamed:@"button_photo_camera"] forState:UIControlStateNormal];
    [self addSubview:pickFromCamera];
    
    UIButton *pickFromLibrary = [[[UIButton alloc] initWithFrame:CGRectMake(182, 76, 85, 60)] autorelease];
    [pickFromLibrary setImage:[UIImage imageNamed:@"button_photo_library"] forState:UIControlStateNormal];
    [self addSubview:pickFromLibrary];
}

@end
