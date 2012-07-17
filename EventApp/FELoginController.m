//
//  FELoginController.m
//  EventApp
//
//  Created by zhenglin li on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FELoginController.h"
#import "ASIHttpRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "FELoginView.h"
#import "FERegisterView.h"
#import "FEServerAPI.h"
#import <QuartzCore/QuartzCore.h>
#import "FELoginViewController.h"

@interface FELoginController ()
{
    FERegisterView* _regView;
    FELoginView* _loginView;
    
}

@end

@implementation FELoginController

@synthesize loginController = _loginController;

@synthesize isRegistration;

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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBackground"] forBarMetrics:UIBarMetricsDefault];
    
    //left button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 55, 31);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"ButtonDarkGrey30px"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"ButtonDarkGrey30pxSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftButton] autorelease];
    
    self.loginController = [[[FELoginViewController alloc] init] autorelease];
    self.loginController.view.frame = CGRectMake(0, 0, 320, 460);
    [self.view addSubview:self.loginController.view];
    
    return;
    
    //registration view
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FERegisterView" owner:nil options:nil];
    FERegisterView *regView = (FERegisterView *)[nibs objectAtIndex:0];
    [self.view addSubview:regView];
    [regView.goLoginButton addTarget:self action:@selector(toggleLoginAndRegistration) forControlEvents:UIControlEventTouchUpInside];
    [regView.registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    regView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBackground_wood.jpg"]];
    _regView = regView;
    
    //login view
    nibs = [[NSBundle mainBundle] loadNibNamed:@"FELoginView" owner:nil options:nil];
    FELoginView *loginView = (FELoginView *)[nibs objectAtIndex:0];
    [self.view addSubview:loginView];
    [loginView.goRegisterButton addTarget:self action:@selector(toggleLoginAndRegistration) forControlEvents:UIControlEventTouchUpInside];
    [loginView.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    loginView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBackground_wood.jpg"]];
    _loginView = loginView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [super dealloc];
}

- (void)prepareView
{
    _loginView.hidden = self.isRegistration ? YES : NO;
    _regView.hidden = self.isRegistration ? NO : YES;
    self.title = self.isRegistration ? @"注册" : @"登录";
}

- (void)goBack
{
    [self.view.window exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [[self.view.window.subviews objectAtIndex:0] setHidden:YES];
    [[self.view.window.subviews objectAtIndex:1] setHidden:NO];
    
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:@"pushAnimaition"];
}

- (void)registerAction
{
    NSURL *registerURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_BASE, API_REGISTER]];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:registerURL];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
    [request setPostValue:_regView.nameField.text forKey:@"username"];
    [request setPostValue:_regView.passwordField.text forKey:@"password"];
    request.delegate = self;
    [request startAsynchronous];
    [request release];
}

- (void)loginAction
{
    NSURL *loginURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_BASE, API_LOGIN]];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:loginURL];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
    [request setPostValue:_loginView.nameField.text forKey:@"username"];
    [request setPostValue:_loginView.passwordField.text forKey:@"password"];
    request.delegate = self;
    [request startAsynchronous];
    [request release];
}

- (void)toggleLoginAndRegistration
{
    [UIView beginAnimations:@"flipAnimation" context:nil];
    [UIView setAnimationDuration:0.65];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(flipAnimationStop)];
    self.isRegistration = !self.isRegistration;
    _loginView.hidden = self.isRegistration ? YES : NO;
    _regView.hidden = self.isRegistration ? NO : YES;
    [UIView commitAnimations];
}

-(void)flipAnimationStop
{
    self.title = self.isRegistration ? @"注册" : @"登录";
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%d, %@", request.responseStatusCode, request.responseString);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@ failed.", request.url);
}

@end
