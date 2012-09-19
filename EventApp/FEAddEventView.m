//
//  FEAddEventView.m
//  EventApp
//
//  Created by zhenglin li on 12-8-17.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEAddEventView.h"
#import "FELoginTableViewCell.h"
#import "FEStartAndEndDateCell.h"
#import "FEActionSheet.h"
#import "FEToolTipView.h"
#import "NSDate+Helper.h"


@interface FEAddEventView()
{
    
}

@property(nonatomic, retain) FEActionSheet *dateSheet;
@property(nonatomic, retain) FEToolTipView *tooltip;
@property(nonatomic, assign) int lastInputTag;
@property(nonatomic, assign) BOOL nameValid;
@property(nonatomic, assign) BOOL startDateValid;
@property(nonatomic, assign) BOOL venueValid;
@property(nonatomic, assign) BOOL cityValid;

@property(nonatomic, retain) NSString *eventName;
@property(nonatomic, retain) NSString *eventCity;
@property(nonatomic, retain) NSString *eventVenue;
@property(nonatomic, retain) NSString *eventStartDateStr;
@property(nonatomic, retain) NSString *eventEndDateStr;

@end

@implementation FEAddEventView

@synthesize toolbar, autoFocusFirstInput, basicDelegate;
@synthesize dateSheet, tooltip, lastInputTag;
@synthesize nameValid, startDateValid, venueValid, cityValid;
@synthesize eventName, eventCity, eventVenue, eventStartDateStr, eventEndDateStr;
@synthesize changed = _changed;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithEvent:(FEEvent *)event
{
    self = [super init];
    if(self){
        self.eventName = event.name;
        self.eventStartDateStr = [event.start_date stringWithFormat:@"YY-MM-dd HH:mm"];
        self.eventEndDateStr = [event.end_date stringWithFormat:@"YY-MM-dd HH:mm"];
        self.eventCity = event.city;
        self.eventVenue = event.venue;
        self.nameValid = self.startDateValid = self.venueValid = self.cityValid = YES;
    }
    return self;
}

