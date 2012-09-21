//
//  BOMenuViewController.m
//  EventApp
//
//  Created by Yin Zhengbo on 7/19/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import "BOMenuViewController.h"
#import "BOMenuTableViewCell.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "FEEventListController.h"
#import "FEMyEventListController.h"
#import "FEAttendEventListController.h"
#import "FECreateEventController.h"
#import "FESettingsViewController.h"

@interface BOMenuViewController ()

@end

@implementation BOMenuViewController
@synthesize menuTableView;
@synthesize userName;
@synthesize userAvatar;
@synthesize btnLogin;
@synthesize btnAddEvent;
@synthesize btnSignup;
@synthesize selectedMenu;
@synthesize btnLogout;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedMenu = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern-1"]]];
	self.menuTableView.delegate = self;
	self.menuTableView.dataSource = self;
	[self.menuTableView setBackgroundColor:[UIColor clearColor]];
	
	//TableHeaderView cell
	UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIImageView *headerViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	[headerViewBg setImage:[UIImage imageNamed:@"menu_user_bg"]];
	[tableHeaderView addSubview:headerViewBg];
	UIImageView *headerViewSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(150, 3, 1, 36)];
	[headerViewSeparator setImage:[UIImage imageNamed:@"menu_user_bg_line"]];
	[tableHeaderView addSubview:headerViewSeparator];
	
	//User
    userAvatar = [[[UIAsyncImageView alloc] init] autorelease];
	userAvatar.frame = CGRectMake(10, 6, 32, 32);
    userAvatar.cornerRadius = 3.0;
    [self updateUserAvatar];
	[tableHeaderView addSubview:userAvatar];
	
	userName = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, 90, 18)];
	[userName setText:@"aUserName"];
	[userName setFont:[UIFont systemFontOfSize:14.0f]];
	[userName setTextColor:[UIColor whiteColor]];
	[userName setBackgroundColor:[UIColor clearColor]];
	[tableHeaderView addSubview:userName];
    userName.text = (NSString *) [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];

	btnAddEvent = [[UIButton alloc] initWithFrame:CGRectMake(160, 6, 74, 32)];
	[btnAddEvent setBackgroundImage:[UIImage imageNamed:@"menu_user_addEvent"] forState:UIControlStateNormal];
	[btnAddEvent setBackgroundImage:[UIImage imageNamed:@"menu_user_addEvent_pressed"] forState:UIControlStateHighlighted];
	[btnAddEvent setTitle:@"新活动" forState:UIControlStateNormal];
	[btnAddEvent.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
	[btnAddEvent.titleLabel setShadowColor:[UIColor blackColor]];
	[btnAddEvent.titleLabel setShadowOffset:CGSizeMake(0, 1)];
	[btnAddEvent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAddEvent addTarget:self action:@selector(createEvent) forControlEvents:UIControlEventTouchUpInside];

	[tableHeaderView addSubview:btnAddEvent];
	self.menuTableView.tableHeaderView = tableHeaderView;
	
	//guest
//	[headerViewSeparator setFrame:CGRectMake(120, 3, 1, 36)];
//
//	btnSignup = [[UIButton alloc] initWithFrame:CGRectMake(127, 6, 104, 32)];
//	[btnSignup setBackgroundImage:[UIImage imageNamed:@"menu_user_btn_dark"] forState:UIControlStateNormal];
//	[btnSignup setBackgroundImage:[UIImage imageNamed:@"menu_user_btn_dark_pressed"] forState:UIControlStateHighlighted];
//	[btnSignup setTitle:@"注册" forState:UIControlStateNormal];
//	[btnSignup.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
//	[btnSignup.titleLabel setShadowColor:[UIColor blackColor]];
//	[btnSignup.titleLabel setShadowOffset:CGSizeMake(0, 1)];
//	[btnSignup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//	[tableHeaderView addSubview:btnSignup];
//
//	btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 104, 32)];
//	[btnLogin setBackgroundImage:[UIImage imageNamed:@"menu_user_btn"] forState:UIControlStateNormal];
//	[btnLogin setBackgroundImage:[UIImage imageNamed:@"menu_user_btn_pressed"] forState:UIControlStateHighlighted];
//	[btnLogin setTitle:@"登录" forState:UIControlStateNormal];
//	[btnLogin.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
//	[btnLogin.titleLabel setShadowColor:[UIColor blackColor]];
//	[btnLogin.titleLabel setShadowOffset:CGSizeMake(0, 1)];
//	[btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//	[tableHeaderView addSubview:btnLogin];

	
	//TableFooterView
//	UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//	
//	UILabel *logoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 13, 100, 24)];
//	[logoutLabel setText:@"退出登录"];
//	[tableFooterView addSubview:logoutLabel];
//	
//	self.menuTableView.tableFooterView = tableFooterView;

}

