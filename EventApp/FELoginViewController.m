//
//  FELoginViewController.m
//  EventApp
//
//  Created by zhenglin li on 12-7-13.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FELoginViewController.h"
#import "FELoginTableViewCell.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "FEActionSheet.h"
#import "AppDelegate.h"
#import "MD5+Helper.h"
#import "FEServerAPI.h"


@interface FELoginViewController ()
{
    MBProgressHUD* _progress;
}

@end

@implementation FELoginViewController


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
    
    self.title = @"登录";
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotGreyBackground"]] autorelease];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground"] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)] autorelease];
    self.tableView.tableHeaderView = headerView;
    
    //left button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 55, 31);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
    //[leftButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftButton] autorelease];
    
    //right button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 55, 31);
    [rightButton setTitle:@"登录" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
    //[rightButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightButton] autorelease];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _progress = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 || indexPath.row == 1 ? 47 : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LoginTableViewCell";
    FELoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FELoginTableViewCell" owner:nil options:nil];
        cell = (FELoginTableViewCell *)[nibs objectAtIndex:0];
    }
    
    NSString *cellBgName = indexPath.row == 0 ? @"roundTableCellTop" : indexPath.row == 1 ? @"roundTableCellBottom" : @"roundTableCellMiddle";
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:cellBgName]] autorelease];
    
    switch (indexPath.row) {
        case 0:
            cell.fieldLabel.text = @"用户名";
            cell.fieldInput.placeholder = @"必填";
            cell.fieldInput.delegate = self;
            cell.fieldInput.returnKeyType = UIReturnKeyNext;
            cell.fieldInput.tag = 0;
            break;
            
        case 1:
            cell.fieldLabel.text = @"密码";
            cell.fieldInput.placeholder = @"必填";
            cell.fieldInput.delegate = self;
            cell.fieldInput.returnKeyType = UIReturnKeyGo;
            cell.fieldInput.secureTextEntry = YES;
            cell.fieldInput.tag = 1;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag < 1){
        UIResponder *nextResponder = [self.tableView viewWithTag:(textField.tag+1)];
        [nextResponder becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
        [self loginAction];
    }
    return NO;
}

- (void)backAction
{
    [self.tableView endEditing:YES];
    [self.navigationController popViewControllerAnimated:NO];
    
    [self.view.window exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [[self.view.window.subviews objectAtIndex:0] setHidden:YES];
    [[self.view.window.subviews objectAtIndex:1] setHidden:NO];
    
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:@"pushAnimaition"];
}

- (void)loginAction
{
    _progress = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.dimBackground = YES;
    _progress.labelText = @"登录中...";
    
    NSString *loginURL = [NSString stringWithFormat:@"%@%@", API_BASE, API_LOGIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:loginURL]];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[self getTableCellTextAtRow:0] forKey:@"username"];
    [request setPostValue:[[self getTableCellTextAtRow:1] md5] forKey:@"password"];
    request.delegate = self;
    [request startAsynchronous];
    [request release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%d, %@", request.responseStatusCode, request.responseString);
    if(_progress){
        [_progress removeFromSuperview];
        _progress = nil;
    }
    
    NSDictionary *result = [request.responseString objectFromJSONString];
    NSString *status = [result objectForKey:@"status"];

    if([status isEqualToString:@"error"]){
        [self showFailedAction];
    }else if([status isEqualToString:@"success"]){
        //save user info
        int userid = [[[result objectForKey:@"user"] objectForKey:@"userid"] intValue];
        NSString *username = [[result objectForKey:@"user"] objectForKey:@"username"];
        NSString *password = [[result objectForKey:@"user"] objectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setInteger:userid forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        [appDelegate startMainView];
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@ failed.", request.url);
    if(_progress){
        [_progress removeFromSuperview];
        _progress = nil;
    }
    [self showFailedAction];
}

- (void) showFailedAction
{
    FEActionSheet *action = [[FEActionSheet alloc] init];
    action.title = @"登录失败，请重试。";
    int buttonIndex = [action addButtonWithTitle:@"取消"];
    [action setActionSheetStyle:UIActionSheetStyleDefault];
    action.backgroundImage = [[UIImage imageNamed:@"ToolbarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 37-30-1, 10)];
    [action showInView:self.view.window];
    
    UIButton *button = [action buttonAtIndex:buttonIndex];
    [button setBackgroundImage:[UIImage imageNamed:@"ActionSheetButtonBackgroundCancel"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ActionSheetButtonBackgroundCancelSelected"] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
}

-(NSString *)getTableCellTextAtRow: (int)row
{
    return ((FELoginTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]]).fieldInput.text;
}

-(void)setTableCellTextAtRow: (NSString *)text row:(int)row 
{
    ((FELoginTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]]).fieldInput.text = text;
}

-(void)focusFirstTextInput
{
    [((FELoginTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).fieldInput becomeFirstResponder];
}

@end
