//
//  FEMyEventDetailController.m
//  EventApp
//
//  Created by zhenglin li on 12-9-14.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEMyEventDetailController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+Helper.h"
#import "UIAsyncImageView.h"
#import "FEDetailViewCell.h"
#import "FETag.h"
#import "FEUser.h"

#define MAX_HEIGHT 2000

@interface FEMyEventDetailController ()

@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UIAsyncImageView *bannerImage;
@property (retain, nonatomic) UILabel *eventNameLabel;
@property (retain, nonatomic) UILabel *startDateLabel;
@property (retain, nonatomic) UILabel *endDateLabel;
@property (retain, nonatomic) UILabel *startTimeLabel;
@property (retain, nonatomic) UILabel *endTimeLabel;
@property (retain, nonatomic) UILabel *venueLabel;
@property (retain, nonatomic) UILabel *detailField;
@property (retain, nonatomic) UITableView *detailTable;
@property (retain, nonatomic) UIButton *statusView;
@property (assign, nonatomic) CGFloat detailCellHeight;

@property(nonatomic, retain) NSOperationQueue *downloadQueue;

@end

@implementation FEMyEventDetailController

@synthesize event;
@synthesize scrollView;
@synthesize startDateLabel;
@synthesize endDateLabel;
@synthesize startTimeLabel;
@synthesize endTimeLabel;
@synthesize venueLabel;
@synthesize detailField;
@synthesize bannerImage;
@synthesize eventNameLabel;
@synthesize downloadQueue;
@synthesize detailTable;
@synthesize statusView;
@synthesize detailCellHeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.downloadQueue = [[[NSOperationQueue alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc
{
    [event release];
    [eventNameLabel release];
    [startDateLabel release];
    [endDateLabel release];
    [startTimeLabel release];
    [endTimeLabel release];
    [venueLabel release];
    [detailField release];
    [bannerImage release];
    [downloadQueue release];
    [detailTable release];
    [statusView release];
    [scrollView release];
    [super dealloc];
}

- (void)loadView
{
    UIView *mainView = [[[UIView alloc] init] autorelease];
    mainView.frame = CGRectMake(0, 20+44, 320, 480-20-44);
    mainView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    self.view = mainView;
    
    self.scrollView = [[[UIScrollView alloc] init] autorelease];
    self.scrollView.frame = CGRectMake(0, 0, 320, 480-20-44);
    self.scrollView.backgroundColor = [UIColor clearColor];
    [mainView addSubview:self.scrollView];
    
    UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_topShadow"]] autorelease];
    bgView.frame = CGRectMake(0, 0, 320, 166);
    [scrollView addSubview:bgView];
    
    UIImageView *rightView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_topBackground"]] autorelease];
    rightView.frame = CGRectMake(159, -1, 162, 162);
    [self.scrollView addSubview:rightView];
    
    self.bannerImage = [[[UIAsyncImageView alloc] init] autorelease];
    self.bannerImage.frame = CGRectMake(0, 0, 160, 160);
    [self.scrollView addSubview:self.bannerImage];
    
    self.statusView = [[[UIButton alloc] init] autorelease];
    self.statusView.frame = CGRectMake(168, 8, 100, 25);
    [self.statusView setBackgroundImage:[[UIImage imageNamed:@"status_wait"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateNormal];
    [self.statusView setBackgroundImage:[[UIImage imageNamed:@"status_in"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateHighlighted];
    [self.statusView setBackgroundImage:[[UIImage imageNamed:@"status_over"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateDisabled];
    [self.statusView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.statusView setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.statusView setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.statusView.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self.statusView setTitle:@"尚未开始" forState:UIControlStateNormal];
    [self.statusView setTitle:@"正在进行" forState:UIControlStateHighlighted];
    [self.statusView setTitle:@"已经结束" forState:UIControlStateDisabled];
    self.statusView.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.statusView];
    
    self.startDateLabel = [[[UILabel alloc] init] autorelease];
    self.startDateLabel.frame = CGRectMake(160, 44, 150, 21);
    self.startDateLabel.backgroundColor = [UIColor clearColor];
    self.startDateLabel.font = [UIFont systemFontOfSize:16.0];
    self.startDateLabel.textColor = [UIColor lightGrayColor];
    //self.startDateLabel.text = @"2012年8月31日";
    self.startDateLabel.textAlignment = UITextAlignmentRight;
    [self.scrollView addSubview:self.startDateLabel];
    
    self.startTimeLabel = [[[UILabel alloc] init] autorelease];
    self.startTimeLabel.frame = CGRectMake(160, 69, 150, 21);
    self.startTimeLabel.backgroundColor = [UIColor clearColor];
    self.startTimeLabel.font = [UIFont systemFontOfSize:24.0];
    self.startTimeLabel.textColor = [UIColor darkGrayColor];
    //self.startTimeLabel.text = @"09:45";
    self.startTimeLabel.textAlignment = UITextAlignmentRight;
    [self.scrollView addSubview:self.startTimeLabel];
    
    self.endDateLabel = [[[UILabel alloc] init] autorelease];
    self.endDateLabel.frame = CGRectMake(160, 104, 150, 21);
    self.endDateLabel.backgroundColor = [UIColor clearColor];
    self.endDateLabel.font = [UIFont systemFontOfSize:16.0];
    self.endDateLabel.textColor = [UIColor lightGrayColor];
    //self.endDateLabel.text = @"2012年12月15日";
    self.endDateLabel.textAlignment = UITextAlignmentRight;
    [scrollView addSubview:self.endDateLabel];
    
    self.endTimeLabel = [[[UILabel alloc] init] autorelease];
    self.endTimeLabel.frame = CGRectMake(160, 129, 150, 21);
    self.endTimeLabel.backgroundColor = [UIColor clearColor];
    self.endTimeLabel.font = [UIFont systemFontOfSize:24.0];
    self.endTimeLabel.textColor = [UIColor darkGrayColor];
    //self.endTimeLabel.text = @"17:30";
    self.endTimeLabel.textAlignment = UITextAlignmentRight;
    [self.scrollView addSubview:self.endTimeLabel];
    
    self.detailTable = [[[UITableView alloc] init] autorelease];
    self.detailTable.frame = CGRectMake(10, 175, 300, 300);
    self.detailTable.layer.cornerRadius = 6.0;
    self.detailTable.delegate = self;
    self.detailTable.dataSource = self;
    self.detailTable.scrollEnabled = NO;
    self.detailTable.backgroundColor = [UIColor clearColor];
    self.detailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:self.detailTable];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //back button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 31);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [backButton setBackgroundImage:[[UIImage imageNamed:@"navBackButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 10)] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    //edit button
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(0, 0, 50, 31);
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [editButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, 15, 10)] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editButton] autorelease];
    
    self.title = self.event.name;
    if(self.event.logoURL){
        [self.bannerImage loadImageAsync:self.event.logoURL withQueue:self.downloadQueue];
    }else {
        self.bannerImage.image = [UIImage imageNamed:@"pictureGridPlaceholder"];
    }
    
    self.startDateLabel.text = [NSString stringWithFormat:@"%@", [self.event.start_date stringWithFormat:@"YYYY年MM月dd日"]];
    self.startTimeLabel.text = [NSString stringWithFormat:@"%@", [self.event.start_date stringWithFormat:@"HH:mm"]];
    if(self.event.end_date){
        self.endDateLabel.text = [NSString stringWithFormat:@"%@", [self.event.end_date stringWithFormat:@"YYYY年MM月dd日"]];
        self.endTimeLabel.text = [NSString stringWithFormat:@"%@", [self.event.end_date stringWithFormat:@"HH:mm"]];
    }else {
        self.endDateLabel.text = @"";
        self.endTimeLabel.text = @"------";
    }
    
    self.detailCellHeight = [self getDetailTextHeight] + 20;
    self.detailTable.frame = CGRectMake(10, 175, 300, 42*3+self.detailCellHeight);
    
    self.scrollView.contentSize = CGSizeMake(320, self.detailTable.frame.origin.y+self.detailTable.frame.size.height+10);
}

- (void)viewDidUnload
{
    [self setEvent:nil];
    [self setEventNameLabel:nil];
    [self setStartDateLabel:nil];
    [self setEndDateLabel:nil];
    [self setVenueLabel:nil];
    [self setDetailField:nil];
    [self setBannerImage:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != 3) return 42.0;
    return self.detailCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyEventDetailViewCellIdentifier";
    FEDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[[FEDetailViewCell alloc] init] autorelease];
        cell.backgroundView = [[[UIImageView alloc] init] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
    NSString *bgImageName = indexPath.row == 0 ? @"detail_firstCellBg" : indexPath.row == [self tableView:tableView numberOfRowsInSection:0] - 1 ? @"detail_lastCellBg" : @"detail_cellBg";
    ((UIImageView *)cell.backgroundView).image = [[UIImage imageNamed:bgImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 12, 20)];
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"detail_icon_location"];
            cell.textLabel.text = self.event.venue;
            break;
            
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"detail_icon_tag"];
            CGFloat left = 36.0, top = 9.0;
            for (int i = 0; i < self.event.tags.count; i++) {
                FETag *tag = [self.event.tags objectAtIndex:i];
                UIButton *tagView = [self createTagButton:tag.name];
                tagView.frame = CGRectMake(left, top, tagView.frame.size.width, 24);
                [cell.contentView addSubview:tagView];
                left += tagView.frame.size.width + 5;
            }
            break;
            
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"detail_icon_people"];
            left = 36.0;
            top = 9.0;
            for (int i = 0; i < self.event.attendees.count; i++) {
                FEUser *user = [self.event.attendees objectAtIndex:i];
                UILabel *userView = [[[UILabel alloc] init] autorelease];
                userView.backgroundColor = [UIColor clearColor];
                userView.textColor = [UIColor darkGrayColor];
                userView.text = user.username;
                [userView sizeToFit];
                userView.frame = CGRectMake(left, top, userView.frame.size.width, 24);
                [cell.contentView addSubview:userView];
                left += userView.frame.size.width + 5;
            }
            break;
            
        case 3:
            cell.imageAlign = UIViewContentModeTop;
            cell.imageView.image = [UIImage imageNamed:@"detail_icon_desc"];
            cell.textLabel.text = self.event.detail;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)getDetailTextHeight
{
    if(!self.event.detail || [self.event.detail isEqualToString:@""]) return 22.0;
    CGSize contentSize = [self.event.detail sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(320-60, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    return contentSize.height;
}

- (UIButton *)createTagButton:(NSString *)tagValue
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:tagValue forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    button.titleLabel.text = tagValue;
    button.userInteractionEnabled = NO;
    [button sizeToFit];
    return button;
}

@end
