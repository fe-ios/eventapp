//
//  FEAddEventView.h
//  EventApp
//
//  Created by zhenglin li on 12-8-17.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FECreateEventToolbar.h"
#import "FEEvent.h"

@protocol FEAddEventViewDelegate <NSObject>

@optional
- (void)handleBasicDataDidChange:(NSMutableDictionary *)basicData completed:(BOOL)completed;
- (void)handleBasicViewDidReturn;

@end

@interface FEAddEventView : UITableView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property(nonatomic, retain) FECreateEventToolbar *toolbar;
@property(nonatomic, assign) BOOL autoFocusFirstInput;
@property(nonatomic, assign) NSObject<FEAddEventViewDelegate> *basicDelegate;
@property(nonatomic, assign) BOOL changed;

- (id)initWithEvent:(FEEvent *)aEvent;

- (void)recoverLastInputAsFirstResponder;

- (BOOL)validateInput: (NSInteger)textFieldTag text:(NSString *)text showTip:(BOOL)showTip;

- (NSMutableDictionary *)getInputData;

@end
