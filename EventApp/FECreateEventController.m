//
//  FECreateEventController.m
//  EventApp
//
//  Created by zhenglin li on 12-7-24.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FECreateEventController.h"
#import "FELoginTableViewCell.h"
#import "FEStartAndEndDateCell.h"
#import "FEActionSheet.h"
#import "NSDate+Helper.h"
#import "FEServerAPI.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "FEToolTipView.h"
#import "FEAddEventImageView.h"
#import "FECreateEventToolbar.h"

@interface FECreateEventController ()
{
    FEActionSheet* _dateSheet;
    FEToolTipView* _tooltip;
    FECreateEventToolbar* _toolbar;
    int _lastInputTag;
}

@end

@implementation FECreateEventController

static bool isFirstLaunch = YES;

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
    [_tooltip release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"新活动";
    
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotGreyBackground"]] autorelease];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground"] forBarMetrics:UIBarMetricsDefault];
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
    
    //tooltip
    _tooltip = [[[[FEToolTipView alloc] init] autorelease] retain];
    _tooltip.backgroundImage = [[UIImage imageNamed:@"tooltip_invalid"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 40, 6, 40)];
    _tooltip.edgeInsets = UIEdgeInsetsMake(14, 10, 8, 10);
	
	//toolbar
	FECreateEventToolbar *toolbar = [[[FECreateEventToolbar alloc] init] autorelease];
    toolbar.frame = isFirstLaunch ? CGRectMake(0, 220, 320, 44) : CGRectMake(0, 480, 320, 44);
    [self.navigationController.view addSubview:toolbar];
    [toolbar addTarget:self action:@selector(toolbarActionChanged:) forControlEvents:UIControlEventValueChanged];
    _toolbar = [toolbar retain];
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //NSLog(@"notification: %@, %@", notification, NSStringFromCGRect(self.tableView.frame));
    CGRect toolbarRect = _toolbar.frame;
    toolbarRect.origin.y = keyboardRect.origin.y - toolbarRect.size.height;
    
    //fix position for date input view
    UITextField *currentInput = (UITextField *)[self getFirstResponderInView:self.tableView];
    if(currentInput != nil){
        if(currentInput.tag == 2 || currentInput.tag == 3){
            toolbarRect.origin.y = toolbarRect.origin.y + 44;
        }
    }
    
    //make sure the input is visible
    float tableHeight = self.tableView.contentSize.height;
    CGRect cellRect = [currentInput convertRect:currentInput.superview.frame toView:self.tableView];
    int tableInsetTop = 0;
    if(cellRect.origin.y + cellRect.size.height + 44 > toolbarRect.origin.y){
        tableInsetTop = tableHeight - toolbarRect.origin.y;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(tableInsetTop, 0, 0, 0);
    
    double animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    _toolbar.frame = toolbarRect;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //NSLog(@"keyboardWillHide: %@", notification);
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    //NSLog(@"keyboardWillChangeFrame: %@", notification);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    if(!isFirstLaunch){
        [((FELoginTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).fieldInput becomeFirstResponder];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if(isFirstLaunch){
        [((FELoginTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).fieldInput becomeFirstResponder];
        isFirstLaunch = NO;
    }
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
    return indexPath.row == 2 ? 47 : indexPath.row == 1 ? 50 : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CreateEventTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        
        NSString *nibName = indexPath.row == 1 ? @"FEStartAndEndDateCell" : @"FELoginTableViewCell";
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
        cell = (UITableViewCell *)[nibs objectAtIndex:0];
    }
    
    NSString *cellBgName = indexPath.row == 0 ? @"roundTableCellTop" : indexPath.row == 2 ? @"roundTableCellBottom" : @"roundTableCellMiddle";
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:cellBgName]] autorelease];
    
    switch (indexPath.row) {
        case 0:
            ((FELoginTableViewCell *)cell).fieldLabel.text = @"名称";
            ((FELoginTableViewCell *)cell).fieldInput.placeholder = @"必填";
            ((FELoginTableViewCell *)cell).fieldInput.delegate = self;
            ((FELoginTableViewCell *)cell).fieldInput.returnKeyType = UIReturnKeyNext;
            ((FELoginTableViewCell *)cell).fieldInput.tag = indexPath.row+1;
            break;
            
        case 1:
            ((FEStartAndEndDateCell *)cell).startInput.delegate = self;
            ((FEStartAndEndDateCell *)cell).startInput.returnKeyType = UIReturnKeyNext;
            ((FEStartAndEndDateCell *)cell).startInput.tag = indexPath.row+1;
            ((FEStartAndEndDateCell *)cell).startInput.inputView = [self getDateAction];
            
            ((FEStartAndEndDateCell *)cell).endInput.delegate = self;
            ((FEStartAndEndDateCell *)cell).endInput.returnKeyType = UIReturnKeyNext;
            ((FEStartAndEndDateCell *)cell).endInput.tag = indexPath.row+2;
            ((FEStartAndEndDateCell *)cell).endInput.inputView = [self getDateAction];
            break;
            
        case 2:
            ((FELoginTableViewCell *)cell).fieldLabel.text = @"地点";
            ((FELoginTableViewCell *)cell).fieldInput.placeholder = @"必填";
            ((FELoginTableViewCell *)cell).fieldInput.delegate = self;
            ((FELoginTableViewCell *)cell).fieldInput.returnKeyType = UIReturnKeyGo;
            ((FELoginTableViewCell *)cell).fieldInput.tag = indexPath.row+2;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    BOOL hideToolbar = textField.tag == 2 || textField.tag == 3;
    for(int i = 1; i < _toolbar.subviews.count; i++){
        [[_toolbar.subviews objectAtIndex:i] setHidden:hideToolbar];
    }
    
    //make sure the input is visible
    float tableHeight = self.tableView.contentSize.height;
    CGRect cellRect = [textField convertRect:textField.superview.frame toView:self.tableView];
    int tableInsetTop = 0;
    if(cellRect.origin.y + cellRect.size.height + 44 > _toolbar.frame.origin.y){
        tableInsetTop = tableHeight - _toolbar.frame.origin.y;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(tableInsetTop, 0, 0, 0);
    
    _lastInputTag = textField.tag;
    [_toolbar resetAction];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag < 4){
        UITextField *nextTextField = (UITextField *)[self.tableView viewWithTag:(textField.tag+1)];
        [nextTextField becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
        [self createAction];
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 2 || textField.tag == 3){
        return NO;
    }
    
    NSString *futureString = [textField.text stringByReplacingCharactersInRange:range withString:string];    
    [self validateInput:textField.tag text:futureString showTip:NO];
    return YES;
}

- (BOOL)validateInput: (NSInteger)textFieldTag text:(NSString *)text showTip:(BOOL)showTip
{
    UITextField *textField = nil;
    NSString *contentText = nil;
    CGPoint point = CGPointZero;
    
    if(textFieldTag == 0 || textFieldTag == 1){
        textField = (UITextField *)[self.tableView viewWithTag:1];
        contentText = textFieldTag == 0 ? textField.text : text;
        if (contentText.length == 0) {
            if(showTip){
                _tooltip.backgroundView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                _tooltip.edgeInsets = UIEdgeInsetsMake(14, 10, 8, 10);
                _tooltip.text = @"请输入活动名称。";
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
        if (contentText.length == 0) {
            if(showTip){
                _tooltip.backgroundView.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
                _tooltip.edgeInsets = UIEdgeInsetsMake(14, 10, 8, 10);
                _tooltip.text = @"请输入开始时间。";
                point.x = self.tableView.frame.origin.x + 8;
                point.y = self.tableView.frame.origin.y + textField.superview.superview.frame.origin.y + textField.superview.superview.frame.size.height - 4;
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
        if (contentText.length == 0) {
            if(showTip){
                _tooltip.backgroundView.transform = CGAffineTransformMakeScale(1.0f, -1.0f);
                _tooltip.edgeInsets = UIEdgeInsetsMake(8, 10, 14, 10);
                _tooltip.text = @"请输入活动地点。";
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

- (FEActionSheet *)getDateAction
{
    if(_dateSheet == nil){
        FEActionSheet *action = [[[FEActionSheet alloc] init] autorelease];
        [action setActionSheetStyle:UIActionSheetStyleDefault];
        //action.backgroundImage = [[UIImage imageNamed:@"ToolbarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 37-30-1, 10)];
        action.frame = CGRectMake(0, 480-216-44, 320, 216+44);
        _dateSheet = [action retain];
        
        UIDatePicker *datePicker = [[[UIDatePicker alloc] init] autorelease];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        CGRect pickerRect = datePicker.bounds;
        pickerRect.origin.y = -44;
        datePicker.bounds = pickerRect;
        datePicker.tag = 1;
        //[datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [action addSubview:datePicker];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(190, 8, 55, 31);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
        //[cancelBtn setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelDateAction) forControlEvents:UIControlEventTouchUpInside];
        [action addSubview:cancelBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(190+55+10, 8, 55, 31);
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
        //[confirmBtn setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
        [confirmBtn addTarget:self action:@selector(confirmDateAction) forControlEvents:UIControlEventTouchUpInside];
        [action addSubview:confirmBtn];
    }
    return _dateSheet;
}

- (void)confirmDateAction
{
    if(_dateSheet != nil){
        UIDatePicker *datePicker = (UIDatePicker *)[_dateSheet viewWithTag:1];
        UITextField *textField = (UITextField *)[self.tableView viewWithTag:2];
        NSInteger nextTag = 3;
        if(!textField.isFirstResponder){
            textField = (UITextField *)[self.tableView viewWithTag:3];
            nextTag = 4;
        }
        textField.text = [datePicker.date stringWithFormat:@"YY-MM-dd HH:mm"];
        [self validateInput:textField.tag text:textField.text showTip:NO];
        [[self.tableView viewWithTag:nextTag] becomeFirstResponder];
    }
}

- (void)cancelDateAction
{
    if(_dateSheet != nil){
        UITextField *textField = (UITextField *)[self.tableView viewWithTag:2];
        NSInteger nextTag = 3;
        if(!textField.isFirstResponder){
            textField = (UITextField *)[self.tableView viewWithTag:3];
            nextTag = 4;
        }
        [self validateInput:textField.tag text:textField.text showTip:NO];
        [[self.tableView viewWithTag:nextTag] becomeFirstResponder];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1){
        //TODO
    }else if(indexPath.row < 1){
        [[self.tableView viewWithTag:indexPath.row+1] becomeFirstResponder]; 
    }else {
        [[self.tableView viewWithTag:indexPath.row+2] becomeFirstResponder];
    }
}

- (void)backAction
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)createAction
{
    if(![self validateInput:0 text:nil showTip:YES]){
        return;
    }
    
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] intValue];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSString *eventName = [self getTableCellTextAtRow:1];
    NSDate *startDate = [NSDate dateFromString:[self getTableCellTextAtRow:2] withFormat:@"YY-MM-dd HH:mm"];
    NSString *venue = [self getTableCellTextAtRow:3];
    
    NSString *eventURL = [NSString stringWithFormat:@"%@%@", API_BASE, API_EVENT_CREATE];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:eventURL]];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[NSNumber numberWithInt:user_id] forKey:@"user_id"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:eventName forKey:@"event_name"];
    [request setPostValue:[startDate stringWithFormat:@"YY-MM-dd HH:mm"] forKey:@"start_date"];
    [request setPostValue:[startDate stringWithFormat:@"YY-MM-dd HH:mm"] forKey:@"end_date"];
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

- (void)toolbarActionChanged:(FECreateEventToolbar *)sender
{
    NSLog(@"action: %d", sender.action);
    
    if(sender.action == CreateEventIconAction){
        [[self getFirstResponderInView:self.view] resignFirstResponder];
        FEAddEventImageView *addImageView = [[[FEAddEventImageView alloc] init] autorelease];
        addImageView.frame = CGRectMake(0, 264, 320, 216);
        [self.navigationController.view addSubview:addImageView];
    }else if (sender.action == 0) {
        int inputTag = _lastInputTag > 0 ? _lastInputTag : 1;
        [[self.tableView viewWithTag:inputTag] becomeFirstResponder];
    }
}

@end
