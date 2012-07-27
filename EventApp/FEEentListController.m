//
//  FEEentListController.m
//  EventApp
//
//  Created by zhenglin li on 12-7-19.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEEentListController.h"
#import "FEEventTableViewCell.h"
#import "AppDelegate.h"
#import "UIAsyncImageView.h"
#import "FECreateEventController.h"
#import "FEServerAPI.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "FEEvent.h"
#import "MBProgressHUD.h"


@interface FEEentListController ()
{
    EGORefreshTableHeaderView* _updateHeaderView;
    EGORefreshTableFooterView* _updateFooterView;
    
    BOOL _updating;
    BOOL _loadingMore;
    NSDate* _lastUpdateDate;
}

@end

@implementation FEEentListController

@synthesize downloadQueue = _downloadQueue;
@synthesize eventData = _eventData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.eventData = [NSMutableArray arrayWithObjects:nil];
//        self.eventData = [[NSMutableArray alloc] initWithObjects:
//                          @"http://ww4.sinaimg.cn/mw205/89b2cba9jw1dtfy4uzsokj.jpg", 
//                          @"http://ww4.sinaimg.cn/mw205/a325727fjw1dtfy6ajt9cj.jpg", 
//                          @"http://ww1.sinaimg.cn/mw205/a325727fjw1dtfxvvy7svj.jpg",
//                          @"http://ww2.sinaimg.cn/mw205/89b2cba9jw1dtes823b8zj.jpg",
//                          @"http://ww2.sinaimg.cn/mw205/87ede685jw1dtfylqslh1j.jpg", 
//                          @"http://ww1.sinaimg.cn/mw205/7b94d863jw1dteshud99aj.jpg",
//                          @"http://ww3.sinaimg.cn/mw205/83c51a57jw1dtdpf0vlldj.jpg",
//                          @"http://ww1.sinaimg.cn/mw205/82e54aaejw1dtdom0x7u6j.jpg",
//                          @"http://ww4.sinaimg.cn/mw205/5c703123jw1dtdnh3hob5j.jpg",
//                          @"http://ww3.sinaimg.cn/mw205/6830bbefgw1dtbr36tjqfj.jpg",
//                          nil];
    }
    return self;
}

- (void)dealloc
{
    [_downloadQueue release];
    [_eventData release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appBackground"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.downloadQueue = [[[NSOperationQueue alloc] init] autorelease];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WKNavigationSidebarButton"] style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)];
	self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuIconPlus"] style:UIBarButtonItemStylePlain target:self action:@selector(createEvent)];
	self.navigationItem.rightBarButtonItem = rightBarButton;
    
    if(_updateHeaderView == nil)
    {
        EGORefreshTableHeaderView *headerView = [[EGORefreshTableHeaderView alloc] init];
        headerView.frame = CGRectMake(10, -50, 320-20, 50);
		headerView.delegate = self;
		[self.tableView addSubview:headerView];
		_updateHeaderView = headerView;
		[headerView release];
	}
    
    if(_updateFooterView == nil)
    {
        EGORefreshTableFooterView *footerView = [[EGORefreshTableFooterView alloc] init];
		footerView.delegate = self;
		[self.tableView addSubview:footerView];
		_updateFooterView = footerView;
		[footerView release];
	}
	
    _lastUpdateDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdateDate"];
	[_updateHeaderView refreshLastUpdatedDate];
    
    [_updateHeaderView setState:EGOOPullRefreshLoading];
    [self.tableView setContentInset:UIEdgeInsetsMake(_updateHeaderView.frame.size.height, 0, 0, 0)];
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
    return 189;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventTableViewCell";
    FEEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EventTableViewCell" owner:nil options:nil];
        cell = (FEEventTableViewCell *)[nibs objectAtIndex:0];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eventCellBackground"]] autorelease];
        UIImage *placeholder = [UIImage imageNamed:@"pictureGridPlaceholder"];
        cell.eventImage1.image = placeholder;
        cell.eventImage2.image = placeholder;
        cell.eventImage3.image = placeholder;
        cell.eventImage4.image = placeholder;
        UIFont *font = [UIFont fontWithName:@"CuprumFFU" size:13.0f];
        cell.peopleCountLabel.font = font;
        cell.pictureCountLabel.font = font;
    }
    
    FEEvent *event = [self.eventData objectAtIndex:indexPath.row];
    
    cell.eventNameLabel.text = event.name;
    //[cell.eventImage1 loadImageAsync:url withQueue:self.downloadQueue];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //todo
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
    [_updateHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_updateFooterView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	[_updateHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_updateFooterView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)loadEvent
{
    _updating = YES;
    
//    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedDelegate].window animated:YES];
//    progress.mode = MBProgressHUDModeIndeterminate;
//    progress.dimBackground = YES;
    
    FEEvent *firstEvent = self.eventData.count > 0 ? (FEEvent *) [self.eventData objectAtIndex:0] : nil;
    NSString *loadURL = [NSString stringWithFormat:@"%@%@", API_BASE, API_EVENT_PUBLIC];
    if(_loadingMore || firstEvent == nil){
        loadURL = [loadURL stringByAppendingFormat:@"?start=%d&count=10", self.eventData.count];
    }else {
        loadURL = [loadURL stringByAppendingFormat:@"?start=%d", firstEvent.event_id];
    }
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loadURL]];
    request.delegate = self;
    request.cachePolicy = ASIDoNotWriteToCacheCachePolicy;
    request.didFinishSelector = @selector(loadEventFinished:);
    request.didFailSelector = @selector(loadEventFailed:);
    [request startSynchronous];
}

- (void)loadEventFinished:(ASIHTTPRequest *)request
{
    _updating = NO;
    [_lastUpdateDate release];
    _lastUpdateDate = [[NSDate date] retain];
    [[NSUserDefaults standardUserDefaults] setObject:_lastUpdateDate forKey:@"lastUpdateDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[MBProgressHUD hideHUDForView:[AppDelegate sharedDelegate].window animated:YES];
    
    NSDictionary *result = [request.responseString objectFromJSONString];
    NSMutableArray *events = [FEEvent translateJSONEvents:[result objectForKey:@"event"]];
    BOOL hasData = events.count > 0;
    if(_loadingMore){
        if(hasData){
            [self.eventData addObjectsFromArray:events];
        }
        _loadingMore = NO;
        [_updateFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView scrollFooterBack:!hasData];
    }else {
        if(hasData){
            [self.eventData insertObjects:events atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, events.count)]];
        }
        [_updateHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    [self.tableView reloadData];
    
    _updateFooterView.frame = CGRectMake(10, self.tableView.contentSize.height, 320-20, 40);
}

- (void)loadEventFailed:(ASIHTTPRequest *)request
{
    NSLog(@"loadEventFailed: %@", request.url);
    [_updateHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [_updateFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView scrollFooterBack:YES];
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
	return _updating;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return _lastUpdateDate;
}

#pragma mark - EGORefreshTableFooterDelegate Methods

- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    _loadingMore = YES;
    [self loadEvent];
}

- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _loadingMore;
}

@end
