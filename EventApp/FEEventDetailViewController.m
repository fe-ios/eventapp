//
//  FEEventDetailViewController.m
//  EventApp
//
//  Created by Yin Zhengbo on 8/13/12.
//  Copyright (c) 2012 snda. All rights reserved.
//

#import "FEEventDetailViewController.h"

@interface FEEventDetailViewController ()

@end

@implementation FEEventDetailViewController

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
	UIImage *gridBackgroundImage = [[UIImage imageNamed:@"detail_grid"] resizableImageWithCapInsets:UIEdgeInsetsMake(62, 0, 62, 0)];
	UIImageView *gridBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
	[gridBackground setImage:gridBackgroundImage];
	[self.view addSubview:gridBackground];
    // Do any additional setup after loading the view from its nib.
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

@end
