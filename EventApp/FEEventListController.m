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
#import "MBProgressHUD.h"


@interface FEEventListController ()
{
    EGORefreshTableHeaderView* _updateHeaderView;
    EGORefreshTableFooterView* _updateFooterView;
    UIImageView* _footerView;
    
    BOOL _updating;
    BOOL _loadingMore;
    NSDate* _lastUpdateDate;
}

@end

@implementation FEEventListController

@synthesize downloadQueue = _downloadQueue;
@synthesize eventData = _eventData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.eventData = [NSMutableArray arrayWithObjects:nil];
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
    
    self.title = NSLocalizedString(@"所有活动", @"所有活动");
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotGreyBackground"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.downloadQueue = [[[NSOperationQueue alloc] init] autorelease];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuButton"] style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)];
	self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addButton"] style:UIBarButtonItemStylePlain target:self action:@selector(createEvent)];
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
        footerView.hidden = YES;
		[self.tableView addSubview:footerView];
		_updateFooterView = footerView;
		[footerView release];
	}
    
    if(_footerView == nil){
        _footerView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eventTableFooter"]] autorelease];
        _footerView.hidden = YES;
        [self.tableView addSubview:_footerView];
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
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventTableViewCell";
    FEEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EventTableViewCell" owner:nil options:nil];
        cell = (FEEventTableViewCell *)[nibs objectAtIndex:0];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"eventTabelCellBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 120, 50, 120)]] autorelease];
        UIImage *placeholder = [UIImage imageNamed:@"pictureGridPlaceholder"];
        cell.eventImage1.image = placeholder;
//        cell.eventImage2.image = placeholder;
//        cell.eventImage3.image = placeholder;
//        cell.eventImage4.image = placeholder;
        UIFont *font = [UIFont fontWithName:@"CuprumFFU" size:13.0f];
        cell.peopleCountLabel.font = font;
        cell.pictureCountLabel.font = font;
        
        UIButton *watchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        watchButton.frame = CGRectMake(self.tableView.contentSize.width-44, (80-44)*0.5, 44, 44);
        [watchButton setBackgroundImage:[UIImage imageNamed:@"big-heart-normal"] forState:UIControlStateNormal];
        [watchButton setBackgroundImage:[UIImage imageNamed:@"big-heart-selected"] forState:UIControlStateSelected];
        [cell.contentView addSubview:watchButton];
        [watchButton addTarget:self action:@selector(toggleWatchEvent:) forControlEvents:UIControlEventTouchUpInside];
        watchButton.adjustsImageWhenHighlighted = NO;
        cell.watchButton = watchButton;
        
        //[cell.eventImage1 setRoundBorder];
        //[[cell.subviews objectAtIndex:1] setHidden:YES];
    }
    
    FEEvent *event = [self.eventData objectAtIndex:indexPath.row];
    
    cell.eventNameLabel.text = event.name;
    if(event.logoURL.length == 0){
        cell.eventImage1.image = [UIImage imageNamed:@"pictureGridPlaceholder"];
    }else if (![event.logoURL isEqualToString:cell.eventImage1.imagePath]) {
        cell.eventImage1.image = [UIImage imageNamed:@"pictureGridPlaceholder"];
        [cell.eventImage1 loadImageAsync:event.logoURL withQueue:self.downloadQueue];
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
    [request startAsynchronous];
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
            [self tableView:self.tableView insertDataAndRefresh:events startIndex:self.eventData.count];
//            [self.eventData addObjectsFromArray:events];
//            [self.tableView beginUpdates];
//            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:10 inSection:0], [NSIndexPath indexPathForRow:11 inSection:0], [NSIndexPath indexPathForRow:12 inSection:0], [NSIndexPath indexPathForRow:13 inSection:0], [NSIndexPath indexPathForRow:14 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
//            [self.tableView endUpdates];
        }
        
        _loadingMore = NO;
        [_updateFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView scrollFooterBack:!hasData];
    }else {
        if(hasData){
            [self tableView:self.tableView insertDataAndRefresh:events startIndex:0];
//            [self.eventData insertObjects:events atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, events.count)]];
//            [self.tableView reloadData];
        }
        [_updateHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    float contentHeight = 80*self.eventData.count;
    _updateFooterView.hidden = contentHeight < 300;
    _updateFooterView.frame = CGRectMake(10, contentHeight, self.tableView.frame.size.width-20, 40);
    _footerView.hidden = self.eventData.count == 0;
    _footerView.frame = CGRectMake(0, contentHeight, self.tableView.frame.size.width, 4);
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