- (void)viewDidUnload
{
	[self setMenuTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    BOMenuTableViewCell *selectedCell = (BOMenuTableViewCell *)[menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedMenu inSection:0]];
    [selectedCell setHighlighted:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[menuTableView release];
    [userAvatar release];
	[super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    BOMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[BOMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	switch (indexPath.row) {
		case 0:
			[cell.menuLabel setText:@"最新"];
			[cell.menuIcon setImage:[UIImage imageNamed:@"11-glyphish-clock-gray"]];
			[cell.menuIconHighlighted setImage:[UIImage imageNamed:@"11-glyphish-clock-blue"]];
			break;
		case 1:
			[cell.menuLabel setText:@"参加活动"];
			[cell.menuIcon setImage:[UIImage imageNamed:@"28-glyphish-star-gray"]];
			[cell.menuIconHighlighted setImage:[UIImage imageNamed:@"28-glyphish-star-blue"]];
			break;
		case 2:
			[cell.menuLabel setText:@"我的活动"];
			[cell.menuIcon setImage:[UIImage imageNamed:@"44-glyphish-shoebox-gray"]];
			[cell.menuIconHighlighted setImage:[UIImage imageNamed:@"44-glyphish-shoebox-blue"]];
			break;
		case 3:
			[cell.menuLabel setText:@"设置"];
			[cell.menuIcon setImage:[UIImage imageNamed:@"19-glyphish-gear-gray"]];
			[cell.menuIconHighlighted setImage:[UIImage imageNamed:@"19-glyphish-gear-blue"]];
			break;
        case 4:
			[cell.menuLabel setText:@"退出"];
			[cell.menuIcon setImage:[UIImage imageNamed:@"icon_logout"]];
			break;
	  default:
		break;
	}
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selectedMenu >= 0 && self.selectedMenu != indexPath.row){
        BOMenuTableViewCell *lastCell = (BOMenuTableViewCell *)[menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedMenu inSection:0]];
        [lastCell setHighlighted:NO];
    }
    self.selectedMenu = indexPath.row;
    
    if(indexPath.row == 4){
        [[AppDelegate sharedDelegate] logout];
    }else if (indexPath.row == 3) {
        FESettingsViewController *settingsController = [[[FESettingsViewController alloc] initWithNibName:@"FESettingsViewController" bundle:nil] autorelease];
        [self.viewDeckController closeLeftViewBouncing:nil completion:^(IIViewDeckController *controller) {
            [[AppDelegate sharedDelegate].navigationController pushViewController:settingsController animated:NO];
        }];
    }else if (indexPath.row == 2) {
        FEMyEventListController *myEventController = [[[FEMyEventListController alloc] init] autorelease];
        [self.viewDeckController closeLeftViewBouncing:nil completion:^(IIViewDeckController *controller) {
            [[AppDelegate sharedDelegate].navigationController pushViewController:myEventController animated:NO];
        }];
    }else if (indexPath.row == 1) {
        FEAttendEventListController *attendEventController = [[[FEAttendEventListController alloc] init] autorelease];
        [self.viewDeckController closeLeftViewBouncing:nil completion:^(IIViewDeckController *controller) {
            [[AppDelegate sharedDelegate].navigationController pushViewController:attendEventController animated:NO];
        }];
    }else if (indexPath.row == 0) {
        FEEventListController *eventController = [[[FEEventListController alloc] init] autorelease];
        [self.viewDeckController closeLeftViewBouncing:nil completion:^(IIViewDeckController *controller) {
            [[AppDelegate sharedDelegate].navigationController pushViewController:eventController animated:NO];
        }];
    }
}

- (void)createEvent
{
    FECreateEventController *createEventController = [[[FECreateEventController alloc] init] autorelease];
    createEventController.parentController = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createEventController];
    [[AppDelegate sharedDelegate].navigationController presentModalViewController:navController animated:YES];
    [navController release];
}

- (void)updateUserAvatar
{
    NSLog(@"updateavatar: %@", [AppDelegate sharedDelegate].selfUser.avatarURL);
    if([AppDelegate sharedDelegate].selfUser.avatarURL != nil){
        [userAvatar loadImageAsync:[AppDelegate sharedDelegate].selfUser.avatarURL withQueue:nil];
    }else {
        userAvatar.image = [UIImage imageNamed:@"avatar_holder_32"];
    }
}

@end
