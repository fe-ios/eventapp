//
//  FEProfileViewController.h
//  EventApp
//
//  Created by Yin Zhengbo on 9/18/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEProfileViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *profileTabAttendButton;
@property (retain, nonatomic) IBOutlet UIButton *profileTabOrgButton;

- (IBAction)profileTabAttend:(UIButton *)sender;
- (IBAction)profileTabOrg:(UIButton *)sender;

@end
