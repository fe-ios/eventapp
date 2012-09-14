//
//  FEAttendEventListController.m
//  EventApp
//
//  Created by zhenglin li on 12-9-14.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEAttendEventListController.h"
#import "AppDelegate.h"
#import "FEEventTableViewCell.h"
#import "FEEvent.h"
#import "NSDate+Helper.h"
#import "FEServerAPI.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "TKAlertCenter.h"
#import "FEAttendEventDetailController.h"

@interface FEAttendEventListController ()

@property(nonatomic, retain) ASIFormDataRequest *dataRequest;
@property(nonatomic, retain) NSOperationQueue *downloadQueue;

@end

@implementation FEAttendEventListController

@synthesize eventData;
@synthesize dataRequest, downloadQueue;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.eventData = [NSMutableArray arrayWithObjects:nil];
        self.downloadQueue = [[[NSOperationQueue alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc
{
    [eventData release];
    [dataRequest clearDelegatesAndCancel];
    [dataRequest release];
    [downloadQueue cancelAllOperations];
    [downloadQueue release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"参与活动", @"参与活动");
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotGreyBackground"]] autorelease];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *leftBarButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuButton"] style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)] autorelease];
	self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(0, 0, 50, 31);
    [refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    refreshButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [refreshButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, 15, 10)] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:refreshButton] autorelease];
    
    [self.dataRequest clearDelegatesAndCancel];
    [self loadEvent];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)refreshAction
{
    [self.dataRequest clearDelegatesAndCancel];
    [self loadEvent];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AttendEventTableViewCell";
    FEEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FEEventTableViewCell" owner:nil options:nil];
        cell = (FEEventTableViewCell *)[nibs objectAtIndex:0];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"eventTabelCellBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 120, 50, 120)]] autorelease];
        UIImage *placeholder = [UIImage imageNamed:@"pictureGridPlaceholder"];
        cell.eventIcon.image = placeholder;
        cell.eventIcon.cornerRadius = 6.0;
    }
    
    FEEvent *event = [self.eventData objectAtIndex:indexPath.row];
    cell.eventNameLabel.text = event.name;
    if(event.logoURL.length == 0){
        cell.eventIcon.image = [UIImage imageNamed:@"pictureGridPlaceholder"];
    }else if (![event.logoURL isEqualToString:cell.eventIcon.imagePath]) {
        cell.eventIcon.image = [UIImage imageNamed:@"pictureGridPlaceholder"];
        [cell.eventIcon loadImageAsync:event.logoURL withQueue:self.downloadQueue];
    }else {
        NSLog(@"logo exist: %@", event.name);
    }
    
    NSString *dateLabel = nil;
    NSString *startDate = [event.start_date stringWithFormat:@"MM月dd日"];
    NSString *endDate = [event.end_date stringWithFormat:@"MM月dd日"];
    if([startDate isEqualToString:endDate]){
        dateLabel = [NSString stringWithFormat:@"%@ - %@", [event.start_date stringWithFormat:@"MM月dd日 HH:mm"], [event.end_date stringWithFormat:@"HH:mm"]];
    }else if(endDate){
        dateLabel = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
    }else {
        dateLabel = [NSString stringWithFormat:@"%@", startDate];
    }
    cell.eventDateLabel.text = dateLabel;
    
    NSString *tagLabel = [event.tags componentsJoinedByString:@", "];
    cell.eventTagLabel.text = tagLabel;
    
    cell.watchButton.tag = indexPath.row;
    cell.watchButton.selected = indexPath.row%2 == 0;
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.downloadQueue.maxConcurrentOperationCount = 2;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.downloadQueue.maxConcurrentOperationCount = 5;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate){
        self.downloadQueue.maxConcurrentOperationCount = 5;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEEvent *event = [self.eventData objectAtIndex:indexPath.row];
	FEAttendEventDetailController *detailView = [[[FEAttendEventDetailController alloc] init] autorelease];
    detailView.event = event;
	[self.navigationController pushViewController:detailView animated:YES];
}

- (void)loadEvent
{
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] intValue];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    NSString *loadURL = [NSString stringWithFormat:@"%@%@", API_BASE, API_EVENT_ATTEND];
    
    self.dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:loadURL]];
    self.dataRequest.requestMethod = @"POST";
    [self.dataRequest setPostValue:[NSNumber numberWithInt:user_id] forKey:@"user_id"];
    [self.dataRequest setPostValue:password forKey:@"password"];
    self.dataRequest.delegate = self;
    [self.dataRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%d, %@", request.responseStatusCode, request.responseString);
    
    NSDictionary *result = [request.responseString objectFromJSONString];
    NSMutableArray *events = [FEEvent translateJSONEvents:[result objectForKey:@"event"]];
    self.eventData = events;
    [self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"加载数据失败，请检查网络！"];
}

@end