- (void)dealloc
{
    [toolbar release];
    [dateSheet release];
    [tooltip release];
    [eventName release];
    [eventCity release];
    [eventVenue release];
    [eventStartDateStr release];
    [eventEndDateStr release];
    [super dealloc];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
	self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)] autorelease];
    self.delegate = self;
    self.dataSource = self;
    
    self.tooltip = [[[FEToolTipView alloc] init] autorelease];
    self.tooltip.backgroundImage = [[UIImage imageNamed:@"tooltip_invalid"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 40, 6, 40)];
    self.tooltip.edgeInsets = UIEdgeInsetsMake(14, 10, 8, 10);
    
    self.lastInputTag = 1;
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
    return indexPath.row == 3 ? 47 : indexPath.row == 1 ? 50 : 44;
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
    
    NSString *cellBgName = indexPath.row == 0 ? @"roundTableCellTop" : indexPath.row == 3 ? @"roundTableCellBottom" : @"roundTableCellMiddle";
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:cellBgName]] autorelease];
    
    switch (indexPath.row) {
        case 0:
            ((FELoginTableViewCell *)cell).fieldLabel.text = @"名称";
            ((FELoginTableViewCell *)cell).fieldInput.text = self.eventName;
            ((FELoginTableViewCell *)cell).fieldInput.placeholder = @"必填";
            ((FELoginTableViewCell *)cell).fieldInput.delegate = self;
            ((FELoginTableViewCell *)cell).fieldInput.returnKeyType = UIReturnKeyNext;
            ((FELoginTableViewCell *)cell).fieldInput.tag = indexPath.row+1;
            //if(self.autoFocusFirstInput) [((FELoginTableViewCell *)cell).fieldInput becomeFirstResponder];
            break;
            
        case 1:
            ((FEStartAndEndDateCell *)cell).startInput.delegate = self;
            ((FEStartAndEndDateCell *)cell).startInput.text = self.eventStartDateStr;
            ((FEStartAndEndDateCell *)cell).startInput.returnKeyType = UIReturnKeyNext;
            ((FEStartAndEndDateCell *)cell).startInput.tag = indexPath.row+1;
            ((FEStartAndEndDateCell *)cell).startInput.inputView = [self getDateAction];
            
            ((FEStartAndEndDateCell *)cell).endInput.delegate = self;
            ((FEStartAndEndDateCell *)cell).endInput.text = self.eventEndDateStr;
            ((FEStartAndEndDateCell *)cell).endInput.returnKeyType = UIReturnKeyNext;
            ((FEStartAndEndDateCell *)cell).endInput.tag = indexPath.row+2;
            ((FEStartAndEndDateCell *)cell).endInput.inputView = [self getDateAction];
            break;
            
        case 2:
            ((FELoginTableViewCell *)cell).fieldLabel.text = @"城市";
            ((FELoginTableViewCell *)cell).fieldInput.text = self.eventCity;
            ((FELoginTableViewCell *)cell).fieldInput.placeholder = @"必填";
            ((FELoginTableViewCell *)cell).fieldInput.delegate = self;
            ((FELoginTableViewCell *)cell).fieldInput.returnKeyType = UIReturnKeyNext;
            ((FELoginTableViewCell *)cell).fieldInput.tag = indexPath.row+2;
            break;
            
        case 3:
            ((FELoginTableViewCell *)cell).fieldLabel.text = @"地点";
            ((FELoginTableViewCell *)cell).fieldInput.text = self.eventVenue;
            ((FELoginTableViewCell *)cell).fieldInput.placeholder = @"必填";
            ((FELoginTableViewCell *)cell).fieldInput.delegate = self;
            ((FELoginTableViewCell *)cell).fieldInput.returnKeyType = UIReturnKeyDone;
            ((FELoginTableViewCell *)cell).fieldInput.tag = indexPath.row+2;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1){
        //TODO
    }else if(indexPath.row < 1){
        [[self viewWithTag:indexPath.row+1] becomeFirstResponder]; 
    }else {
        [[self viewWithTag:indexPath.row+2] becomeFirstResponder];
    }
}

#pragma mark - Date actionsheet

- (FEActionSheet *)getDateAction
{
    if(self.dateSheet == nil){
        self.dateSheet = [[[FEActionSheet alloc] init] autorelease];
        [self.dateSheet setActionSheetStyle:UIActionSheetStyleDefault];
        //self.dateSheet.backgroundImage = [[UIImage imageNamed:@"ToolbarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 37-30-1, 10)];
        self.dateSheet.frame = CGRectMake(0, 480-216-44, 320, 216+44);
        
        UIDatePicker *datePicker = [[[UIDatePicker alloc] init] autorelease];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        CGRect pickerRect = datePicker.bounds;
        pickerRect.origin.y = -44;
        datePicker.bounds = pickerRect;
        datePicker.tag = 1;
        //[datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [self.dateSheet addSubview:datePicker];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(190, 8, 55, 31);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
        //[cancelBtn setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelDateAction) forControlEvents:UIControlEventTouchUpInside];
        [self.dateSheet addSubview:cancelBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(190+55+10, 8, 55, 31);
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateNormal];
        //[confirmBtn setBackgroundImage:[[UIImage imageNamed:@"navButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forState:UIControlStateHighlighted];
        [confirmBtn addTarget:self action:@selector(confirmDateAction) forControlEvents:UIControlEventTouchUpInside];
        [self.dateSheet addSubview:confirmBtn];
    }
    return self.dateSheet;
}

