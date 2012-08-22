//
//  FECreateEventController.m
//  EventApp
//
//  Created by zhenglin li on 12-7-24.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>
#import "FECreateEventController.h"
#import "FELoginTableViewCell.h"
#import "FEStartAndEndDateCell.h"
#import "FEActionSheet.h"
#import "NSDate+Helper.h"
#import "FEServerAPI.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "FEToolTipView.h"
#import "FEAddEventIconView.h"
#import "FECreateEventToolbar.h"
#import "FEAddEventTagView.h"
#import "FEAddEventView.h"
 

@interface FECreateEventController ()

@property(nonatomic, retain) UITableView *currentView;
@property(nonatomic, retain) FEAddEventView *defaultView;
@property(nonatomic, retain) FECreateEventToolbar *toolbar;
@property(nonatomic, retain) UITableView *addTagView;
@property(nonatomic, retain) FEAddEventIconView *addIconView;

@end

@implementation FECreateEventController

@synthesize currentView, defaultView, toolbar;
@synthesize addTagView, addIconView;


static bool isFirstLaunch = YES;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [currentView release];
    [defaultView release];
    [toolbar release];
    [addTagView release];
    [addIconView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新活动";
    
    UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotGreyBackground"]] autorelease];
    bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    bgView.contentMode = UIViewContentModeTopLeft;
    [self.view addSubview:bgView];
    
	//toolbar
	self.toolbar = [[[FECreateEventToolbar alloc] init] autorelease];
    self.toolbar.frame = isFirstLaunch ? CGRectMake(0, 220-64, 320, 44) : CGRectMake(0, 480-64, 320, 44);
    [self.view addSubview:self.toolbar];
    [self.toolbar addTarget:self action:@selector(toolbarActionChanged:) forControlEvents:UIControlEventValueChanged];
    
    //default view
    FEAddEventView *addEventView = [[[FEAddEventView alloc] init] autorelease];
    addEventView.frame = CGRectMake(0, 0, 320, 156);
    addEventView.clipsToBounds = YES;
    addEventView.toolbar = self.toolbar;
    [self.view insertSubview:addEventView belowSubview:self.toolbar];
    self.currentView = addEventView;
    self.defaultView = addEventView;
	
    //left button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 50, 31);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftButton] autorelease];
    
    //right button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 50, 31);
    [rightButton setTitle:@"创建" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(createAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightButton] autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect toolbarRect = self.toolbar.frame;
    toolbarRect.origin.y = keyboardRect.origin.y - toolbarRect.size.height - 64;
    
    //fix position for date input view
    UITextField *currentInput = (UITextField *)[self getFirstResponderInView:self.currentView];
    if(currentInput != nil){
        if(currentInput.tag == 2 || currentInput.tag == 3){
            toolbarRect.origin.y = toolbarRect.origin.y + 44;
        }
        
        //make sure the input is visible
        float tableHeight = self.currentView.contentSize.height;
        CGRect cellRect = currentInput.superview.superview.frame;
        int tableInsetTop = 0;
        if(cellRect.origin.y + cellRect.size.height > toolbarRect.origin.y){
            tableInsetTop = - tableHeight + toolbarRect.origin.y - 5;
        }
        self.currentView.contentInset = UIEdgeInsetsMake(tableInsetTop, 0, 0, 0);
    }
    
    double animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.toolbar.frame = toolbarRect;
    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    self.currentView = nil;
    self.defaultView = nil;
    self.toolbar = nil;
    self.addTagView = nil;
    self.addIconView = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    if(!isFirstLaunch){
        if([self.currentView respondsToSelector:@selector(setAutoFocusFirstInput:)]){
            [self.currentView performSelector:@selector(setAutoFocusFirstInput:) withObject:(id)YES];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if(isFirstLaunch){
        if([self.currentView respondsToSelector:@selector(recoverLastInputAsFirstResponder)]){
            [self.currentView performSelector:@selector(recoverLastInputAsFirstResponder)];
        }
        isFirstLaunch = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)backAction
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)createAction
{
    if([self.currentView respondsToSelector:@selector(validateInput:text:showTip:)]){
        objc_msgSend(self.currentView, @selector(validateInput:text:showTip:), 0, nil, YES);
    }
    
    return;
    
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] intValue];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSMutableDictionary *eventData = [self.defaultView getInputData];
    NSString *eventURL = [NSString stringWithFormat:@"%@%@", API_BASE, API_EVENT_CREATE];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:eventURL]];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[NSNumber numberWithInt:user_id] forKey:@"user_id"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:[eventData objectForKey:@"event_name"]forKey:@"event_name"];
    [request setPostValue:[eventData objectForKey:@"start_date"] forKey:@"start_date"];
    [request setPostValue:[eventData objectForKey:@"end_date"] forKey:@"end_date"];
    [request setPostValue:[eventData objectForKey:@"venue"] forKey:@"venue"];
    request.delegate = self;
    [request startAsynchronous];
    [request release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%d, %@", request.responseStatusCode, request.responseString);
    
    NSDictionary *result = [request.responseString objectFromJSONString];
    NSString *status = [result objectForKey:@"status"];
    
    if([status isEqualToString:@"success"]){
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)toolbarActionChanged:(FECreateEventToolbar *)sender
{
    NSLog(@"action: %d, %d", sender.action, sender.privacy);
    
    switch (sender.action) {
        case CreateEventNoneAction:
            if([self.defaultView respondsToSelector:@selector(recoverLastInputAsFirstResponder)]){
                [self.defaultView performSelector:@selector(recoverLastInputAsFirstResponder)];
            }
            
            if(self.currentView != self.defaultView){
                [self transitionView:self.currentView toView:self.defaultView fromRight:NO];
            }
            break;
            
        case CreateEventIconAction:
            [[self getFirstResponderInView:self.view] resignFirstResponder];
            
            if(!self.addIconView){
                self.addIconView = [[[FEAddEventIconView alloc] init] autorelease];
                self.addIconView.frame = CGRectMake(0, 264, 320, 216);
                self.addIconView.delegate = self;
            }
            [self.navigationController.view addSubview:self.addIconView];
            break;
            
        case CreateEventTagAction:
            [[self getFirstResponderInView:self.view] resignFirstResponder];
            
            if(!self.addTagView){
                self.addTagView = [[[FEAddEventTagView alloc] init] autorelease];
                self.addTagView.frame = CGRectMake(320, 20+44, 320, 156);
                self.addTagView.clipsToBounds = YES;
            }
            
            if(self.currentView != self.addTagView){
                [self transitionView:self.currentView toView:self.addTagView fromRight:YES];
            }
            
            if([self.addTagView respondsToSelector:@selector(recoverLastInputAsFirstResponder)]){
                [self.addTagView performSelector:@selector(recoverLastInputAsFirstResponder)];
            }
            break;
            
        default:
            break;
    }
}

- (void)transitionView:(UITableView *)fromView toView:(UITableView *)toView fromRight:(BOOL)fromRight
{
    CGFloat startX = fromRight ? 320 : -320;
    CGFloat endX = fromRight ? -320 : 320;
    [self.view.window addSubview:toView];
    toView.frame = CGRectMake(startX, 20+44, toView.frame.size.width, toView.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        fromView.frame = CGRectMake(endX, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
        toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
    } completion:^(BOOL finished){
        self.currentView = toView;
        [self.view insertSubview:toView belowSubview:self.toolbar];
        toView.frame = CGRectMake(0, 0, toView.frame.size.width, toView.frame.size.height);    }];
}

-(UIView *)getFirstResponderInView:(UIView *)view
{
    if([view isFirstResponder]){
        return view;
    }
    
    for (int i = 0; i < view.subviews.count; i++) {
        UIView *child = [view.subviews objectAtIndex:i];
        UIView *result = [self getFirstResponderInView:child];
        if(result){
            return result;
        }
    }
    return nil;
}

#pragma mark - image picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"get image: %@", image);
        [picker dismissModalViewControllerAnimated:YES];
    }
}

@end
