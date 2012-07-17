//
//  FEActionSheet.h
//  EventApp
//
//  Created by zhenglin li on 12-7-16.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEActionSheet : UIActionSheet


@property(nonatomic, retain) UIImage *backgroundImage;

-(UIButton *) buttonAtIndex: (int) index;


@end
