//
//  FECreateEventController.m
//  EventApp
//
//  Created by zhenglin li on 12-7-24.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FECreateEventController.h"
#import "FELoginTableViewCell.h"
#import "FEActionSheet.h"
#import "NSDate+Helper.h"
#import "FEServerAPI.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@interface FECreateEventController ()
{
    FEActionSheet* _dateSheet;
}

@end

@implementation FECreateEventController

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
    [_dateSheet release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"新活动";
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotGreyBackground"]] autorelease];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground"] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)] autorelease];
    self.tableView.tableHeaderView = headerView;
    
    //left button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 50, 31);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
    //[leftButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftButton] autorelease];
    
    //right button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 50, 31);
    [rightButton setTitle:@"创建" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
    //[rightButton setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(createAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightButton] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [((FELoginTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).fieldInput becomeFirstResponder];
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 2 ? 47 : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LoginTableViewCell";
    FELoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FELoginTableViewCell" owner:nil options:nil];
        cell = (FELoginTableViewCell *)[nibs objectAtIndex:0];
    }
    
    NSString *cellBgName = indexPath.row == 0 ? @"roundTableCellTop" : indexPath.row == 2 ? @"roundTableCellBottom" : @"roundTableCellMiddle";
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:cellBgName]] autorelease];
    
    switch (indexPath.row) {
        case 0:
            cell.fieldLabel.text = @"名称";
            cell.fieldInput.placeholder = @"必填";
            cell.fieldInput.delegate = self;
            cell.fieldInput.returnKeyType = UIReturnKeyNext;
            cell.fieldInput.tag = 0;
            break;
            
        case 1:
            cell.fieldLabel.text = @"时间";
            cell.fieldInput.placeholder = @"必填";
            cell.fieldInput.delegate = self;
            cell.fieldInput.returnKeyType = UIReturnKeyNext;
            cell.fieldInput.tag = 1;
            //[cell.fieldInput addTarget:self action:@selector(getDateAction) forControlEvents:UIControlEventEditingDidBegin];
            cell.fieldInput.inputView = [self getDateAction];
            break;
            
        case 2:
            cell.fieldLabel.text = @"地点";
            cell.fieldInput.placeholder = @"必填";
            cell.fieldInput.delegate = self;
            cell.fieldInput.returnKeyType = UIReturnKeyGo;
            cell.fieldInput.tag = 2;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag < 2){
        UIResponder *nextResponder = [self.tableView viewWithTag:(textField.tag+1)];
        if(((UITextField *)nextResponder).tag == 1){
            [nextResponder becomeFirstResponder];
        }else {
            [nextResponder becomeFirstResponder];
        }
    }else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (FEActionSheet *)getDateAction
{
    if(_dateSheet == nil){
        FEActionSheet *action = [[[FEActionSheet alloc] init] autorelease];
        [action setActionSheetStyle:UIActionSheetStyleDefault];
        action.backgroundImage = [[UIImage imageNamed:@"ToolbarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 37-30-1, 10)];
        action.frame = CGRectMake(0, 480-216-44, 320, 216+44);
        _dateSheet = [action retain];
        
        UIDatePicker *datePicker = [[[UIDatePicker alloc] init] autorelease];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        CGRect pickerRect = datePicker.bounds;
        pickerRect.origin.y = -44;
        datePicker.bounds = pickerRect;
        datePicker.tag = 1;
        [action addSubview:datePicker];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(190, 8, 55, 31);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [cancelBtn setBackgroundImage:[[UIImage imageNamed:@"ButtonDarkGrey30px"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[[UIImage imageNamed:@"ButtonDarkGrey30pxSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelDateAction) forControlEvents:UIControlEventTouchUpInside];
        [action addSubview:cancelBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(190+55+10, 8, 55, 31);
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"ButtonDarkGrey30px"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
        [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"ButtonDarkGrey30pxSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
        [confirmBtn addTarget:self action:@selector(confirmDateAction) forControlEvents:UIControlEventTouchUpInside];
        [action addSubview:confirmBtn];
    }
    return _dateSheet;
}

- (void)confirmDateAction
{
    if(_dateSheet != nil){
        UIDatePicker *datePicker = (UIDatePicker *)[_dateSheet viewWithTag:1];
        UITextField *textField = (UITextField *)[self.tableView viewWithTag:1];
        textField.text = [datePicker.date stringWithFormat:@"YY-MM-dd HH:mm"];
        [(UITextField *)[self.tableView viewWithTag:2] becomeFirstResponder];
    }
}

- (void)cancelDateAction
{
    if(_dateSheet != nil){
        //[_dateSheet dismissWithClickedButtonIndex:0 animated:YES];
        [(UITextField *)[self.tableView viewWithTag:1] resignFirstResponder];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //nothing
}

- (void)backAction
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)createAction
{
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] intValue];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSString *eventName = [self getTableCellTextAtRow:0];
    NSDate *startDate = [NSDate dateFromString:[self getTableCellTextAtRow:1] withFormat:@"YY-MM-dd HH:mm"];
    NSString *venue = [self getTableCellTextAtRow:2];
    
    NSString *eventURL = [NSString stringWithFormat:@"%@%@", API_BASE, API_EVENT_CREATE];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:eventURL]];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[NSNumber numberWithInt:user_id] forKey:@"user_id"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:eventName forKey:@"event_name"];
    [request setPostValue:[startDate stringWithFormat:@"YY-MM-dd HH:mm"] forKey:@"start_date"];
    [request setPostValue:venue forKey:@"venue"];
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

-(NSString *) getTableCellTextAtRow: (int)row
{
    return ((FELoginTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]]).fieldInput.text;
}

-(void) setTableCellTextAtRow: (NSString *)text row:(int)row 
{
    ((FELoginTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]]).fieldInput.text = text;
}

@end
