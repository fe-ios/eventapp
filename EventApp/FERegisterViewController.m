//
//  FERegisterViewController.m
//  EventApp
//
//  Created by zhenglin li on 12-7-13.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FERegisterViewController.h"
#import "FELoginTableViewCell.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "FEActionSheet.h"
#import "MD5+Helper.h"
#import "FEServerAPI.h"
#import "FEToolTipView.h"

@interface FERegisterViewController ()
{
    MBProgressHUD* _progress;
    FEToolTipView* _tooltip;
}

@end

@implementation FERegisterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_tooltip release];
    [super dealloc]; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"注册";
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
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"btn_title_bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 6, 15, 6)] forState:UIControlStateNormal];
    //[leftButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftButton] autorelease];
    
    //right button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 55, 31);
    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"btn_title_bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 6, 15, 6)] forState:UIControlStateNormal];
    //[rightButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightButton] autorelease];
    
    _tooltip = [[[[FEToolTipView alloc] init] autorelease] retain];
    _tooltip.backgroundImage = [[UIImage imageNamed:@"tooltip_invalid"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 40, 6, 40)];
    _tooltip.edgeInsets = UIEdgeInsetsMake(14, 10, 8, 10);
}

- (void)viewDidUnload
{
    _progress = nil;
    [super viewDidUnload];
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
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 || indexPath.row == 3 ? 47 : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LoginTableViewCell";
    FELoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FELoginTableViewCell" owner:nil options:nil];
        cell = (FELoginTableViewCell *)[nibs objectAtIndex:0];
    }
    
    NSString *cellBgName = indexPath.row == 0 ? @"roundTableCellTop" : indexPath.row == 3 ? @"roundTableCellBottom" : @"roundTableCellMiddle";
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:cellBgName] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 33, 20)]] autorelease];
    
    switch (indexPath.row) {
        case 0:
            cell.fieldLabel.text = @"用户名";
            cell.fieldInput.placeholder = @"必填";
            cell.fieldInput.delegate = self;
            cell.fieldInput.returnKeyType = UIReturnKeyNext;
            cell.fieldInput.tag = indexPath.row+1;
            break;
            
        case 1:
            cell.fieldLabel.text = @"邮箱";
            cell.fieldInput.placeholder = @"必填";
            cell.fieldInput.delegate = self;
            cell.fieldInput.keyboardType = UIKeyboardTypeEmailAddress;
            cell.fieldInput.returnKeyType = UIReturnKeyNext;
            cell.fieldInput.tag = indexPath.row+1;
            break;
            
        case 2:
            cell.fieldLabel.text = @"密码";
            cell.fieldInput.placeholder = @"必填";
            cell.fieldInput.delegate = self;
            cell.fieldInput.returnKeyType = UIReturnKeyNext;
            cell.fieldInput.secureTextEntry = YES;
            cell.fieldInput.tag = indexPath.row+1;
            break;
            
        case 3:
            cell.fieldLabel.text = @"重复密码";
            cell.fieldInput.placeholder = @"必填";
            cell.fieldInput.delegate = self;
            cell.fieldInput.returnKeyType = UIReturnKeyGo;
            cell.fieldInput.secureTextEntry = YES;
            cell.fieldInput.tag = indexPath.row+1;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self.tableView viewWithTag:indexPath.row+1] becomeFirstResponder]; 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag < 4){
        UIResponder *nextResponder = [self.tableView viewWithTag:(textField.tag+1)];
        [nextResponder becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
        [self registerAction];
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *futureString = [textField.text stringByReplacingCharactersInRange:range withString:string];    
    [self validateInput:textField.tag text:futureString showTip:NO];
    return YES;
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

- (BOOL)validateInput: (NSInteger)textFieldTag text:(NSString *)text showTip:(BOOL)showTip
{
    NSError *error = NULL;
    NSRegularExpression *regex = nil;
    NSUInteger numberOfMatches = 0;
    UITextField *textField = nil;
    NSString *contentText = nil;
    CGPoint point = CGPointZero;
    
    if(textFieldTag == 0 || textFieldTag == 1){
        textField = (UITextField *)[self.tableView viewWithTag:1];
        contentText = textFieldTag == 0 ? textField.text : text;
        regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z][a-zA-Z0-9\\-]{3,9}$" options:NSRegularExpressionCaseInsensitive error:&error];
        numberOfMatches = [regex numberOfMatchesInString:contentText options:0 range:NSMakeRange(0, contentText.length)];
        if (numberOfMatches != 1) {
            if(showTip){
                _tooltip.backgroundView.transform = CGAffineTransformIdentity;
                _tooltip.edgeInsets = UIEdgeInsetsMake(14, 10, 8, 10);
                _tooltip.text = @"用户名的有效长度为4到10个字符，且不能以数字开头。";
                point.x = self.tableView.frame.size.width - _tooltip.frame.size.width - 8;
                point.y = self.tableView.frame.origin.y + textField.superview.superview.frame.origin.y + textField.superview.superview.frame.size.height - 10;
                [_tooltip showAtPoint:point inView:self.tableView];
                [textField becomeFirstResponder]; 
            }
            return NO;
        }else {
            [_tooltip removeFromSuperview];
        }
    }
    
    if(textFieldTag == 0 || textFieldTag == 2){
        textField = (UITextField *)[self.tableView viewWithTag:2];
        contentText = textFieldTag == 0 ? textField.text : text;
        regex = [NSRegularExpression regularExpressionWithPattern:@"^[+\\w\\.\\-']+@[a-zA-Z0-9-]+(\\.[a-zA-Z]{2,})+$" options:NSRegularExpressionCaseInsensitive error:&error];
        numberOfMatches = [regex numberOfMatchesInString:contentText options:0 range:NSMakeRange(0, contentText.length)];
        if(numberOfMatches != 1){
            if(showTip){
                _tooltip.backgroundView.transform = CGAffineTransformIdentity;
                _tooltip.edgeInsets = UIEdgeInsetsMake(14, 10, 8, 10);
                _tooltip.text = @"请输入合法的邮箱地址。";
                point.x = self.tableView.frame.size.width - _tooltip.frame.size.width - 8;
                point.y = self.tableView.frame.origin.y + textField.superview.superview.frame.origin.y + textField.superview.superview.frame.size.height - 10;
                [_tooltip showAtPoint:point inView:self.tableView];
                [textField becomeFirstResponder];
            }
            return  NO;
        }else {
            [_tooltip removeFromSuperview];
        }
    }
    
    if(textFieldTag == 0 || textFieldTag == 3){
        textField = (UITextField *)[self.tableView viewWithTag:3];
        contentText = textFieldTag == 0 ? textField.text : text;
        if (contentText.length < 6 || contentText.length > 20) {
            if(showTip){
                _tooltip.backgroundView.transform = CGAffineTransformIdentity;
                _tooltip.edgeInsets = UIEdgeInsetsMake(14, 10, 8, 10);
                _tooltip.text = @"密码的有效长度为6到20个字符。";
                point.x = self.tableView.frame.size.width - _tooltip.frame.size.width - 8;
                point.y = self.tableView.frame.origin.y + textField.superview.superview.frame.origin.y + textField.superview.superview.frame.size.height - 10;
                [_tooltip showAtPoint:point inView:self.tableView];
                [textField becomeFirstResponder];
            }
            return NO;
        }else {
            [_tooltip removeFromSuperview];
        }
    }
    
    if(textFieldTag == 0 || textFieldTag == 4){
        textField = (UITextField *)[self.tableView viewWithTag:4];
        contentText = textFieldTag == 0 ? textField.text : text;
        if(![contentText isEqualToString:[self getTableCellTextAtRow:2]]){
            if(showTip){
                _tooltip.backgroundView.transform = CGAffineTransformMakeScale(1.0f, -1.0f);
                _tooltip.edgeInsets = UIEdgeInsetsMake(8, 10, 14, 10);
                _tooltip.text = @"两次输入的密码不一致。";
                point.x = self.tableView.frame.size.width - _tooltip.frame.size.width - 8;
                point.y = self.tableView.frame.origin.y + textField.superview.superview.frame.origin.y - _tooltip.frame.size.height + 10;
                [_tooltip showAtPoint:point inView:self.tableView];
                [textField becomeFirstResponder];
            }
            return NO;
        }else {
            [_tooltip removeFromSuperview];
        }
    }
    
    return YES;
}

- (void)registerAction
{
    if(![self validateInput:0 text:nil showTip:YES]){
        return;
    }
    
    _progress = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.dimBackground = YES;
    _progress.labelText = @"注册中...";
    
    NSString *registerURL = [NSString stringWithFormat:@"%@%@", API_BASE, API_REGISTER];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:registerURL]];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[self getTableCellTextAtRow:0] forKey:@"username"];
    [request setPostValue:[self getTableCellTextAtRow:1] forKey:@"email"];
    [request setPostValue:[[self getTableCellTextAtRow:2] md5] forKey:@"password"];
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
        [self showFailedAction:[result objectForKey:@"msg"]];
    }else if([status isEqualToString:@"success"]){
        //save user info
        int userid = [[[result objectForKey:@"user"] objectForKey:@"userid"] intValue];
        NSString *username = [[result objectForKey:@"user"] objectForKey:@"username"];
        NSString *password = [[result objectForKey:@"user"] objectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setInteger:userid forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"email"];
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
    [self showFailedAction:@"注册失败，请重试。"];
}

- (void) showFailedAction:(NSString *)title
{
    FEActionSheet *action = [[[FEActionSheet alloc] init] autorelease];
    action.title = title;
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
