//
//  FEProfileSettingsViewController.h
//  EventApp
//
//  Created by Yin Zhengbo on 9/19/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEProfileSettingsViewController : UITableViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImageView *userAvatar;
@property (strong, nonatomic) UIActionSheet *photoActionSheet;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end
