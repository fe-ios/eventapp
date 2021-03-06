//
//  FEAddEventIconView.m
//  EventApp
//
//  Created by zhenglin li on 12-8-15.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEAddEventIconView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIAsyncImageView.h"

@interface FEAddEventIconView()

@property(nonatomic, retain) UIAsyncImageView *previewImageView;

@end

@implementation FEAddEventIconView

@synthesize pickerDelegate = _pickerDelegate;
@synthesize previewImageView = _previewImageView;
@synthesize changed = _changed;

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

- (id)initWithEvent:(FEEvent *)event
{
    self = [super init];
    if(self){
        if(event.logoURL && ![event.logoURL isEqualToString:@""]){
            [self.previewImageView loadImageAsync:event.logoURL withQueue:nil];
        }
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
    iconBg.frame = CGRectMake(30, 19, 120, 120);
    [self addSubview:iconBg];
    
    self.previewImageView = [[[UIAsyncImageView alloc] init] autorelease];
    self.previewImageView.frame = CGRectMake(31, 20, 118, 118);
    [self addSubview:self.previewImageView];
    
    //photoPicker Button
    UIButton *pickFromCamera = [[[UIButton alloc] initWithFrame:CGRectMake(200, 18, 79, 54)] autorelease];
    [pickFromCamera setImage:[UIImage imageNamed:@"button_photo_camera"] forState:UIControlStateNormal];
    [pickFromCamera setImage:[UIImage imageNamed:@"button_photo_camera_pressed"] forState:UIControlStateHighlighted];
    pickFromCamera.tag = 1;
    [self addSubview:pickFromCamera];
    [pickFromCamera addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *pickFromLibrary = [[[UIButton alloc] initWithFrame:CGRectMake(200, 86, 79, 54)] autorelease];
    [pickFromLibrary setImage:[UIImage imageNamed:@"button_photo_library"] forState:UIControlStateNormal];
    [pickFromLibrary setImage:[UIImage imageNamed:@"button_photo_library_pressed"] forState:UIControlStateHighlighted];
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
    _changed = YES;
}

- (UIImage *)getPreviewImage
{
    return self.previewImageView.image;
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
