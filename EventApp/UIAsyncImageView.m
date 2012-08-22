//
//  UIAsyncImageView.m
//  EventApp
//
//  Created by zhenglin li on 12-7-20.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "UIAsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface UIAsyncImageView()

@end


@implementation UIAsyncImageView

@synthesize image = _image, imagePath = _imagePath;


- (id)init
{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    [_image release];
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
    }
}

- (void)didFailDownload:(ASIHTTPRequest *)request
{
    //NSLog(@"download fail: %@", request.url);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGPathRef clipPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:6.0].CGPath;
    CGContextAddPath(context, clipPath);
    CGContextClip(context);
    
    [self.image drawInRect:rect];
    
    CGContextRestoreGState(context);
}

- (void)setImage:(UIImage *)newImage
{
    if(_image != newImage){
        [_image release];
        _image = [newImage retain];
        [self setNeedsDisplay];
    }
}

@end
