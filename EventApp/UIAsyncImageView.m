//
//  UIAsyncImageView.m
//  EventApp
//
//  Created by zhenglin li on 12-7-20.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "UIAsyncImageView.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIImageView (Async)


NSString* _imagePath;


- (void)dealloc
{
    [_imagePath release];
    [super dealloc];
}

- (void)loadImageAsync:(NSString *)imageURL withQueue:(NSOperationQueue *)queue
{
    [_imagePath release];
    _imagePath = [imageURL copy];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_imagePath]];
    request.delegate = self;
    request.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    request.didStartSelector = @selector(didStartDownload:);
    request.didFinishSelector = @selector(didFinishDownload:);
    request.didFailSelector = @selector(didFailDownload:);
    [queue addOperation:request];
}

- (void)didStartDownload:(ASIHTTPRequest *)request
{
    //NSLog(@"download start: %@", request.url);
}

- (void)didFinishDownload:(ASIHTTPRequest *)request
{
    //NSLog(@"download finish: %@", request.url);
    if(request.responseStatusCode == 200 || request.responseStatusCode == 304){
        if(request.didUseCachedResponse){
            //NSLog(@"download from cache");
        }
        self.image = [UIImage imageWithData:request.responseData];
        //[self setNeedsLayout];
    }
}

- (void)didFailDownload:(ASIHTTPRequest *)request
{
    //NSLog(@"download fail: %@", request.url);
}

- (void)setRoundBorder
{
    self.layer.cornerRadius = 6.0;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithRed:174.0/255 green:174.0/255 blue:174.0/255 alpha:1.0].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(5.0, 5.0);
    self.layer.shadowRadius = 3.0;
    self.layer.shadowOpacity = 1.0;
}

- (NSString *)imagePath
{
    return _imagePath;
}

@end
