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

@property(nonatomic, retain) JSTokenField *tagInput;
@property(nonatomic, retain) UIImageView *tagInputBg;

@end

@implementation FEAddEventTagView

@synthesize tagInput = _tagInput, tagInputBg = _tagInputBg, tags = _tags, tagDelegate = _tagDelegate;

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
