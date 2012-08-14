//
//  FEUploadController.m
//  EventApp
//
//  Created by zhenglin li on 12-7-23.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEUploadController.h"
#import "ASIFormDataRequest.h"
#import "FEServerAPI.h"

@interface FEUploadController ()

@end

@implementation FEUploadController

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
    
    //upload test
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imgPath = [NSString stringWithFormat:@"%@/demo.jpg", path];
    [self uploadImageFile:imgPath];
    //NSData *imgData = [NSData dataWithContentsOfFile:imgPath];
    //[self uploadImageData:imgData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)uploadImageFile: (NSString *)imagePath
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", API_BASE, API_UPLOAD];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setFile:imagePath forKey:@"userfile"];
    //[request setPostValue:@"image_title" forKey:@"title"];
    request.delegate = self;
    request.didFinishSelector = @selector(uploadFinish:);
    [request startAsynchronous];
}

- (void)uploadImageData: (NSData *)imageData
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", API_BASE, API_UPLOAD];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setData:imageData withFileName:@"upload.jpg" andContentType:@"image/jpeg" forKey:@"userfile"];
    request.delegate = self;
    request.uploadProgressDelegate = self;
    request.showAccurateProgress = YES;
    request.didFinishSelector = @selector(uploadFinish:);
    [request startAsynchronous];
}

- (void)uploadFinish: (ASIFormDataRequest *) request
{
    NSLog(@"upload success: %@", request.responseString);
}

- (void)setProgress:(float)progress
{
    NSLog(@"progress: %f", progress);
}

@end
