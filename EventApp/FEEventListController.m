//
//  FEEventListController.m
//  EventApp
//
//  Created by zhenglin li on 12-7-19.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEEventListController.h"
#import "FEEventTableViewCell.h"
#import "AppDelegate.h"
#import "UIAsyncImageView.h"
#import "FECreateEventController.h"
#import "FEServerAPI.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "FEEvent.h"
#import "TKAlertCenter.h"
#import "FEEventDetailViewController.h"

#define CACHE_NAME @"cacheEvent.data"
#define LAST_UPDATE @"lastUpdateDate"

@interface FEEventListController ()

@property(nonatomic, retain) EGORefreshTableHeaderView *updateHeaderView;
@property(nonatomic, retain) EGORefreshTableFooterView *updateFooterView;
@property(nonatomic, retain) UIImageView *footerView;
@property(nonatomic, retain) NSDate *lastUpdateDate;
@property(nonatomic, assign) BOOL updating;
@property(nonatomic, assign) BOOL loadingMore;

@end

@implementation FEEventListController

@synthesize updateHeaderView, updateFooterView, footerView;
@synthesize lastUpdateDate, updating, loadingMore;
@synthesize downloadQueue = _downloadQueue;
@synthesize eventData = _eventData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.eventData = [self getEventCache];
        if(self.eventData == nil) self.eventData = [NSMutableArray arrayWithObjects:nil];
    }
    return self;
}

- (void)dealloc
{
    [updateHeaderView release];
    [updateFooterView release];
    [footerView release];
    [lastUpdateDate release];
    [_eventData release];
    [_downloadQueue release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"所有活动", @"所有活动");
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotGreyBackground"]] autorelease];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.downloadQueue = [[[NSOperationQueue alloc] init] autorelease];
    
    UIBarButtonItem *leftBarButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuButton"] style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)] autorelease];
	self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addButton"] style:UIBarButtonItemStylePlain target:self action:@selector(createEvent)] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.updateHeaderView = [[[EGORefreshTableHeaderView alloc] init] autorelease];
    self.updateHeaderView.frame = CGRectMake(10, -50, 320-20, 50);
    self.updateHeaderView.delegate = self;
    [self.tableView addSubview:self.updateHeaderView];
    
    self.updateFooterView = [[[EGORefreshTableFooterView alloc] init] autorelease];
    self.updateFooterView.delegate = self;
    self.updateFooterView.hidden = YES;
    [self.tableView addSubview:self.updateFooterView];
    
    self.footerView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eventTableFooter"]] autorelease];
    self.footerView.hidden = YES;
    [self.tableView addSubview:self.footerView];
	
    self.lastUpdateDate = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_UPDATE];
	[self.updateHeaderView refreshLastUpdatedDate];
    
    [self.updateHeaderView setState:EGOOPullRefreshLoading];
    [self.tableView setContentInset:UIEdgeInsetsMake(self.updateHeaderView.frame.size.height, 0, 0, 0)];
    [self loadEvent];
}

- (void)viewDidUnload
{
    self.updateHeaderView = nil;
    self.updateFooterView = nil;
    self.footerView = nil;
    self.lastUpdateDate = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    static NSString *CellIdentifier = @"EventTableViewCell";
    FEEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FEEventTableViewCell" owner:nil options:nil];
        cell = (FEEventTableViewCell *)[nibs objectAtIndex:0];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"eventTabelCellBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 120, 50, 120)]] autorelease];
        UIImage *placeholder = [UIImage imageNamed:@"pictureGridPlaceholder"];
        cell.eventIcon.image = placeholder;
        //UIFont *font = [UIFont fontWithName:@"CuprumFFU" size:13.0f];
        //cell.peopleCountLabel.font = font;
        //cell.pictureCountLabel.font = font;
        
        UIButton *watchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        watchButton.frame = CGRectMake(self.tableView.contentSize.width-44, (80-44)*0.5, 44, 44);
        [watchButton setBackgroundImage:[UIImage imageNamed:@"big-heart-normal"] forState:UIControlStateNormal];
        [watchButton setBackgroundImage:[UIImage imageNamed:@"big-heart-selected"] forState:UIControlStateSelected];
        [cell.contentView addSubview:watchButton];
        [watchButton addTarget:self action:@selector(toggleWatchEvent:) forControlEvents:UIControlEventTouchUpInside];
        watchButton.adjustsImageWhenHighlighted = NO;
        cell.watchButton = watchButton;
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
    
    cell.watchButton.tag = indexPath.row;
    cell.watchButton.selected = indexPath.row%2 == 0;
    
    return cell;
}

