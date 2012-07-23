//
//  BOMenuViewController.m
//  EventApp
//
//  Created by Yin Zhengbo on 7/19/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import "BOMenuViewController.h"
#import "BOMenuTableViewCell.h"

@interface BOMenuViewController ()

@end

@implementation BOMenuViewController
@synthesize menuTableView;
@synthesize navigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.menuTableView.delegate = self;
	self.menuTableView.dataSource = self;
	[self.menuTableView setBackgroundColor:[UIColor clearColor]];
	
	//account cell
	UIImage *accountCellBg = [UIImage imageNamed:@"menuAccountCell"];
	UIButton *accountCellButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	[accountCellButton setBackgroundImage:accountCellBg forState:UIControlStateNormal];
	[self.navigationBar addSubview:accountCellButton];
}

- (void)viewDidUnload
{
	[self setMenuTableView:nil];
	[self setNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[menuTableView release];
	[navigationBar release];
	[super dealloc];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
	if (section==0) {
	  return 0;
	}
	return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
	[backgroundImage setImage:[UIImage imageNamed:@"menuSectionHeader"]];
	[sectionView addSubview:backgroundImage];
	
	UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 14)];
	sectionLabel.textColor = [UIColor colorWithRed:53.0/255.0 green:42.0/255.0 blue:62.0/255.0 alpha:1.0];
	sectionLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	sectionLabel.shadowColor = [UIColor colorWithRed:112.0/255.0 green:95.0/255.0 blue:126.0/255.0 alpha:1.0];
	[sectionLabel setShadowOffset:CGSizeMake(0, 1)];
	sectionLabel.backgroundColor = [UIColor clearColor];
	if (section == 0) {
		sectionView.frame = CGRectMake(0, 0, 0, 0);
	} else if (section == 1) {
		sectionLabel.text = @"EVERYBODY";
	} else if(section == 2){
		sectionLabel.text = @"ME & MY FRIENDS";
	} else if(section == 3){
		sectionLabel.text = @"ABOUT";
	}
	[sectionView addSubview:sectionLabel];
	return sectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
	  case 0:
		return 1;
		break;
	  case 1:
		return 3;
		break;
	  case 2:
		return 3;
		break;
	  case 3:
		return 1;
		break;
	  default:
		break;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BOMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[BOMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	if (indexPath.section == 0 && indexPath.row == 0) {
		[cell.menuLabel setText:@"新事件"];
		[cell.menuIcon setImage:[UIImage imageNamed:@"menuIconPlus"]];
		[cell.menuIcon setFrame:CGRectMake(10, 11, 22, 22)];
	}
	if (indexPath.section == 1 && indexPath.row == 0) {
		[cell.menuLabel setText:@"热门"];
  		[cell.menuIcon setImage:[UIImage imageNamed:@"menuIconPopular"]];
	}
	if (indexPath.section == 1 && indexPath.row == 1) {
		[cell.menuLabel setText:@"附近"];
  		[cell.menuIcon setImage:[UIImage imageNamed:@"menuIconNearby"]];
	}
	if (indexPath.section == 1 && indexPath.row == 2) {
		[cell.menuLabel setText:@"最新"];
  		[cell.menuIcon setImage:[UIImage imageNamed:@"menuIconRecent"]];
	}
	if (indexPath.section == 2 && indexPath.row == 0) {
		[cell.menuLabel setText:@"关注的"];
  		[cell.menuIcon setImage:[UIImage imageNamed:@"menuIconLiked"]];
	}
	if (indexPath.section == 2 && indexPath.row == 1) {
		[cell.menuLabel setText:@"我的事件"];
  		[cell.menuIcon setImage:[UIImage imageNamed:@"menuIconPersonal"]];
	}
	if (indexPath.section == 2 && indexPath.row == 2) {
		[cell.menuLabel setText:@"朋友的事件"];
  		[cell.menuIcon setImage:[UIImage imageNamed:@"menuIconFriends"]];
	}
	if (indexPath.section == 3 && indexPath.row == 0) {
		[cell.menuLabel setText:@"关于我们"];
  		[cell.menuIcon setImage:[UIImage imageNamed:@"menuIconAbout"]];
	}
    return cell;
	
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"%d",indexPath.row);
}

@end
