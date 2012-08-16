//
//  FESwitch.m
//  EventApp
//
//  Created by zhenglin li on 12-8-15.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FESwitch.h"

@interface FESwitch () <UIGestureRecognizerDelegate>

@property (nonatomic, retain) CALayer *outlineLayer;
@property (nonatomic, retain) CALayer *toggleLayer;
@property (nonatomic, retain) CALayer *knobLayer;
@property (nonatomic, retain) CAShapeLayer *clipLayer;
@property (nonatomic, assign) BOOL ignoreTap;

@end

@implementation FESwitch

@synthesize on;
@synthesize outlineLayer, toggleLayer, knobLayer, clipLayer, ignoreTap;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, 52, 23);
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
    self.backgroundColor = [UIColor clearColor];
    
    UIImage *toggleImage = [UIImage imageNamed:@"share_switch_bar"];
    self.toggleLayer = [[[CALayer alloc] init] autorelease];
    self.toggleLayer.frame = CGRectMake(0, 0, toggleImage.size.width, toggleImage.size.height);
    self.toggleLayer.contents = (id)toggleImage.CGImage;
    [self.layer addSublayer:self.toggleLayer];
    
    
    UIImage *outlineImage = [UIImage imageNamed:@"switch_inner_shadow"];
    self.outlineLayer = [[[CALayer alloc] init] autorelease];
    self.outlineLayer.frame = CGRectMake(0, 0, outlineImage.size.width, outlineImage.size.height);
    self.outlineLayer.contents = (id)outlineImage.CGImage;
	[self.layer addSublayer:self.outlineLayer];
    
    UIImage *knobImage = [UIImage imageNamed:@"switch_handle"];
    self.knobLayer = [[[CALayer alloc] init] autorelease];
    self.knobLayer.frame = CGRectMake(0, 0, knobImage.size.width, knobImage.size.height);
    self.knobLayer.contents = (id)knobImage.CGImage;
	[self.layer addSublayer:self.knobLayer];
    
    NSLog(@"switch1: %@", NSStringFromCGRect(self.bounds));
    self.clipLayer = [CAShapeLayer layer];
	UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.height / 2.0];
	self.clipLayer.path = clipPath.CGPath;
    self.toggleLayer.mask = self.clipLayer;
    
    [self positionLayersAndMask];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDragged:)] autorelease];
	panGestureRecognizer.delegate = self;
	[self addGestureRecognizer:panGestureRecognizer];
}

- (void)positionLayersAndMask
{
	self.toggleLayer.mask.position = CGPointMake(-self.toggleLayer.frame.origin.x, 0.0);
	self.outlineLayer.frame = CGRectMake(-self.toggleLayer.frame.origin.x, 0, self.bounds.size.width, self.bounds.size.height);
	self.knobLayer.frame = CGRectMake(self.toggleLayer.frame.origin.x + self.toggleLayer.frame.size.width*0.5 - self.knobLayer.frame.size.width*0.5+1,
                                      0,
                                      self.knobLayer.frame.size.width,
                                      self.knobLayer.frame.size.height);
}

- (void)toggleDragged:(UIPanGestureRecognizer *)

- (void)setOn:(BOOL)newOn animated:(BOOL)animated
{
    
}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-self.frame.origin.x + 0.5, 0, self.bounds.size.width / 2.0 + self.bounds.size.height / 2.0 - 1.5, self.bounds.size.height) cornerRadius:self.bounds.size.height / 2.0];
//    CGContextAddPath(context, bezierPath.CGPath);
//    CGContextClip(context);
//    NSLog(@"switch drawrect: %@", NSStringFromCGRect(rect));
//    //[super drawRect:rect];
//}

@end
