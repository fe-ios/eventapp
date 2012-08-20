//
//  FEAddEventView.h
//  EventApp
//
//  Created by zhenglin li on 12-8-17.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FECreateEventToolbar.h"

@interface FEAddEventView : UITableView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>


@property(nonatomic, retain) FECreateEventToolbar *toolbar;
@property(nonatomic, assign) BOOL autoFocusFirstInput;

- (void)recoverLastInputAsFirstResponder;

- (BOOL)validateInput: (NSInteger)textFieldTag text:(NSString *)text showTip:(BOOL)showTip;

- (NSMutableDictionary *)getInputData;

@end
