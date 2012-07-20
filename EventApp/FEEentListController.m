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


@interface FEEentListController ()

@end

@implementation FEEentListController

@synthesize downloadQueue = _downloadQueue;
@synthesize eventData = _eventData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.eventData = [[NSMutableArray alloc] initWithObjects:
                          @"http://ww4.sinaimg.cn/mw205/89b2cba9jw1dtfy4uzsokj.jpg", 
                          @"http://ww4.sinaimg.cn/mw205/a325727fjw1dtfy6ajt9cj.jpg", 
                          @"http://ww1.sinaimg.cn/mw205/a325727fjw1dtfxvvy7svj.jpg",
                          @"http://ww2.sinaimg.cn/mw205/89b2cba9jw1dtes823b8zj.jpg",
                          @"http://ww2.sinaimg.cn/mw205/87ede685jw1dtfylqslh1j.jpg", 
                          @"http://ww1.sinaimg.cn/mw205/7b94d863jw1dteshud99aj.jpg",
                          @"http://ww3.sinaimg.cn/mw205/83c51a57jw1dtdpf0vlldj.jpg",
                          @"http://ww1.sinaimg.cn/mw205/82e54aaejw1dtdom0x7u6j.jpg",
                          @"http://ww4.sinaimg.cn/mw205/5c703123jw1dtdnh3hob5j.jpg",
                          @"http://ww3.sinaimg.cn/mw205/6830bbefgw1dtbr36tjqfj.jpg",
                          nil];
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
    return 10;
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
    
    NSString *url = [self.eventData objectAtIndex:indexPath.row];
    cell.eventNameLabel.text = @"事件标题";
    [cell.eventImage1 loadImageAsync:url withQueue:self.downloadQueue];
    
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
}

@end
