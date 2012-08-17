//
//  FESwitch.m
//  EventApp
//
//  Created by zhenglin li on 12-8-15.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FESwitch.h"

@interface FESwitch () <UIGestureRecognizerDelegate>

@property(nonatomic, retain) UIImage *toggleImage;
@property(nonatomic, retain) UIImage *onImage;
@property(nonatomic, retain) UIImage *offImage;

@property(nonatomic, retain) CALayer *toggleLayer;
@property(nonatomic, retain) CALayer *outlineLayer;
@property(nonatomic, retain) CALayer *knobLayer;
@property(nonatomic, retain) CAShapeLayer *clipLayer;

@property(nonatomic, assign) BOOL ignoreTap;
@property(nonatomic, assign) CGFloat originX;
@property(nonatomic, assign) CGFloat originY;
@property(nonatomic, assign) CGFloat clipWidth;
@property(nonatomic, assign) CGFloat clipHeight;

@end

@implementation FESwitch

@synthesize on = _on;
@synthesize toggleImage = _toggleImage, onImage = _onImage, offImage = _offImage;
@synthesize outlineLayer, toggleLayer, knobLayer, clipLayer;
@synthesize ignoreTap, originX, originY, clipWidth, clipHeight;

- (void)dealloc
{
    [_toggleImage release];
    [_onImage release];
    [_offImage release];
    
	[outlineLayer release];
	[toggleLayer release];
	[knobLayer release];
	[clipLayer release];
    
	[super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 60, 30);
        [self initView];
    }
    return self;
}

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

- (void)setToggleImage:(UIImage *)newImage
{
    if(newImage != _toggleImage){
        [_toggleImage release];
        _toggleImage = [newImage retain];
        self.toggleLayer.contents = (id)newImage.CGImage;
        
        CGFloat minToggleX = -newImage.size.width*0.5 + newImage.size.height*0.5;
        self.toggleLayer.frame = CGRectMake(minToggleX, 0, newImage.size.width, newImage.size.height);
        
        CGRect clipRect = CGRectMake(0, 0, self.toggleLayer.frame.size.width*0.5+self.toggleLayer.frame.size.height*0.5, self.toggleLayer.frame.size.height);
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:clipRect cornerRadius:clipRect.size.height*0.5];
        self.clipLayer.path = clipPath.CGPath;
        self.clipLayer.position = CGPointMake(-minToggleX, 0);
        self.clipWidth = clipRect.size.width;
        self.clipHeight = clipRect.size.height;
    }
}

- (void)setOnImage:(UIImage *)newImage
{
    if(newImage != _onImage){
        [_onImage release];
        _onImage = [newImage retain];
        if(self.on){
            [self changeSwitchImageForStatus:NO];
        }
    }
}

- (void)setOffImage:(UIImage *)newImage
{
    if(newImage != _offImage){
        [_offImage release];
        _offImage = [newImage retain];
        if(!self.on){
            [self changeSwitchImageForStatus:NO];
        }
    }
}

- (void)setOutlineImage:(UIImage *)newImage
{
    if(newImage != nil){
        self.outlineLayer.contents = (id)newImage.CGImage;
        self.outlineLayer.frame = CGRectMake(0, 0, newImage.size.width, newImage.size.height);
    }
}

- (void)setKnobImage:(UIImage *)newImage
{
    if(newImage != nil){
        self.knobLayer.contents = (id)newImage.CGImage;
        self.knobLayer.frame = CGRectMake(0, 0, newImage.size.width, newImage.size.height);
        [self positionKnobAndMask];
    }
}

- (void)changeSwitchImageForStatus:(BOOL)animationStatus
{
    if(animationStatus && _toggleImage != nil){
        self.toggleLayer.contents = (id)_toggleImage.CGImage;
    }else if(self.on && _onImage != nil){
        self.toggleLayer.contents = (id)_onImage.CGImage;
    }else if (!self.on && _offImage != nil) {
        self.toggleLayer.contents = (id)_offImage.CGImage;
    }
}

- (void)initView
{
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
    
    self.toggleLayer = [[[CALayer alloc] init] autorelease];
    [self.layer addSublayer:self.toggleLayer];
    self.clipLayer = [CAShapeLayer layer];
    self.toggleLayer.mask = self.clipLayer;
    self.outlineLayer = [[[CALayer alloc] init] autorelease];
	[self.layer addSublayer:self.outlineLayer];
    self.knobLayer = [[[CALayer alloc] init] autorelease];
	[self.layer addSublayer:self.knobLayer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDragged:)] autorelease];
	panGestureRecognizer.delegate = self;
	[self addGestureRecognizer:panGestureRecognizer];
}

