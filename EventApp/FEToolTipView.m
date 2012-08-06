//
//  FEToolTipView.m
//  EventApp
//
//  Created by zhenglin li on 12-8-3.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEToolTipView.h"

@interface FEToolTipView()
{
    UIImageView* _backgroundView;
}

@end

@implementation FEToolTipView

@synthesize backgroundImage = _backgroundImage;
@synthesize backgroundView = _backgroundView;
@synthesize label = _label;
@synthesize text = _text;
@synthesize maxWidth = _maxWidth;
@synthesize edgeInsets = _edgeInsets;
@synthesize align = _align;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.edgeInsets = UIEdgeInsetsMake(14, 10, 8, 10);
    self.align = ToolTipAlignBottomRight;
    self.maxWidth = 200;
    
    UIImageView *bgImage = [[[UIImageView alloc] init] autorelease];
    bgImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:bgImage];
    self.backgroundView = bgImage;
    
    self.label = [[[UILabel alloc] init] autorelease];
    self.label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.label.font = [UIFont systemFontOfSize:13.0];
    self.label.numberOfLines = 2;
    self.label.minimumFontSize = 11.0;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.lineBreakMode = UILineBreakModeWordWrap;
    self.label.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    self.label.shadowOffset = CGSizeMake(0.0, 1.0);
    [self addSubview:self.label];
}

- (void)setText:(NSString *)text
{
    [_text release];
    _text = [text copy];
    _label.text = _text;
    [self updateSize];
}

- (void)setBackgroundImage:(UIImage *)image
{
    _backgroundView.image = image;
    CGRect rect = self.frame;
    rect.size.width = image.size.width;
    rect.size.height = image.size.height;
    self.frame = rect;
    [self updateSize];
}

- (void)updateSize
{
    CGSize size = [_label.text sizeWithFont:_label.font];
    if(size.width > _maxWidth - _edgeInsets.left - _edgeInsets.right){
        size = [_label.text sizeWithFont:_label.font constrainedToSize:CGSizeMake(_maxWidth - _edgeInsets.left - _edgeInsets.right, 9999) lineBreakMode:_label.lineBreakMode];
    }
    _label.frame = CGRectMake(_edgeInsets.left, _edgeInsets.top, size.width, size.height);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width + _edgeInsets.left + _edgeInsets.right, size.height + _edgeInsets.top + _edgeInsets.bottom);
    _backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

-(void)showAtPoint:(CGPoint)point inView:(UIView *)view
{
    CGRect rect = self.frame;
    rect.origin.x = point.x;
    rect.origin.y = point.y;
    self.frame = rect;
    if(view != nil){
        [view addSubview:self];
    }
}

@end
