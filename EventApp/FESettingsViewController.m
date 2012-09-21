//
//  FESettingsViewController.m
//  EventApp
//
//  Created by Yin Zhengbo on 9/19/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import "FESettingsViewController.h"
#import "AppDelegate.h"
#import "FEProfileViewController.h"
#import "FEProfileSettingsViewController.h"

@interface FESettingsViewController ()

@end

@implementation FESettingsViewController

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

    UIBarButtonItem *leftBarButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuButton"] style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)] autorelease];
	self.navigationItem.leftBarButtonItem = leftBarButton;

	[self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return @"帐户";
			break;
		case 1:
			return @"其他";
			break;

		default:
			break;
	}
	return @"";
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
	  case 0:
		return 1;
		break;
	case 1:
		return 2;
		break;
	default:
		break;
	}
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"configCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	if (indexPath.section == 0 && indexPath.row == 0 ) {
		cell.textLabel.text = (NSString *) [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
		cell.imageView.image = [UIImage imageNamed:@"avatar_holder_32"];
		cell.imageView.frame = CGRectMake(6, 6, 32, 32);
		cell.detailTextLabel.text = (NSString *) [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	}
	if (indexPath.section == 1 && indexPath.row == 0) {
		cell.textLabel.text = @"版本";
		cell.detailTextLabel.text = @"1.0";
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	if (indexPath.section == 1 && indexPath.row == 1) {
		cell.textLabel.text = @"关于";
	}
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.row == 0) {
		FEProfileSettingsViewController *profileController = [[FEProfileSettingsViewController alloc] initWithNibName:@"FEProfileSettingsViewController" bundle:nil];
		[self.navigationController pushViewController:profileController animated:YES];
	}
}

@end
