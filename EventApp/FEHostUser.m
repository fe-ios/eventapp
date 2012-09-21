//
//  FEHostUser.m
//  EventApp
//
//  Created by zhenglin li on 12-9-21.
//  Copyright (c) 2012年 snda. All rights reserved.
//

#import "FEHostUser.h"
#import "ASIHTTPRequest.h"

@interface FEHostUser ()

@property(nonatomic, retain) ASIHTTPRequest *avatarRequest;

@end

@implementation FEHostUser

@synthesize password, avatarImage;
@synthesize avatarRequest;

-(void)dealloc
{
    [password release];
    [avatarImage release];
    [avatarRequest release];
    [super dealloc];
}

-(void)loadAvatar
{
    if(!self.avatarURL) return;
    
    self.avatarRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.avatarURL]];
    self.avatarRequest.delegate = self;
    self.avatarRequest.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    self.avatarRequest.didStartSelector = @selector(didStartDownload:);
    self.avatarRequest.didFinishSelector = @selector(didFinishDownload:);
    self.avatarRequest.didFailSelector = @selector(didFailDownload:);
    [self.avatarRequest startAsynchronous];
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
        self.avatarImage = [UIImage imageWithData:request.responseData];
        self.avatarRequest = nil;
    }
}

- (void)didFailDownload:(ASIHTTPRequest *)request
{
    //NSLog(@"download fail: %@", request.url);
}

@end
