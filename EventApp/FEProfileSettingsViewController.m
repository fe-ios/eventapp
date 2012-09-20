//
//  FEProfileSettingsViewController.m
//  EventApp
//
//  Created by Yin Zhengbo on 9/19/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import "FEProfileSettingsViewController.h"

@interface FEProfileSettingsViewController ()

@end

@implementation FEProfileSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.tableView setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
	UIBarButtonItem *saveProfile = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:nil];
	self.navigationItem.rightBarButtonItem = saveProfile;
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIImageView *userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(160-32, 8, 64, 64)];
	[userAvatar setImage:[UIImage imageNamed:@"temp"]];
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
	[headerView addSubview:userAvatar];
	
	UIImageView *userAvatarFrame = [[UIImageView alloc] initWithFrame:CGRectMake(160-32, 8, 64, 64)];
	[userAvatarFrame setImage:[UIImage imageNamed:@"profile_photo_frame"]];
	[headerView addSubview:userAvatarFrame];
	
	UIButton *editAvatar = [[UIButton alloc] initWithFrame:CGRectMake(160-32, 8, 64, 64)];
	[editAvatar setBackgroundColor:[UIColor clearColor]];
	
	UILabel *editAvatarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 64, 20)];
	[editAvatarLabel setText:@"编辑"];
	[editAvatarLabel setTextAlignment:UITextAlignmentCenter];
	[editAvatarLabel setTextColor:[UIColor whiteColor]];
	[editAvatarLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
	[editAvatarLabel setFont:[UIFont systemFontOfSize:14.0f]];
	[editAvatar addSubview:editAvatarLabel];
	
	[headerView addSubview:editAvatar];
	
	return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"profileEditCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	if (indexPath.section == 0 && indexPath.row == 0 ) {
		UITextField *userNameField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12, 200, 20)];
		[userNameField setClearButtonMode:UITextFieldViewModeWhileEditing];
		[userNameField setFont:[UIFont systemFontOfSize:16.0f]];
		[userNameField setBackgroundColor:[UIColor clearColor]];
		userNameField.text = (NSString *) [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
		[cell.contentView addSubview:userNameField];
		cell.textLabel.text = @"用户名";
	}
	if (indexPath.section == 0 && indexPath.row == 1 ) {
		UITextField *emailField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12, 200, 20)];
		emailField.text = @"fancyeverol@gmail.com";
		[emailField setFont:[UIFont systemFontOfSize:15.0f]];
		[emailField setBackgroundColor:[UIColor clearColor]];
		[emailField setEnabled:NO];
		emailField.textColor = [UIColor lightGrayColor];
		[cell.contentView addSubview:emailField];
		cell.textLabel.text = @"邮箱";
	}
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
