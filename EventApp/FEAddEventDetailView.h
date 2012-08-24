//
//  FEAddEventDetailView.h
//  EventApp
//
//  Created by zhenglin li on 12-8-23.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FEAddEventDetailViewDelegate <NSObject>

@optional
- (void)handleDetailDidChange:(NSString *)detail;

@end

@interface FEAddEventDetailView : UIScrollView <UITextViewDelegate>


@property(nonatomic, retain) UITextView *detailInput;
@property(nonatomic, assign) NSObject<FEAddEventDetailViewDelegate> *detailDelegate;

- (void)recoverLastInputAsFirstResponder;

@end