- (void)toggleWatchEvent:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //todo
	//example
	FEEventDetailViewController *detailView = [[[FEEventDetailViewController alloc] init] autorelease];
	[self.navigationController pushViewController:detailView animated:YES];
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
    [self.updateHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [self.updateFooterView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	[self.updateHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [self.updateFooterView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)loadEvent
{
    self.updating = YES;
    
    FEEvent *firstEvent = self.eventData.count > 0 ? (FEEvent *) [self.eventData objectAtIndex:0] : nil;
    NSString *loadURL = [NSString stringWithFormat:@"%@%@", API_BASE, API_EVENT_PUBLIC];
    if(self.loadingMore || firstEvent == nil){
        loadURL = [loadURL stringByAppendingFormat:@"?start=%d&count=10", self.eventData.count];
    }else {
        loadURL = [loadURL stringByAppendingFormat:@"?start=%d", firstEvent.event_id];
    }
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loadURL]];
    request.delegate = self;
    request.cachePolicy = ASIDoNotWriteToCacheCachePolicy;
    request.didFinishSelector = @selector(loadEventFinished:);
    request.didFailSelector = @selector(loadEventFailed:);
    [request startAsynchronous];
}

- (void)loadEventFinished:(ASIHTTPRequest *)request
{
    self.updating = NO;
    self.lastUpdateDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:self.lastUpdateDate forKey:LAST_UPDATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //append data
    NSDictionary *result = [request.responseString objectFromJSONString];
    NSMutableArray *events = [FEEvent translateJSONEvents:[result objectForKey:@"event"]];
    BOOL hasData = events.count > 0;
    if(self.loadingMore){
        if(hasData){
            [self tableView:self.tableView insertDataAndRefresh:events startIndex:self.eventData.count];
        }
        self.loadingMore = NO;
        [self.updateFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView scrollFooterBack:!hasData];
    }else {
        if(hasData){
            [self tableView:self.tableView insertDataAndRefresh:events startIndex:0];
        }
        [self.updateHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    [self cacheEventData];
    [self fixFooterViews];
}

- (void)tableView:(UITableView *)tableView insertDataAndRefresh:(NSArray *)newData startIndex:(int)startIndex
{
    [self.eventData insertObjects:newData atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, newData.count)]];
    
    [UIView setAnimationsEnabled:NO];
    [tableView beginUpdates];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for(int i = 0; i < newData.count; i++){
        [indexPaths addObject:[NSIndexPath indexPathForRow:startIndex+i inSection:0]];
    }
    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [indexPaths release];
    
    [tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
}

- (void)fixFooterViews
{
    float contentHeight = 80*self.eventData.count;
    self.updateFooterView.hidden = contentHeight < 300;
    self.updateFooterView.frame = CGRectMake(10, contentHeight, self.tableView.frame.size.width-20, 40);
    self.footerView.hidden = self.eventData.count == 0;
    self.footerView.frame = CGRectMake(0, contentHeight, self.tableView.frame.size.width, 4);
}

- (void)loadEventFailed:(ASIHTTPRequest *)request
{
    NSLog(@"loadEventFailed: %@", request.url);
    self.updating = NO;
    self.loadingMore = NO;
    
    [self.updateHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.updateFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView scrollFooterBack:YES];
    
    [self fixFooterViews];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"加载数据失败，请检查网络！"];
}

- (void)createEvent
{
    FECreateEventController *createEventController = [[FECreateEventController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createEventController];
    [self.navigationController presentModalViewController:navController animated:YES];
    [createEventController release];
    [navController release];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self loadEvent];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return self.updating;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return self.lastUpdateDate;
}

#pragma mark - EGORefreshTableFooterDelegate Methods

- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    self.loadingMore = YES;
    [self loadEvent];
}

- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return self.loadingMore;
}

#pragma mark - cache

- (void)cacheEventData
{
    NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:self.eventData];
    NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [cacheData writeToFile:[docDirectory stringByAppendingPathComponent:CACHE_NAME] atomically:YES];
}

- (NSMutableArray *)getEventCache
{
    NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [docDirectory stringByAppendingPathComponent:CACHE_NAME];
    if([[NSFileManager defaultManager] fileExistsAtPath:cachePath]){
        return [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    }
    return nil;
}


@end
