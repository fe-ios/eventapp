//
//  FEEventTableViewCell.h
//  EventApp
//
//  Created by zhenglin li on 12-7-19.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEEventTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *eventImage1;
@property (retain, nonatomic) IBOutlet UIImageView *eventImage2;
@property (retain, nonatomic) IBOutlet UIImageView *eventImage3;
@property (retain, nonatomic) IBOutlet UIImageView *eventImage4;

@property (retain, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *peopleCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *pictureCountLabel;

@end
