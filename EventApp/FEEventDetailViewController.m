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

#define MAX_HEIGHT 2000

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString *foo = @"asdf setAutoresizing Mask:UIViewAutoresizing FlexibleHeight,Mask:UIViewAutoresizing,Mask:UIViewAutoresizing,Mask:UIViewAutoresizing,Mask:UIViewAutoresizing";

	CGSize size = [foo sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, MAX_HEIGHT)
						lineBreakMode:UILineBreakModeWordWrap];
	
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 50, 260, size.height + 10)];
	textView.backgroundColor = [UIColor clearColor];
	textView.text = foo;
	
	UIImage *gridBackgroundImage = [[UIImage imageNamed:@"detail_grid"] resizableImageWithCapInsets:UIEdgeInsetsMake(62, 0, 62, 0)];
	UIImageView *gridBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, size.height+60)];
	[gridBackground setImage:gridBackgroundImage];
	[self.view addSubview:gridBackground];
	[gridBackground addSubview:textView];
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

- (void)dealloc {
	[super dealloc];
}
@end
