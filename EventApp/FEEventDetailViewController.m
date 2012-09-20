//
//  FEEventDetailViewController.m
//  EventApp
//
//  Created by Yin Zhengbo on 8/13/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FEEventDetailViewController.h"
#import "NSDate+Helper.h"
#import "UIAsyncImageView.h"
#import "FEDetailViewCell.h"
#import "FETag.h"
#import "FEUser.h"
#import "ASIFormDataRequest.h"
#import "FEServerAPI.h"
#import "JSONKit.h"

#define MAX_HEIGHT 2000

@interface FEEventDetailViewController ()

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
@property (retain, nonatomic) UIButton *joinButton;

@property(nonatomic, retain) NSOperationQueue *downloadQueue;

@end

@implementation FEEventDetailViewController

@synthesize scrollView;
@synthesize startDateLabel;
@synthesize endDateLabel;
@synthesize startTimeLabel;
@synthesize endTimeLabel;
@synthesize venueLabel;
@synthesize detailField;
@synthesize bannerImage;
@synthesize eventNameLabel;
@synthesize event;
@synthesize downloadQueue;
@synthesize detailTable;
@synthesize statusView;
@synthesize detailCellHeight;
@synthesize joinButton;


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
    [joinButton release];
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
    self.startDateLabel.text = @"2012年8月31日";
    self.startDateLabel.textAlignment = UITextAlignmentRight;
    [self.scrollView addSubview:self.startDateLabel];
    
    self.startTimeLabel = [[[UILabel alloc] init] autorelease];
    self.startTimeLabel.frame = CGRectMake(160, 69, 150, 21);
    self.startTimeLabel.backgroundColor = [UIColor clearColor];
    self.startTimeLabel.font = [UIFont systemFontOfSize:24.0];
    self.startTimeLabel.textColor = [UIColor darkGrayColor];
    self.startTimeLabel.text = @"09:45";
    self.startTimeLabel.textAlignment = UITextAlignmentRight;
    [self.scrollView addSubview:self.startTimeLabel];
    
    self.endDateLabel = [[[UILabel alloc] init] autorelease];
    self.endDateLabel.frame = CGRectMake(160, 104, 150, 21);
    self.endDateLabel.backgroundColor = [UIColor clearColor];
    self.endDateLabel.font = [UIFont systemFontOfSize:16.0];
    self.endDateLabel.textColor = [UIColor lightGrayColor];
    self.endDateLabel.text = @"2012年12月15日";
    self.endDateLabel.textAlignment = UITextAlignmentRight;
    [scrollView addSubview:self.endDateLabel];
    
    self.endTimeLabel = [[[UILabel alloc] init] autorelease];
    self.endTimeLabel.frame = CGRectMake(160, 129, 150, 21);
    self.endTimeLabel.backgroundColor = [UIColor clearColor];
    self.endTimeLabel.font = [UIFont systemFontOfSize:24.0];
    self.endTimeLabel.textColor = [UIColor darkGrayColor];
    self.endTimeLabel.text = @"17:30";
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
    
    //self.title = @"活动详情";
    
    //back button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 31);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [backButton setBackgroundImage:[[UIImage imageNamed:@"btn_title_bar_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 13, 15, 8)] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[[UIImage imageNamed:@"btn_title_bar_back_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 13, 15, 8)] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    //join button
    self.joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.joinButton.frame = CGRectMake(0, 0, 50, 31);
    [self.joinButton setTitle:@"报名" forState:UIControlStateNormal];
    self.joinButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [self.joinButton setBackgroundImage:[[UIImage imageNamed:@"btn_title_bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 6, 15, 6)] forState:UIControlStateNormal];
    [self.joinButton addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.joinButton] autorelease];
    
    self.title = self.event.name;
    if(self.event.logoURL && ![self.event.logoURL isEqualToString:@""]){
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
    
    EventState status = [self checkEventStatus];
    if(status == EventNotStarted){
        BOOL requested = NO;
        int self_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] intValue];
        for (int i = 0; i < self.event.requests.count; i++) {
            FEUser *user = [self.event.requests objectAtIndex:i];
            if(user.user_id == self_id){
                requested = YES;
                break;
            }
        }
        if(requested){
            [self setJoinButtonState:EventJoined];
        }
    }else {
        [self setJoinButtonState:EventCanNotJoin];
    }
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
    static NSString *cellIdentifier = @"DetailViewCellIdentifier";
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
				[tagView setBackgroundImage:[[UIImage imageNamed:@"detail_tag_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateNormal];
                tagView.frame = CGRectMake(left, top, tagView.frame.size.width, 24);
                [cell.contentView addSubview:tagView];
                left += tagView.frame.size.width + 5;
            }
            break;
            
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"detail_icon_people"];
			cell.detailTextLabel.text = @"更多";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

- (int)checkEventStatus
{
    //未开始：0，进行中：1，已结束：-1
    NSDate *now = [NSDate date];
    NSComparisonResult result1 = [self.event.start_date compare:now];
    if(!self.event.end_date){
        if(result1 == NSOrderedAscending){
            [self.statusView setHighlighted:YES];
            return EventStarted;
        }
    }else {
        NSComparisonResult result2 = [self.event.end_date compare:now];
        if(result1 == NSOrderedAscending && result2 == NSOrderedDescending){
            [self.statusView setHighlighted:YES];
            return EventStarted;
        }else if (result2 == NSOrderedAscending) {
            [self.statusView setEnabled:NO];
            return EventFinished;
        }
    }
    return EventNotStarted;
}

- (void)joinAction
{
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] intValue];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSString *eventURL = [NSString stringWithFormat:@"%@%@", API_BASE, API_REQUEST_EVENT];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:eventURL]];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[NSNumber numberWithInt:user_id] forKey:@"user_id"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:[NSNumber numberWithInt:self.event.event_id] forKey:@"event_id"];
    
    request.delegate = self;
    [request startAsynchronous];
    [request release];
    self.joinButton.userInteractionEnabled = NO;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%d, %@", request.responseStatusCode, request.responseString);
    
    self.joinButton.userInteractionEnabled = YES;
    NSDictionary *result = [request.responseString objectFromJSONString];
    NSString *status = [result objectForKey:@"status"];
    
    if([status isEqualToString:@"success"]){
        [self setJoinButtonState:EventJoined];
    }
}

- (void)setJoinButtonState:(EventState)state
{
    if(state == EventCanJoin){
        self.joinButton.frame = CGRectMake(0, 0, 50, 31);
        self.joinButton.userInteractionEnabled = YES;
        [self.joinButton setTitle:@"报名" forState:UIControlStateNormal];
    }else if (state == EventCanNotJoin) {
        self.joinButton.hidden = YES;
    }else if (state == EventJoined) {
        self.joinButton.frame = CGRectMake(0, 0, 62, 31);
        self.joinButton.enabled = NO;
        [self.joinButton setTitle:@"已报名" forState:UIControlStateDisabled];
    }
}

@end
