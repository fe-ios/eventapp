//
//  BOEventQuickAddViewController.h
//  Events
//
//  Created by Yin Zhengbo on 7/13/12.
//  Copyright (c) 2012 SNDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAKeyboardControlView.h"
#import "BOEventQuickAddInputAccessoryView.h"

@interface BOEventQuickAddViewController : UIViewController<UITextViewDelegate>

@property (strong,nonatomic) BOEventQuickAddInputAccessoryView *toolbar;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)eventSave:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UITextView *textViewInput;
@property (strong, nonatomic) IBOutlet DAKeyboardControlView *inputViewBackground;

@end
