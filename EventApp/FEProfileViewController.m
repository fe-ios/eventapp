//
//  FEProfileViewController.m
//  EventApp
//
//  Created by Yin Zhengbo on 9/18/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import "FEProfileViewController.h"

@interface FEProfileViewController ()

@end

@implementation FEProfileViewController
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
	[profileTabOrgButton setSelected:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setProfileTabAttendButton:nil];
    [self setProfileTabOrgButton:nil];
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
    [super dealloc];
}
@end
