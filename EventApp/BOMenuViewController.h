//
//  BOMenuViewController.h
//  EventApp
//
//  Created by Yin Zhengbo on 7/19/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) UIButton *userAvatar;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UIButton *btnAddEvent;
@property (strong, nonatomic) UIButton *btnSignup;
@property (strong, nonatomic) UIButton *btnLogin;
@property (strong, nonatomic) UIButton *btnLogout;

@property (assign, nonatomic) int selectedMenu;

@end
