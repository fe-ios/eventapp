//
//  BOEventQuickAddViewController.m
//  Events
//
//  Created by Yin Zhengbo on 7/13/12.
//  Copyright (c) 2012 SNDA. All rights reserved.
//

#import "BOEventQuickAddViewController.h"

@interface BOEventQuickAddViewController ()

@end

@implementation BOEventQuickAddViewController
@synthesize toolbar;
@synthesize textViewInput;
@synthesize inputViewBackground;

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
	self.inputViewBackground.keyboardTriggerOffset = -44.0f;
	
	self.toolbar = [[BOEventQuickAddInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	self.textViewInput.inputAccessoryView = self.toolbar;
	[self.textViewInput becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] addObserver:self
										 selector:@selector(keyboardWillShow:)
											 name:UIKeyboardWillShowNotification
										   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
										 selector:@selector(keyboardWillHide:)
											 name:UIKeyboardWillHideNotification
										   object:nil];
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

- (void)viewDidUnload {
	[self setTextViewInput:nil];
	[self setToolbar:nil];
	[self setInputViewBackground:nil];
	[super viewDidUnload];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
}

- (void)keyboardWillHide:(NSNotification *)notification
{
}


- (IBAction)cancelAction:(UIBarButtonItem *)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)eventSave:(UIBarButtonItem *)sender {
	[self.textViewInput resignFirstResponder];
	//[self dismissModalViewControllerAnimated:YES];
}
@end
