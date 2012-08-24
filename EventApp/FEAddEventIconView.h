//
//  FEAddEventIconView.h
//  EventApp
//
//  Created by zhenglin li on 12-8-15.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEAddEventIconView : UIScrollView <UIKeyInput>

@property(nonatomic, assign) UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> *pickerDelegate;

- (void)setPreviewImage:(UIImage *)newImage;

@end