- (void)positionKnobAndMask
{
    self.clipLayer.position = CGPointMake(self.originX-self.toggleLayer.frame.origin.x, 0);
	self.knobLayer.frame = CGRectMake(self.toggleLayer.frame.origin.x + self.toggleLayer.frame.size.width*0.5 - self.knobLayer.frame.size.width*0.5+1, self.knobLayer.frame.origin.y, self.knobLayer.frame.size.width, self.knobLayer.frame.size.height);
}

- (void)tapped:(UITapGestureRecognizer *)gesture
{
    if (self.ignoreTap) return;
    if(gesture.state == UIGestureRecognizerStateEnded){
        [self setOn:!self.on animated:YES];
    }
}

- (void)toggleDragged:(UIPanGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
        [CATransaction setDisableActions:YES];
		[self positionKnobAndMask];
	}else if (gesture.state == UIGestureRecognizerStateChanged)
	{
        [CATransaction setDisableActions:YES];
		[self changeSwitchImageForStatus:YES];

        CGPoint translation = [gesture translationInView:self];
		CGFloat newX = self.toggleLayer.frame.origin.x + translation.x;
        CGFloat minToggleX = self.originX-self.toggleLayer.frame.size.width*0.5 + self.toggleLayer.frame.size.height*0.5;
        CGFloat maxToggleX = self.originX;
		if (newX < minToggleX) newX = minToggleX;
		else if (newX > maxToggleX) newX = maxToggleX;
        
		self.toggleLayer.frame = CGRectMake(newX, self.toggleLayer.frame.origin.y, self.toggleLayer.frame.size.width, self.toggleLayer.frame.size.height);
        [self positionKnobAndMask];
		[gesture setTranslation:CGPointZero inView:self];
	}else if (gesture.state == UIGestureRecognizerStateEnded)
	{
		CGFloat toggleCenter = CGRectGetMidX(self.toggleLayer.frame);
        CGFloat switchCenter = self.originX+(self.toggleLayer.frame.size.width+self.toggleLayer.frame.size.height)*0.25;
		[self setOn:(toggleCenter > switchCenter) animated:YES];
	}
}

- (void)setOn:(BOOL)newOn animated:(BOOL)animated
{
    BOOL previousOn = _on;
	_on = newOn;
	self.ignoreTap = YES;
    
    if(animated) {
        [self changeSwitchImageForStatus:YES];
        [self positionKnobAndMask];
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    [CATransaction setCompletionBlock:^{
        self.ignoreTap = NO;
        [self changeSwitchImageForStatus:NO];
        if(previousOn != _on) [self sendActionsForControlEvents:UIControlEventValueChanged];
	}];
    
    CGFloat minToggleX = self.originX-self.toggleLayer.frame.size.width*0.5 + self.toggleLayer.frame.size.height*0.5;
    CGFloat maxToggleX = self.originX;
    if (self.on)
    {
        self.toggleLayer.frame = CGRectMake(maxToggleX, self.toggleLayer.frame.origin.y, self.toggleLayer.frame.size.width, self.toggleLayer.frame.size.height);
    }else
    {
        self.toggleLayer.frame = CGRectMake(minToggleX, self.toggleLayer.frame.origin.y, self.toggleLayer.frame.size.width, self.toggleLayer.frame.size.height);
    }
    [self positionKnobAndMask];
    
    [CATransaction commit];
}

- (void)setOn:(BOOL)newOn
{
    [self setOn:newOn animated:NO];
}

- (void)layoutSubviews
{
    BOOL needPosition = NO;
    
    switch (self.contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentCenter:
            self.originX = (self.bounds.size.width-self.clipWidth)*0.5;
            needPosition = YES;
            break;
            
        case UIControlContentHorizontalAlignmentRight:
            self.originX = self.bounds.size.width-self.clipWidth;
            needPosition = YES;
            break;
            
        default:
            break;
    }
    
    switch (self.contentVerticalAlignment) {
        case UIControlContentVerticalAlignmentCenter:
            self.originY = (self.bounds.size.height-self.clipHeight)*0.5;
            needPosition = YES;
            break;
        case UIControlContentVerticalAlignmentBottom:
            self.originY = self.bounds.size.height-self.clipHeight;
            needPosition = YES;
            break;
            
        default:
            break;
    }
    
    if(needPosition){
        self.toggleLayer.frame = CGRectOffset(self.toggleLayer.frame, self.originX, self.originY);
        self.outlineLayer.frame = CGRectOffset(self.outlineLayer.frame, self.originX, self.originY);
        self.knobLayer.frame = CGRectOffset(self.knobLayer.frame, self.originX, self.originY);
    }
}


@end
