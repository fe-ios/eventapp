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

@property(nonatomic, retain) ASIHTTPRequest *dataRequest;

@end


@implementation UIAsyncImageView

@synthesize image = _image, imagePath = _imagePath, cornerRadius = _cornerRadius;
@synthesize dataRequest;

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
    [dataRequest clearDelegatesAndCancel];
    [dataRequest release];
    [super dealloc];
}

- (void)loadImageAsync:(NSString *)imageURL withQueue:(NSOperationQueue *)queue
{
    [_imagePath release];
    _imagePath = [imageURL copy];
    
    self.dataRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_imagePath]];
    self.dataRequest.delegate = self;
    self.dataRequest.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    self.dataRequest.didStartSelector = @selector(didStartDownload:);
    self.dataRequest.didFinishSelector = @selector(didFinishDownload:);
    self.dataRequest.didFailSelector = @selector(didFailDownload:);
    [queue addOperation:self.dataRequest];
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
            [request setResponseEncoding:0];
        }
        self.image = [UIImage imageWithData:request.responseData];
        self.dataRequest = nil;
    }
}

- (void)didFailDownload:(ASIHTTPRequest *)request
{
    //NSLog(@"download fail: %@", request.url);
}

- (void)drawRect:(CGRect)rect
{
    if(self.cornerRadius){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGPathRef clipPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:6.0].CGPath;
        CGContextAddPath(context, clipPath);
        CGContextClip(context);
        
        [self.image drawInRect:rect];
        
        CGContextRestoreGState(context);
    }else {
        [self.image drawInRect:rect];
    }
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
