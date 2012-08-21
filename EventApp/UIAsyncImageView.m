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

@synthesize image, imagePath;


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
    [image release];
    [imagePath release];
    [super dealloc];
}

- (void)loadImageAsync:(NSString *)imageURL withQueue:(NSOperationQueue *)queue
{
    imagePath = imageURL;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imagePath]];
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
    if(image != newImage){
        [image release];
        image = [newImage retain];
        [self setNeedsDisplay];
    }
}

@end
