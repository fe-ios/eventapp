//
//  FEAddEventIconView.m
//  EventApp
//
//  Created by zhenglin li on 12-8-15.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEAddEventIconView.h"
#import <QuartzCore/QuartzCore.h>

@interface FEAddEventIconView()

@property(nonatomic, retain) UIImageView *previewImageView;

@end

@implementation FEAddEventIconView

@synthesize pickerDelegate = _pickerDelegate;
@synthesize previewImageView = _previewImageView;

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

- (void)dealloc
{
    [_previewImageView release];
    [super dealloc];
}

- (void)initView
{
    //undertoolbar
//    UIImageView *underKeyboard = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)] autorelease];
//    [underKeyboard setImage:[UIImage imageNamed:@"actionsheetBg2"]];
//    [self addSubview:underKeyboard];
    
    self.backgroundColor = [UIColor clearColor];
    self.alwaysBounceVertical = YES;
    
    UIImageView *iconBg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bg"]] autorelease];
    iconBg.frame = CGRectMake(30, 20, 120, 120);
    [self addSubview:iconBg];
    
    self.previewImageView = [[[UIImageView alloc] init] autorelease];
    self.previewImageView.frame = CGRectMake(31, 21, 118, 118);
    [self addSubview:self.previewImageView];
    
    //photoPicker Button
    UIButton *pickFromCamera = [[[UIButton alloc] initWithFrame:CGRectMake(195, 18, 88, 60)] autorelease];
    [pickFromCamera setImage:[UIImage imageNamed:@"button_photo_camera2"] forState:UIControlStateNormal];
    [pickFromCamera setImage:[UIImage imageNamed:@"button_photo_camera2_pressed"] forState:UIControlStateHighlighted];
    pickFromCamera.tag = 1;
    [self addSubview:pickFromCamera];
    [pickFromCamera addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *pickFromLibrary = [[[UIButton alloc] initWithFrame:CGRectMake(195, 80, 88, 60)] autorelease];
    [pickFromLibrary setImage:[UIImage imageNamed:@"button_photo_library2"] forState:UIControlStateNormal];
    [pickFromLibrary setImage:[UIImage imageNamed:@"button_photo_library2_pressed"] forState:UIControlStateHighlighted];
    pickFromLibrary.tag = 2;
    [self addSubview:pickFromLibrary];
    [pickFromLibrary addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectImage:(UIButton *)sender
{
    UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    UIImagePickerControllerSourceType type = sender.tag == 1 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.sourceType = type;
    imagePicker.delegate = self.pickerDelegate;
    [self.pickerDelegate.navigationController presentModalViewController:imagePicker animated:YES];
    
    if(type == UIImagePickerControllerSourceTypeSavedPhotosAlbum){
        //make the status bar back to black style
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
        
        //clip the picker to match our rounded navigation bar
        CALayer *pickerLayer = [imagePicker.view.layer.sublayers objectAtIndex:0];
        CAShapeLayer *clipLayer = [[[CAShapeLayer alloc] init] autorelease];
        clipLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 20, pickerLayer.frame.size.width, pickerLayer.frame.size.height-20) cornerRadius:8.0].CGPath;
        pickerLayer.mask = clipLayer;
    }
}

- (void)setPreviewImage:(UIImage *)newImage
{
    self.previewImageView.image = newImage;
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