- (void)confirmDateAction
{
    if(self.dateSheet != nil){
        UIDatePicker *datePicker = (UIDatePicker *)[self.dateSheet viewWithTag:1];
        UITextField *textField = (UITextField *)[self viewWithTag:2];
        NSInteger nextTag = 3;
        if(!textField.isFirstResponder){
            textField = (UITextField *)[self viewWithTag:3];
            nextTag = 4;
        }
        textField.text = [datePicker.date stringWithFormat:@"YY-MM-dd HH:mm"];
        if(nextTag == 3){
            self.eventStartDateStr = textField.text;
            _changed = YES;
        }else {
            self.eventEndDateStr = textField.text;
            _changed = YES;
        }
        [self validateInput:textField.tag text:textField.text showTip:NO];
        BOOL completed = self.nameValid && self.startDateValid && self.venueValid;
        NSMutableDictionary *data = completed ? [self getInputData] : nil;
        [self.basicDelegate handleBasicDataDidChange:data completed:completed];
        [[self viewWithTag:nextTag] becomeFirstResponder];
    }
}

- (void)cancelDateAction
{
    if(self.dateSheet != nil){
        UITextField *textField = (UITextField *)[self viewWithTag:2];
        NSInteger nextTag = 3;
        if(!textField.isFirstResponder){
            textField = (UITextField *)[self viewWithTag:3];
            nextTag = 4;
        }
        [self validateInput:textField.tag text:textField.text showTip:NO];
        BOOL completed = self.nameValid && self.startDateValid && self.venueValid;
        NSMutableDictionary *data = completed ? [self getInputData] : nil;
        [self.basicDelegate handleBasicDataDidChange:data completed:completed];
        [[self viewWithTag:nextTag] becomeFirstResponder];
    }
}

#pragma mark - Textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //hide all actions when date picker popups
    BOOL hideToolbar = textField.tag == 2 || textField.tag == 3;
    [self.toolbar showOrHideActions:hideToolbar];
    
    //make sure the input is visible
    float tableHeight = self.contentSize.height;
    CGRect cellRect = textField.superview.superview.frame;
    int tableInsetTop = 0;
    if(cellRect.origin.y + cellRect.size.height > self.toolbar.frame.origin.y){
        tableInsetTop = - tableHeight + self.toolbar.frame.origin.y - 5;
    }else {
        self.contentOffset = CGPointZero;
    }
    self.contentInset = UIEdgeInsetsMake(tableInsetTop, 0, 0, 0);
    
    //record last input tag
    self.lastInputTag = textField.tag;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag < 5){
        UITextField *nextTextField = (UITextField *)[self viewWithTag:(textField.tag+1)];
        [nextTextField becomeFirstResponder];
    }else {
        //[textField resignFirstResponder];
        BOOL completed = self.nameValid && self.startDateValid && self.venueValid;
        if(completed){
            [self.basicDelegate handleBasicViewDidReturn];
        }else {
            [self validateInput:0 text:nil showTip:YES];
        }
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
    BOOL completed = self.nameValid && self.startDateValid && self.cityValid && self.venueValid;
    NSMutableDictionary *data = completed ? [self getInputData] : nil;
    [self.basicDelegate handleBasicDataDidChange:data completed:completed];
    
    if (textField.tag == 1) {
        self.eventName = futureString;
    }else if (textField.tag == 4) {
        self.eventCity = futureString;
    }else if (textField.tag == 5) {
        self.eventVenue = futureString;
    }
    _changed = YES;
    
    return YES;
}

