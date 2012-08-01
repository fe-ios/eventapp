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
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern-1"]]];
	self.menuTableView.delegate = self;
	self.menuTableView.dataSource = self;
	[self.menuTableView setBackgroundColor:[UIColor clearColor]];
	
	//account cell
	UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
	UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(49, 20, 102, 56)];
	logo.image = [UIImage imageNamed:@"tmp_logo"];
	[tableHeaderView addSubview:logo];
	self.menuTableView.tableHeaderView = tableHeaderView;
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
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
//{
//	if (section==0) {
//	  return 0;
//	}
//	return 25;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//	UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
////	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
////	[backgroundImage setImage:[UIImage imageNamed:@"menuSectionHeader"]];
////	[sectionView addSubview:backgroundImage];
//	
//	UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 14)];
//	sectionLabel.textColor = [UIColor colorWithRed:53.0/255.0 green:42.0/255.0 blue:62.0/255.0 alpha:1.0];
//	sectionLabel.font = [UIFont boldSystemFontOfSize:12.0f];
//	sectionLabel.shadowColor = [UIColor colorWithRed:112.0/255.0 green:95.0/255.0 blue:126.0/255.0 alpha:1.0];
//	[sectionLabel setShadowOffset:CGSizeMake(0, 1)];
//	sectionLabel.backgroundColor = [UIColor clearColor];
//	if (section == 0) {
//		sectionView.frame = CGRectMake(0, 0, 0, 0);
//	} else if (section == 1) {
//		sectionLabel.text = @"EVERYBODY";
//	} else if(section == 2){
//		sectionLabel.text = @"ME & MY FRIENDS";
//	} else if(section == 3){
//		sectionLabel.text = @"ABOUT";
//	}
//	[sectionView addSubview:sectionLabel];
//	return sectionView;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BOMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[BOMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	switch (indexPath.row) {
		case 0:
			[cell.menuLabel setText:@"Popular"];
			[cell.menuIcon setImage:[UIImage imageNamed:@"122-glyphish-stats-gray"]];
			[cell.menuIconHighlighted setImage:[UIImage imageNamed:@"122-glyphish-stats-blue"]];
			break;
		case 1:
			[cell.menuLabel setText:@"Near"];
			[cell.menuIcon setImage:[UIImage imageNamed:@"7-glyphish-map-marker-gray"]];
			[cell.menuIconHighlighted setImage:[UIImage imageNamed:@"7-glyphish-map-marker-blue"]];
			break;
		case 2:
			[cell.menuLabel setText:@"Recent"];
			[cell.menuIcon setImage:[UIImage imageNamed:@"11-glyphish-clock-gray"]];
			[cell.menuIconHighlighted setImage:[UIImage imageNamed:@"11-glyphish-clock-blue"]];
			break;
		case 3:
			[cell.menuLabel setText:@"Watched"];
			[cell.menuIcon setImage:[UIImage imageNamed:@"44-glyphish-shoebox-gray"]];
			[cell.menuIconHighlighted setImage:[UIImage imageNamed:@"44-glyphish-shoebox-blue"]];
			break;
		case 4:
			[cell.menuLabel setText:@"My Events"];
			[cell.menuIcon setImage:[UIImage imageNamed:@"29-glyphish-heart-gray"]];
			[cell.menuIconHighlighted setImage:[UIImage imageNamed:@"29-glyphish-heart-blue"]];
			break;
		case 5:
			[cell.menuLabel setText:@"Friends"];
			[cell.menuIcon setImage:[UIImage imageNamed:@"112-glyphish-group-gray"]];
			[cell.menuIconHighlighted setImage:[UIImage imageNamed:@"112-glyphish-group-blue"]];
			break;
		case 6:
			[cell.menuLabel setText:@"Settings"];
			[cell.menuIcon setImage:[UIImage imageNamed:@"19-glyphish-gear-gray"]];
			[cell.menuIconHighlighted setImage:[UIImage imageNamed:@"19-glyphish-gear-blue"]];
			break;
	  default:
		break;
	}
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"%d",indexPath.row);
}

@end
