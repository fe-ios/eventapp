//
//  FEEventAttendeeViewController.m
//  EventApp
//
//  Created by Yin Zhengbo on 9/17/12.
//  Copyright (c) 2012 snda. All rights reserved.
//
#import "FEEventAttendeeViewController.h"
#import "FEProfileViewController.h"

@interface FEEventAttendeeViewController ()

@end

@implementation FEEventAttendeeViewController

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
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	self.view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AttendeeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	//Cell 分割线
	UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
	[separator setImage:[UIImage imageNamed:@"attendee_separator"]];
	[cell.contentView addSubview:separator];
	//临时头像
	UIImageView *avatar_tmp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
	[avatar_tmp setImage:[UIImage imageNamed:@"avatar_tmp"]];
	[cell.contentView addSubview:avatar_tmp];
	//checkmark
	UIImageView *checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(320-24-10, 10, 24, 24)];
	[checkmark setImage:[UIImage imageNamed:@"checkmark"]];
	//
	UIImage *greenBtnImage = [[UIImage imageNamed:@"attendee_btn_approve"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 16, 14, 16)];
	UIButton *accept = [[UIButton alloc] initWithFrame:CGRectMake(320-10-56, 8, 56, 28)];
	[accept setBackgroundImage:greenBtnImage forState:UIControlStateNormal];
	[accept setTitle:@"确认" forState:UIControlStateNormal];

	UIImage *redBtnImage = [[UIImage imageNamed:@"attendee_btn_reject"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 16, 14, 16)];
	UIButton *reject = [[UIButton alloc] initWithFrame:CGRectMake(320-10-56-5-56, 8, 56, 28)];
	[reject setBackgroundImage:redBtnImage forState:UIControlStateNormal];
	[reject setTitle:@"拒绝" forState:UIControlStateNormal];
	
	UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(54, 14, 160, 20)];
	[name setBackgroundColor:[UIColor clearColor]];
	[cell.contentView addSubview:name];
	
	switch (indexPath.row) {
	  case 0:
		[name setText:@"Jean Albus"];
		[cell.contentView addSubview:checkmark];
		break;
	  case 1:
		[name setText:@"Marvellous"];
		[cell.contentView addSubview:accept];
		[cell.contentView addSubview:reject];
		break;
	  case 2:
		[name setText:@"Gry"];
		[cell.contentView addSubview:checkmark];
		break;
	  case 3:
		[name setText:@"Mary Hockenbery"];
		[cell.contentView addSubview:checkmark];
		break;
	  default:
		break;
	}
	return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
		FEProfileViewController *profileView = [[FEProfileViewController alloc] init];
		[self.navigationController pushViewController:profileView animated:YES];
}

@end
