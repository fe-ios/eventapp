//
//  FEAddEventDetailView.m
//  EventApp
//
//  Created by zhenglin li on 12-8-23.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEAddEventDetailView.h"

@interface FEAddEventDetailView()

@property(nonatomic, retain) UIImageView *detailInputBg;
@property(nonatomic, retain) UILabel *detailPlaceholder;

@end

@implementation FEAddEventDetailView

@synthesize detailInput = _detailInput, detailInputBg = _detailInputBg, detailPlaceholder = _detailPlaceholder, detailDelegate = _detailDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [_detailInput release];
    [_detailInputBg release];
    [_detailPlaceholder release];
    [super dealloc];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.alwaysBounceVertical = YES;
	
    self.detailInputBg = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"roundTableCellSingle"] resizableImageWithCapInsets:UIEdgeInsetsMake(23, 15, 23, 15)]] autorelease];
    [self addSubview:self.detailInputBg];
    
    self.detailInput = [[[UITextView alloc] init] autorelease];
    self.detailInput.backgroundColor = [UIColor clearColor];
    self.detailInput.font = [UIFont systemFontOfSize:14.0];
    self.detailInput.delegate = self;
    [self addSubview:self.detailInput];
    
    self.detailPlaceholder = [[[UILabel alloc] init] autorelease];
    self.detailPlaceholder.backgroundColor = [UIColor clearColor];
    self.detailPlaceholder.font = [UIFont systemFontOfSize:14.0];
    self.detailPlaceholder.textColor = [UIColor lightGrayColor];
    self.detailPlaceholder.text = @"请输入活动详细信息 ...";
    [self addSubview:self.detailPlaceholder];
}

#pragma mark - TextView delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if([textView.text isEqualToString:@""]){
        self.detailPlaceholder.hidden = NO;
    }else {
        self.detailPlaceholder.hidden = YES;
    }
    
    [self.detailDelegate handleDetailDidChange:textView.text];
}

- (void)recoverLastInputAsFirstResponder
{
    [_detailInput becomeFirstResponder];
}

- (void)layoutSubviews
{
    CGRect rect = self.bounds;
    
    self.detailInputBg.frame = CGRectMake(0, 10, rect.size.width, rect.size.height-16);
    self.detailInput.frame = CGRectMake(self.detailInputBg.frame.origin.x+10, self.detailInputBg.frame.origin.y+5, self.detailInputBg.frame.size.width-10*2, self.detailInputBg.frame.size.height-5);
    self.detailPlaceholder.frame = CGRectMake(self.detailInput.frame.origin.x+10, self.detailInput.frame.origin.y+6, self.detailInput.frame.size.width-10*2, 21);
}

@end
