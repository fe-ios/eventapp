//
//  BOCenterViewController.m
//  Events
//
//  Created by Yin Zhengbo on 7/13/12.
//  Copyright (c) 2012 SNDA. All rights reserved.
//

#import "BOCenterViewController.h"
#import "IIViewDeckController.h"
#import "BOEventQuickAddViewController.h"

@interface BOCenterViewController ()

@end

@implementation BOCenterViewController

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
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
	UIImageView *headerViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -480, 320, 480)];
	[headerViewImage setImage:[UIImage imageNamed:@"WKWorkspaceTableViewHeaderFooter.jpg"]];
	[headerView addSubview:headerViewImage];
	self.tableView.tableHeaderView = headerView;

	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
	UIImageView *footerViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[footerViewImage setImage:[UIImage imageNamed:@"WKWorkspaceTableViewHeaderFooter.jpg"]];
	[footerView addSubview:footerViewImage];
	self.tableView.tableFooterView = footerView;

	
	self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 416, 320, 44)];
	//Wood Background
	UIImageView *woodBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WKWorkspaceBackground_wood.jpg"]];
	[woodBackground setFrame:CGRectMake(0, -64, 320, 480)];
	self.tableView.backgroundView = woodBackground;
	
	UIImageView *toolbarBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WKToolbarBackground"]];
	[toolbarBackground setFrame:CGRectMake(0, 0, 320, 44)];
	[self.toolBar insertSubview:toolbarBackground atIndex:1];
	
	//Toolbar
	self.toolBarEvents = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 126, 44)];
	[self.toolBarEvents setBackgroundImage:[UIImage imageNamed:@"WKToolbarTasksButtonSelected"] forState:UIControlStateHighlighted];
	[self.toolBarEvents setImage:[UIImage imageNamed:@"WKToolbarTasksButton"] forState:UIControlStateNormal];
	[self.toolBar insertSubview:self.toolBarEvents atIndex:2];
	
	//Toolbar Buttons
	self.toolBarExplore = [[UIButton alloc] initWithFrame:CGRectMake(194, 0, 126, 44)];
	[self.toolBarExplore setBackgroundImage:[UIImage imageNamed:@"WKToolbarNotificationsButtonSelected"] forState:UIControlStateHighlighted];
	[self.toolBarExplore setImage:[UIImage imageNamed:@"WKToolbarNotificationsButton"] forState:UIControlStateNormal];
	[self.toolBar insertSubview:self.toolBarExplore atIndex:2];

	self.toolBarQuickAdd = [[UIButton alloc] initWithFrame:CGRectMake(120, -9, 80, 53)];
	[self.toolBarQuickAdd setImage:[UIImage imageNamed:@"WKQuickAddToolbarButton"] forState:UIControlStateNormal];
	[self.toolBarQuickAdd setImage:[UIImage imageNamed:@"WKQuickAddToolbarButtonSelected"] forState:UIControlStateHighlighted];
	[self.toolBarQuickAdd addTarget:self action:@selector(eventQuickAdd) forControlEvents:UIControlEventTouchUpInside];
	[self.toolBar insertSubview:self.toolBarQuickAdd atIndex:3];
	[self.toolBar bringSubviewToFront:self.toolBarQuickAdd];
	
	//Navigationbar Buttons
	UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WKNavigationSidebarButton"] style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)];
	self.navigationItem.leftBarButtonItem = leftBarButton;
	
	[self.navigationController.view addSubview:self.toolBar];
}

-(void)eventQuickAdd
{
	BOEventQuickAddViewController *quickAddViewController = [[BOEventQuickAddViewController alloc] initWithNibName:@"BOEventQuickAddViewController" bundle:nil];
	[self.navigationController presentModalViewController:quickAddViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
	  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:	CellIdentifier];
	}
	cell.textLabel.text = @"test";
	UIImageView *cellBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 67)];
	[cellBackground setImage:[UIImage imageNamed:@"WKWorkspaceTableViewCellBackground"]];
	cell.backgroundView = cellBackground;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
