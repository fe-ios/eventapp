//
//  FEAddEventTagView.m
//  EventApp
//
//  Created by zhenglin li on 12-8-17.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEAddEventTagView.h"
#import "FELoginTableViewCell.h"
#import "FEEventTag.h"


@interface FEAddEventTagView()

@property(nonatomic, retain) JSTokenField *tagInput;
@property(nonatomic, retain) UIImageView *tagInputBg;
@property(nonatomic, retain) UITableView *searchList;

@end

@implementation FEAddEventTagView

@synthesize tagInput = _tagInput, tagInputBg = _tagInputBg, tags = _tags, tagDelegate = _tagDelegate, searchTagData = _searchTagData, searchList = _searchList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [_tagInput release];
    [_tagInputBg release];
    [_tags release];
    [_searchTagData release];
    [_searchList release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.alwaysBounceVertical = YES;
    self.tags = [[[NSMutableArray alloc] init] autorelease];
	
    self.tagInputBg = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"roundTableCellSingle"] resizableImageWithCapInsets:UIEdgeInsetsMake(23, 15, 23, 15)]] autorelease];
    [self addSubview:self.tagInputBg];
    
    self.tagInput = [[[JSTokenField alloc] init] autorelease];
    self.tagInput.frame = CGRectMake(15, 18, 290, 21);
    self.tagInput.delegate = self;
    self.tagInput.backgroundColor = [UIColor clearColor];
    //self.tagInput.textField.borderStyle = UITextBorderStyleLine;
    [self addSubview:self.tagInput];
    
    //test data
    FEEventTag *eTag1 = [[[FEEventTag alloc] initWithData:1 value:@"html5"] autorelease];
    FEEventTag *eTag2 = [[[FEEventTag alloc] initWithData:1 value:@"html5"] autorelease];
    FEEventTag *eTag3 = [[[FEEventTag alloc] initWithData:1 value:@"html5"] autorelease];
    FEEventTag *eTag4 = [[[FEEventTag alloc] initWithData:1 value:@"html5"] autorelease];
    FEEventTag *eTag5 = [[[FEEventTag alloc] initWithData:1 value:@"html5"] autorelease];
    FEEventTag *eTag6 = [[[FEEventTag alloc] initWithData:1 value:@"html5"] autorelease];
    FEEventTag *eTag7 = [[[FEEventTag alloc] initWithData:1 value:@"html5"] autorelease];
    FEEventTag *eTag8 = [[[FEEventTag alloc] initWithData:1 value:@"html5"] autorelease];
    FEEventTag *eTag9 = [[[FEEventTag alloc] initWithData:1 value:@"html5"] autorelease];
    FEEventTag *eTag10 = [[[FEEventTag alloc] initWithData:1 value:@"html5"] autorelease];
    
    //self.searchTagData = [NSMutableArray alloc] initWithObjects:<#(id), ...#>, nil
    
    self.searchList = [[UITableView alloc] init];
    self.searchList.frame = CGRectMake(10, 55, 290, 44);
    self.searchList.delegate = self;
    self.searchList.dataSource = self;
    [self addSubview:self.searchList];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTokenFieldFrameDidChange:) name:JSTokenFieldFrameDidChangeNotification object:nil];
}

#pragma mark - JSTokenFieldDelegate

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
	NSDictionary *aTag = [NSDictionary dictionaryWithObject:obj forKey:title];
	[self.tags addObject:aTag];
    [self.tagDelegate handleTagDidChange:self.tags];
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveToken:(NSString *)title representedObject:(id)obj
{
    for (int i = 0; i < self.tags.count; i++) {
        NSDictionary *aTag = [self.tags objectAtIndex:i];
        if([aTag objectForKey:title]){
            [self.tags removeObject:aTag];
            break;
        }
    }
    [self.tagDelegate handleTagDidChange:self.tags];
}

- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField {
    NSMutableString *aTag = [NSMutableString string];
	
	NSMutableCharacterSet *charSet = [[[NSCharacterSet whitespaceCharacterSet] mutableCopy] autorelease];
	[charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
	
    NSString *rawStr = [[tokenField textField] text];
	for (int i = 0; i < [rawStr length]; i++)
	{
		if (![charSet characterIsMember:[rawStr characterAtIndex:i]])
		{
			[aTag appendFormat:@"%@",[NSString stringWithFormat:@"%c", [rawStr characterAtIndex:i]]];
		}
	}
    
    if ([rawStr length])
	{
		[tokenField addTokenWithTitle:rawStr representedObject:aTag];
	}
    
    return NO;
}

- (void)handleTokenFieldFrameDidChange:(NSNotification *)note
{
    [self setNeedsLayout];
}

#pragma mark - search list

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellIdentifier = @"TagSearchListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] init] autorelease];
        
    }
    
    FEEventTag *eTag = [self.searchTagData objectAtIndex:indexPath.row];
    cell.textLabel.text = eTag.value;
    
    return cell;
}

- (void)layoutSubviews
{
    CGRect rect = self.bounds;
    self.tagInputBg.frame = CGRectMake(0, 10, rect.size.width, self.tagInput.frame.size.height+18);
}

- (void)recoverLastInputAsFirstResponder
{
    [self.tagInput.textField becomeFirstResponder];
}

@end
