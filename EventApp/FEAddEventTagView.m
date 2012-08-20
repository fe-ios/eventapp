//
//  FEAddEventTagView.m
//  EventApp
//
//  Created by zhenglin li on 12-8-17.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEAddEventTagView.h"
#import "FELoginTableViewCell.h"

@interface FEAddEventTagView()

@property(nonatomic, assign) int lastInputTag;

@end

@implementation FEAddEventTagView

@synthesize lastInputTag;

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
    
    self.lastInputTag = 1;
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
    return indexPath.row == 1 ? 47 : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CreateEventTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        
        NSString *nibName = @"FELoginTableViewCell";
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
        cell = (UITableViewCell *)[nibs objectAtIndex:0];
    }
    
    NSString *cellBgName = indexPath.row == 0 ? @"roundTableCellTop" : indexPath.row == 1 ? @"roundTableCellBottom" : @"roundTableCellMiddle";
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
            ((FELoginTableViewCell *)cell).fieldLabel.text = @"地点";
            ((FELoginTableViewCell *)cell).fieldInput.placeholder = @"必填";
            ((FELoginTableViewCell *)cell).fieldInput.delegate = self;
            ((FELoginTableViewCell *)cell).fieldInput.returnKeyType = UIReturnKeyGo;
            ((FELoginTableViewCell *)cell).fieldInput.tag = indexPath.row+1;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)recoverLastInputAsFirstResponder
{
    if(self.lastInputTag > 0){
        [[self viewWithTag:self.lastInputTag] becomeFirstResponder];
    }
}

@end
