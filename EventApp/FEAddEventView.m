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

@end

@implementation FEAddEventView

@synthesize toolbar, autoFocusFirstInput;
@synthesize dateSheet, tooltip, lastInputTag;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
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
            if(self.autoFocusFirstInput) [((FELoginTableViewCell *)cell).fieldInput becomeFirstResponder];
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
        [self validateInput:textField.tag text:textField.text showTip:NO];
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
        [[self viewWithTag:nextTag] becomeFirstResponder];
    }
}

#pragma mark - Textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //hide all actions when date picker popups
    BOOL hideToolbar = textField.tag == 2 || textField.tag == 3;
    [self.toolbar showOrHideActions:hideToolbar];
    [self.toolbar resetAction];
    
    //make sure the input is visible
    float tableHeight = self.contentSize.height;
    CGRect cellRect = [textField convertRect:textField.superview.frame toView:self];
    int tableInsetTop = 0;
    if(cellRect.origin.y + cellRect.size.height + 44 > self.toolbar.frame.origin.y){
        tableInsetTop = tableHeight - self.toolbar.frame.origin.y;
    }
    self.contentInset = UIEdgeInsetsMake(tableInsetTop, 0, 0, 0);
    
    //record last input tag
    self.lastInputTag = textField.tag;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag < 4){
        UITextField *nextTextField = (UITextField *)[self viewWithTag:(textField.tag+1)];
        [nextTextField becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
        //[self createAction];
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
            return NO;
        }else {
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
            return NO;
        }else {
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
                self.tooltip.text = @"请输入活动地点。";
                point.x = self.frame.size.width - self.tooltip.frame.size.width - 8;
                point.y = self.frame.origin.y + textField.superview.superview.frame.origin.y - self.tooltip.frame.size.height + 10;
                [self.tooltip showAtPoint:point inView:self];
                [textField becomeFirstResponder]; 
            }
            return NO;
        }else {
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
    NSString *eventName = ((UITextField *)[self viewWithTag:1]).text;
    NSString *startDate = [[NSDate dateFromString:((UITextField *)[self viewWithTag:2]).text withFormat:@"YY-MM-dd HH:mm"] string];
    NSString *endDate = [[NSDate dateFromString:((UITextField *)[self viewWithTag:3]).text withFormat:@"YY-MM-dd HH:mm"] string];
    NSString *venue = ((UITextField *)[self viewWithTag:4]).text;
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            eventName, @"event_name",
            startDate, @"start_date",
            endDate, @"end_date",
            venue, @"venue",
            nil];
}


@end
