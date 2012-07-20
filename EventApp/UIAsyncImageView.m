//
//  UIAsyncImageView.m
//  EventApp
//
//  Created by zhenglin li on 12-7-20.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "UIAsyncImageView.h"

@implementation UIImageView (Async)


- (void)loadImageAsync:(NSString *)imageURL withQueue:(NSOperationQueue *)queue
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imageURL]];
    request.delegate = self;
    request.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    request.didStartSelector = @selector(didStartDownload:);
    request.didFinishSelector = @selector(didFinishDownload:);
    request.didFailSelector = @selector(didFailDownload:);
    [queue addOperation:request];
    
    self.image = [UIImage imageNamed:@"pictureGridPlaceholder"];
}

- (void)didStartDownload:(ASIHTTPRequest *)request
{
    //NSLog(@"download start: %@", request.url);
}

- (void)didFinishDownload:(ASIHTTPRequest *)request
{
    NSLog(@"download finish: %@", request.url);
    if(request.responseStatusCode == 200 || request.responseStatusCode == 304){
        if(request.didUseCachedResponse){
            NSLog(@"download from cache");
        }
        self.image = [UIImage imageWithData:request.responseData];
        [self setNeedsLayout];
    }
}

- (void)didFailDownload:(ASIHTTPRequest *)request
{
    NSLog(@"download fail: %@", request.url);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