- (BOOL)validateInput: (NSInteger)textFieldTag text:(NSString *)text showTip:(BOOL)showTip
{
    UITextField *textField = nil;
    NSString *contentText = nil;
    CGPoint point = CGPointZero;
    
    if(textFieldTag == 0 || textFieldTag == 1){
        textField = (UITextField *)[self viewWithTag:1];
        contentText = textFieldTag == 0 ? textField.text : text;
        if (contentText.length == 0) {
            if(showTip){
                self.tooltip.backgroundView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                self.tooltip.edgeInsets = UIEdgeInsetsMake(14, 10, 8, 10);
                self.tooltip.text = @"请输入活动名称。";
                point.x = self.frame.size.width - self.tooltip.frame.size.width - 8;
                point.y = self.frame.origin.y + textField.superview.superview.frame.origin.y + textField.superview.superview.frame.size.height - 10;
                [self.tooltip showAtPoint:point inView:self];
                [textField becomeFirstResponder];
            }
            self.nameValid = NO;
            return NO;
        }else {
            self.nameValid = YES;
            [self.tooltip removeFromSuperview];
        }
    }
    
    if(textFieldTag == 0 || textFieldTag == 2){
        textField = (UITextField *)[self viewWithTag:2];
        contentText = textFieldTag == 0 ? textField.text : text;
        if (contentText.length == 0) {
            if(showTip){
                self.tooltip.backgroundView.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
                self.tooltip.edgeInsets = UIEdgeInsetsMake(14, 10, 8, 10);
                self.tooltip.text = @"请输入开始时间。";
                point.x = self.frame.origin.x + 8;
                point.y = self.frame.origin.y + textField.superview.superview.frame.origin.y + textField.superview.superview.frame.size.height - 4;
                [self.tooltip showAtPoint:point inView:self];
                [textField becomeFirstResponder]; 
            }
            startDateValid = NO;
            return NO;
        }else {
            self.startDateValid = YES;
            [self.tooltip removeFromSuperview];
        }
    }
    
    if(textFieldTag == 0 || textFieldTag == 4){
        textField = (UITextField *)[self viewWithTag:4];
        contentText = textFieldTag == 0 ? textField.text : text;
        if (contentText.length == 0) {
            if(showTip){
                self.tooltip.backgroundView.transform = CGAffineTransformMakeScale(1.0f, -1.0f);
                self.tooltip.edgeInsets = UIEdgeInsetsMake(8, 10, 14, 10);
                self.tooltip.text = @"请输入活动城市。";
                point.x = self.frame.size.width - self.tooltip.frame.size.width - 8;
                point.y = self.frame.origin.y + textField.superview.superview.frame.origin.y - self.tooltip.frame.size.height + 10;
                [self.tooltip showAtPoint:point inView:self];
                [textField becomeFirstResponder];
            }
            self.cityValid = NO;
            return NO;
        }else {
            self.cityValid = YES;
            [self.tooltip removeFromSuperview];
        }
    }
    
    if(textFieldTag == 0 || textFieldTag == 5){
        textField = (UITextField *)[self viewWithTag:5];
        contentText = textFieldTag == 0 ? textField.text : text;
        if (contentText.length == 0) {
            if(showTip){
                self.tooltip.backgroundView.transform = CGAffineTransformMakeScale(1.0f, -1.0f);
                self.tooltip.edgeInsets = UIEdgeInsetsMake(8, 10, 14, 10);
                self.tooltip.text = @"请输入活动地点。";
                point.x = self.frame.size.width - self.tooltip.frame.size.width - 8;
                point.y = self.frame.origin.y + textField.superview.superview.frame.origin.y - self.tooltip.frame.size.height + 10;
                [self.tooltip showAtPoint:point inView:self];
                [textField becomeFirstResponder]; 
            }
            self.venueValid = NO;
            return NO;
        }else {
            self.venueValid = YES;
            [self.tooltip removeFromSuperview];
        }
    }
    
    return YES;
}

- (void)recoverLastInputAsFirstResponder
{
    if(self.lastInputTag > 0){
        [[self viewWithTag:self.lastInputTag] becomeFirstResponder];
    }
}

- (NSMutableDictionary *)getInputData
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            self.eventName, @"event_name",
            self.eventStartDateStr, @"start_date",
            self.eventEndDateStr, @"end_date",
            self.eventCity, @"city",
            self.eventVenue, @"venue",
            nil];
}


@end
