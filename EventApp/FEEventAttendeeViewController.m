//
//  FEEventAttendeeViewController.m
//  EventApp
//
//  Created by Yin Zhengbo on 9/17/12.
//  Copyright (c) 2012 snda. All rights reserved.
//
#import "FEEventAttendeeViewController.h"
#import "FEProfileViewController.h"
#import "FEUser.h"
#import "FEAttendeeCell.h"
#import "ASIFormDataRequest.h"
#import "FEServerAPI.h"
#import "JSONKit.h"

@interface FEEventAttendeeViewController ()

@property(nonatomic, retain) NSMutableArray *attendUsers;
@property(nonatomic, retain) NSOperationQueue *downloadQueue;
@property(nonatomic, assign) int actionType;
@property(nonatomic, assign) int actionIndex;

@end

@implementation FEEventAttendeeViewController

@synthesize event = _event, delegate;
@synthesize attendUsers, downloadQueue, actionType, actionIndex;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.attendUsers = [NSMutableArray array];
        self.downloadQueue = [[[NSOperationQueue alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc
{
    [_event release];
    [attendUsers release];
    [downloadQueue release];
    [delegate release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"参加人员";
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	self.view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setEvent:(FEEvent *)aEvent
{
    if(_event != aEvent){
        [_event release];
        _event = [aEvent retain];
        [self updateAttendeeList];
    }
}

- (void)updateAttendeeList
{
    [self.attendUsers removeAllObjects];
    
    for (int i = 0; i < _event.requests.count; i++) {
        NSDictionary *request = [_event.requests objectAtIndex:i];
        [self.attendUsers addObject:request];
    }
    
    for (int i = 0; i < _event.attendees.count; i++) {
        FEUser *user = [_event.attendees objectAtIndex:i];
        NSMutableDictionary *obj = [NSMutableDictionary dictionary];
        [obj setObject:user forKey:@"user"];
        [self.attendUsers addObject:obj];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attendUsers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FEAttendeeCellIdentifier";
    FEAttendeeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
		cell = [[FEAttendeeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.avatarView.cornerRadius = 6.0;
	}
    
    NSDictionary *obj = [self.attendUsers objectAtIndex:indexPath.row];
    FEUser *user = [obj objectForKey:@"user"];
    int request_id = [[obj objectForKey:@"request_id"] intValue];
    
    cell.controller = self;
    cell.index = indexPath.row;
    cell.type = !request_id ? AttendeeCellTypeApproved : AttendeeCellTypeNeedToApprove;
    cell.nameLabel.text = user.username;
    if(user.avatarURL && ![user.avatarURL isEqualToString:@""]){
        [cell.avatarView loadImageAsync:user.avatarURL withQueue:self.downloadQueue];
    }else {
        cell.avatarView.image = [UIImage imageNamed:@"avatar_tmp"];
    }
    
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
		FEProfileViewController *profileView = [[FEProfileViewController alloc] init];
		[self.navigationController pushViewController:profileView animated:YES];
}

- (void)confirm:(NSNumber *)index
{
    self.actionType = 1;
    self.actionIndex = [index intValue];
    [self sendApproveRequest:self.actionType];
}

- (void)reject:(NSNumber *)index
{
    self.actionType = 0;
    self.actionIndex = [index intValue];
    [self sendApproveRequest:self.actionType];
}

- (void)sendApproveRequest:(int)action
{
    NSDictionary *obj = [self.attendUsers objectAtIndex:self.actionIndex];
    int request_id = [[obj objectForKey:@"request_id"] intValue];
    if(!request_id) return;
    
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] intValue];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSString *eventURL = [NSString stringWithFormat:@"%@%@", API_BASE, API_APPROVE_REQUEST];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:eventURL]];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[NSNumber numberWithInt:user_id] forKey:@"owner_id"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:[NSNumber numberWithInt:request_id] forKey:@"request_id"];
    [request setPostValue:[NSNumber numberWithInt:action] forKey:@"action"];
    
    request.delegate = self;
    [request startAsynchronous];
    [request release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%d, %@", request.responseStatusCode, request.responseString);
    
    NSDictionary *result = [request.responseString objectFromJSONString];
    NSString *status = [result objectForKey:@"status"];
    if([status isEqualToString:@"success"]){
        [self.event translateFromJSONObject:[result objectForKey:@"event"]];
        [self updateAttendeeList];
        [self.tableView reloadData];
        if([self.delegate respondsToSelector:@selector(updateView)]){
            [self.delegate performSelector:@selector(updateView)];
        }
    }
}

@end
