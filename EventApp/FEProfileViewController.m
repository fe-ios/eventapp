//
//  FEProfileViewController.m
//  EventApp
//
//  Created by Yin Zhengbo on 9/18/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import "FEProfileViewController.h"
#import "AppDelegate.h"


@interface FEProfileViewController ()

@end

@implementation FEProfileViewController
@synthesize avatarFrame;
@synthesize userName;
@synthesize email;
@synthesize profileTabAttendButton;
@synthesize profileTabOrgButton;

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
	userName.text = (NSString *) [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
	email.text = (NSString *) [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
	
	[profileTabAttendButton setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];
	[profileTabAttendButton setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateSelected];
	[profileTabAttendButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	[profileTabOrgButton setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateSelected];
	[profileTabOrgButton setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];
	[profileTabOrgButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	UIImageView *userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 64, 64)];
	[userAvatar setImage:[AppDelegate sharedDelegate].selfUser.avatarImage];
	[self.view insertSubview:userAvatar belowSubview:avatarFrame];
	[profileTabOrgButton setSelected:YES];
}

- (void)viewDidUnload
{
    [self setProfileTabAttendButton:nil];
    [self setProfileTabOrgButton:nil];
	[self setUserName:nil];
	[self setEmail:nil];
	[self setAvatarFrame:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)profileTabAttend:(UIButton *)sender {
	[sender setSelected:YES];
	[profileTabOrgButton setSelected:NO];
}

- (IBAction)profileTabOrg:(UIButton *)sender {
	[sender setSelected:YES];
	[profileTabAttendButton setSelected:NO];
}
- (void)dealloc {
    [profileTabAttendButton release];
    [profileTabOrgButton release];
	[userName release];
	[email release];
	[avatarFrame release];
    [super dealloc];
}
@end
