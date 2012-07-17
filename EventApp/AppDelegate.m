//
//  AppDelegate.m
//  EventApp
//
//  Created by zhenglin li on 12-7-2.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "FEStartViewController.h"
#import "IIViewDeckController.h"
#import "BOCenterViewController.h"
#import "BOMenuViewController.h"
#import "BOEventsViewController.h"
#import "WrapController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize wrapController = _wrapController;
@synthesize navigationController = _navigationController;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.navigationController = [[[UINavigationController alloc] init] autorelease];
    FEStartViewController *startController = [[[FEStartViewController alloc] init] autorelease];
    startController.navController = self.navigationController;
    self.wrapController = [[[WrapController alloc] initWithViewController:startController] autorelease];
    self.window.rootViewController = self.wrapController;

    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)startMainView
{
    [self customApperance];
    
    BOCenterViewController *centerController = [[BOCenterViewController alloc] initWithNibName:@"BOCenterViewController" bundle:nil];
    BOEventsViewController *eventsViewController = [[BOEventsViewController alloc] initWithNibName:@"BOEventsViewController" bundle:nil];
    BOMenuViewController *menuViewController = [[BOMenuViewController alloc] initWithNibName:@"BOMenuViewController" bundle:nil];
    IIViewDeckController *deckController = [[IIViewDeckController alloc] initWithCenterViewController:centerController leftViewController: menuViewController rightViewController:eventsViewController];
    deckController.navigationControllerBehavior = IIViewDeckNavigationControllerIntegrated;
    
    [self.navigationController pushViewController:deckController animated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) customApperance
{
	//Custom navigation
	UIImage *customNavigationBarBackground = [[UIImage imageNamed:@"WKNavigationBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
	[[UINavigationBar appearance] setBackgroundImage:customNavigationBarBackground forBarMetrics:UIBarMetricsDefault];

	//UIBarButtonItem BackButton
	UIImage *buttonBack = [[UIImage imageNamed:@"WKBarButtonItemBack"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 18, 15, 16)];
	UIImage *buttonBackSelected = [[UIImage imageNamed:@"WKBarButtonItemBackSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 18, 15, 16)];
	[[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonBack forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonBackSelected forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
	
	//UIBarButtonItem Button
	UIImage *navButton = [[UIImage imageNamed:@"WKButtonDarkGrey30px"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 5, 15, 5)];
	UIImage *navButtonSelected = [[UIImage imageNamed:@"WKButtonDarkGrey30pxSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 5, 15, 5)];
	
	[[UIBarButtonItem appearance] setBackgroundImage:navButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearance] setBackgroundImage:navButtonSelected forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
}

@end
