//
//  FEToolTipView.h
//  EventApp
//
//  Created by zhenglin li on 12-8-3.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _ToolTipAlignment{
	ToolTipAlignTopLeft = 0,
	ToolTipAlignTopCenter = 1,
	ToolTipAlignTopRight = 2,
    ToolTipAlignBottomLeft = 3,
    ToolTipAlignBottomCenter = 4,
    ToolTipAlignBottomRight = 5
} ToolTipAlignment;

@interface FEToolTipView : UIView

@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UIImage *backgroundImage;
@property(nonatomic, retain) UIView *backgroundView;

@property(nonatomic, copy) NSString *text;
@property(nonatomic, assign) float maxWidth;
@property(nonatomic, assign) UIEdgeInsets edgeInsets;
@property(nonatomic, assign) ToolTipAlignment align;

-(void)showAtPoint:(CGPoint)point inView:(UIView *)view;

@end
