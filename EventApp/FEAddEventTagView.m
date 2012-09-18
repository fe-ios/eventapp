//
//  FEAddEventTagView.m
//  EventApp
//
//  Created by zhenglin li on 12-8-17.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FEAddEventTagView.h"
#import "FELoginTableViewCell.h"
#import "FETag.h"


@interface FEAddEventTagView()

@property(nonatomic, retain) JSTokenField *tagInput;
@property(nonatomic, retain) UIImageView *tagInputBg;
@property(nonatomic, retain) UITableView *searchList;
@property(nonatomic, retain) NSMutableArray *searchResult;

@end

@implementation FEAddEventTagView

@synthesize tagInput = _tagInput, tagInputBg = _tagInputBg, tags = _tags, tagDelegate = _tagDelegate, searchTagData = _searchTagData, searchList = _searchList, searchResult = _searchResult, changed = _changed;

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
        for (int i = 0; i < event.tags.count; i++) {
            FETag *tag = (FETag *)[event.tags objectAtIndex:i];
            [self.tagInput addTokenWithTitle:tag.name representedObject:tag.name];
        }
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
    FETag *eTag1 = [[[FETag alloc] initWithData:1 name:@"html5"] autorelease];
    FETag *eTag2 = [[[FETag alloc] initWithData:1 name:@"ios"] autorelease];
    FETag *eTag3 = [[[FETag alloc] initWithData:1 name:@"xcode"] autorelease];
    FETag *eTag4 = [[[FETag alloc] initWithData:1 name:@"flash"] autorelease];
    FETag *eTag5 = [[[FETag alloc] initWithData:1 name:@"android"] autorelease];
    self.searchTagData = [[NSMutableArray alloc] initWithObjects:eTag1, eTag2, eTag3, eTag4, eTag5, nil];
    
    self.searchList = [[[UITableView alloc] init] autorelease];
    //self.searchList.frame = CGRectMake(10, 60, 300, 44);
    self.searchList.layer.cornerRadius = 6;
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
    _changed = YES;
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
    _changed = YES;
}

- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField
{
    NSMutableString *aTag = [NSMutableString string];
	
	NSMutableCharacterSet *charSet = [[[NSCharacterSet whitespaceCharacterSet] mutableCopy] autorelease];
	[charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
	
    NSString *rawStr = tokenField.rawText;
	for (int i = 0; i < rawStr.length; i++)
	{
		if (![charSet characterIsMember:[rawStr characterAtIndex:i]])
		{
			[aTag appendFormat:@"%@",[NSString stringWithFormat:@"%c", [rawStr characterAtIndex:i]]];
		}
	}
    
    if (rawStr.length)
	{
		[tokenField addTokenWithTitle:rawStr representedObject:aTag];
	}
    
    return NO;
}

- (void)tokenFieldTextDidChange:(JSTokenField *)tokenField
{
    self.searchResult = [self search:tokenField.rawText];
    int count = self.searchResult.count;
    CGFloat rectHeight = count == 0 ? 0 : count == 1 ? 44 : 88;
    self.searchList.frame = CGRectMake(10, 60, 300, rectHeight);
    [self.searchList reloadData];
}

- (void)handleTokenFieldFrameDidChange:(NSNotification *)note
{
    [self setNeedsLayout];
}

#pragma mark - search list

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResult.count;
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
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    
    FETag *eTag = [self.searchResult objectAtIndex:indexPath.row];
    cell.textLabel.text = eTag.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *eTagValue = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.tagInput addTokenWithTitle:eTagValue representedObject:eTagValue];
}

- (NSMutableArray *)search:(NSString *)text
{
    NSMutableArray *result = [NSMutableArray array];
    FETag *eTag = nil;
    NSRange range;
    for (int i = 0; i < self.searchTagData.count; i++) {
        eTag = [self.searchTagData objectAtIndex:i];
        range = [eTag.name.lowercaseString rangeOfString:text.lowercaseString];
        if(range.location != NSNotFound){
            [result addObject:eTag];
        }
    }
    
    return result;
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
