//
//  FEImagePickerController.m
//  EventApp
//
//  Created by zhenglin li on 12-8-21.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEImagePickerController.h"
#import <QuartzCore/QuartzCore.h>

@interface FEImagePickerController ()

@end

@implementation FEImagePickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    return;
    CALayer *aLayer = [self.view.layer.sublayers objectAtIndex:0];
    CGRect rect = aLayer.frame;
    NSLog(@"clip: %@", NSStringFromCGRect(rect));
    CAShapeLayer *clipLayer = [[[CAShapeLayer alloc] init] autorelease];
    //clipLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 20+44, rect.size.width, rect.size.height-20-44)].CGPath;
    clipLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 20, rect.size.width, rect.size.height-20) cornerRadius:8.0].CGPath;
    aLayer.mask = clipLayer;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //CALayer *aLayer = [self.view.layer.sublayers objectAtIndex:1];
    //aLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    
    
    
    //newLayer.frame = CGRectMake(0, 0, 320, 20);
    //newLayer.backgroundColor = [UIColor blackColor].CGColor;
    //[self.view.layer addSublayer:newLayer];
}

@end
