//
//  FEStartViewController.m
//  EventApp
//
//  Created by zhenglin li on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FEStartViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FELoginViewController.h"
#import "AppDelegate.h"

@interface FEStartViewController ()
{
    UIPageControl* _pageControl;
    UIScrollView* _scrollView;
    UIButton* _loginBtn;
    UIButton* _registerBtn;
}


@end

@implementation FEStartViewController

@synthesize loginController = _loginController;
@synthesize registerController = _registerController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //nothing
    }
    return self;
}

- (void)dealloc
{
    [_loginController release];
    [_registerController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSMutableArray *pages = [[NSMutableArray alloc] initWithObjects:@"StartViewIcon", @"StartViewTutorial_0", @"StartViewTutorial_1", nil];
    NSMutableArray *pages = [[NSMutableArray alloc] initWithObjects:@"startLogo", nil];
    
    //翻页容器
    CGRect scrollFrame = CGRectMake(0, 20, 320, 230);
    _scrollView = [[[UIScrollView alloc] init] autorelease];
    _scrollView.frame = scrollFrame;
    _scrollView.contentSize = CGSizeMake(scrollFrame.size.width*pages.count, scrollFrame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    //创建所有内容页面
    for(int i = 0; i < pages.count; i++){
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*scrollFrame.size.width, 0, scrollFrame.size.width, scrollFrame.size.height);
        imageView.image = [UIImage imageNamed:[pages objectAtIndex:i]];
        [_scrollView addSubview:imageView];
        [imageView release];
    }
    
    //翻页控件
    _pageControl = [[[UIPageControl alloc] init] autorelease];
    _pageControl.frame = CGRectMake(0, 250, 320, 60);
    _pageControl.numberOfPages = pages.count;
    _pageControl.currentPage = 0;
    [_pageControl addTarget:self action:@selector(turnPage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    
    //登录按钮
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.frame = CGRectMake(30, 320, 320-30*2, 46);
    [loginBtn setBackgroundImage:[[UIImage imageNamed:@"ButtonLightGreyShadow46px"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 9, 10, 9)] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[[UIImage imageNamed:@"ButtonLightGreyShadow46pxSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 9, 10, 9)] forState:UIControlStateHighlighted];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    loginBtn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [loginBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(goLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    _loginBtn = loginBtn;
    [loginBtn release];
    
    //注册按钮
    UIButton *registerBtn = [[UIButton alloc] init];
    registerBtn.frame = CGRectMake(30, 320+60, 320-30*2, 46);
    [registerBtn setBackgroundImage:[[UIImage imageNamed:@"ButtonLightGreyShadow46px"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 9, 10, 9)] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[[UIImage imageNamed:@"ButtonLightGreyShadow46pxSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 9, 10, 9)] forState:UIControlStateHighlighted];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    registerBtn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [registerBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [registerBtn setTitle:@"注册新用户" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(goRegistration:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    _registerBtn = registerBtn;
    [registerBtn release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControl.currentPage = page;
}

- (void) turnPage: (UIPageControl *) pageControl
{
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width*pageControl.currentPage, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
}

- (void) goLogin: (UIButton *)sender
{
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    if(!self.loginController){
        FELoginViewController *loginViewController = [[[FELoginViewController alloc] init] autorelease];
        self.loginController = loginViewController;
        [self.view.window addSubview:appDelegate.navigationController.view];
    }else {
        [self.view.window exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    }
    if(![appDelegate.navigationController.viewControllers containsObject:self.loginController]){
        [appDelegate.navigationController pushViewController:self.loginController animated:NO];
    }
    [self.loginController performSelector:@selector(focusFirstTextInput) withObject:nil afterDelay:0.2];
    
    [[self.view.window.subviews objectAtIndex:0] setHidden:YES];
    [[self.view.window.subviews objectAtIndex:1] setHidden:NO];
    
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:@"pushAnimaition"];
}

- (void) goRegistration: (UIButton *)sender
{
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    if(!self.registerController){
        FERegisterViewController *regViewController = [[[FERegisterViewController alloc] init] autorelease];
        self.registerController = regViewController;
        [self.view.window addSubview:appDelegate.navigationController.view];
    }else {
        [self.view.window exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    }
    
    if(![appDelegate.navigationController.viewControllers containsObject:self.registerController]){
        [appDelegate.navigationController pushViewController:self.registerController animated:NO];
    }
    [self.registerController performSelector:@selector(focusFirstTextInput) withObject:nil afterDelay:0.2];
    
    [[self.view.window.subviews objectAtIndex:0] setHidden:YES];
    [[self.view.window.subviews objectAtIndex:1] setHidden:NO];
    
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:@"pushAnimaition"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    //nothing
}

@end
