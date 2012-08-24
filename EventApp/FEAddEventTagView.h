//
//  FEAddEventTagView.h
//  EventApp
//
//  Created by zhenglin li on 12-8-17.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSTokenField.h"

@protocol FEAddEventTagViewDelegate <NSObject>

@optional
- (void)handleTagDidChange:(NSMutableArray *)tags;

@end

@interface FEAddEventTagView : UIScrollView <JSTokenFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) NSMutableArray *tags;
@property(nonatomic, retain) NSMutableArray *searchTagData;
@property(nonatomic, assign) NSObject <FEAddEventTagViewDelegate> *tagDelegate;

- (void)recoverLastInputAsFirstResponder;

@end