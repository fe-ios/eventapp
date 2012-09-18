//
//  FEAddEventIconView.h
//  EventApp
//
//  Created by zhenglin li on 12-8-15.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEEvent.h"

@interface FEAddEventIconView : UIScrollView <UIKeyInput>

@property(nonatomic, assign) UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> *pickerDelegate;
@property(nonatomic, assign) BOOL changed;

- (void)setPreviewImage:(UIImage *)newImage;
- (UIImage *)getPreviewImage;

- (id)initWithEvent:(FEEvent *)aEvent;


@end
