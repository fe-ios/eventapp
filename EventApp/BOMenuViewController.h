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
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end
