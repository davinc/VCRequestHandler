//
//  CGResponseFetchService.m
//  VCResponseFetcherTest
//
//  Created by Vinay Chavan on 4/7/11.
//  Copyright 2011 . All rights reserved.
//

#import "VCResponseFetchService.h"

@interface VCResponseFetchService()
-(void)didFinish;
-(void)didFail:(NSError *)error;
-(void)notifyStart;
-(void)notifyFinish;
@end

@implementation VCResponseFetchService

@synthesize delegate, url, responseProcessor, sharedCache, cachingType;

-(id)init
{
	self = [super init];
	if (self) {
		self.delegate = nil;
		self.url = nil;
		self.responseProcessor = nil;
		self.cachingType = VCResponseFetchRemoteIfNoCache;
		self.sharedCache = [VCResponseFetchServiceCache sharedCache];
	}
	return self;
}

-(void)dealloc
{
	[url release], url = nil;
	[responseProcessor release], responseProcessor = nil;
	[super dealloc];
}

-(void)start
{
	if (self.url == nil) return;
	
	// Starting
	if( [self isCancelled] ) return;
	
	[self notifyStart];
	
	// Processing
	NSError *error = nil;
	NSData *data = nil;
	if (self.cachingType != VCResponseFetchNoCache) 
	{
		if ([self.sharedCache isCachedDataAvailableForUrl:self.url]) 
		{
			data = [self.sharedCache cachedDataForUrl:self.url];
		}
	}
	
	if( [self isCancelled] ) {
		[self notifyFinish];
		return;	
	}

	if (self.cachingType != VCResponseFetchOnlyCache && data == nil) 
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]
									 options:NSDataReadingMapped
									   error:&error];
		[self.sharedCache saveData:data forUrl:self.url];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
	else if (data == nil)
	{
		// error
		error = [NSError errorWithDomain:@""
									code:404
								userInfo:nil];
	}
	
	// Ending
	
	if( [self isCancelled] ) {
		[self notifyFinish];
		return;	
	}
	
	if (error) 
	{
		[self didFail:error];
	}
	else 
	{
		[self.responseProcessor processData:data];
		[self didFinish];
	}
	
	[self notifyFinish];
}

#pragma mark - Private Methods

-(void)didFinish
{
	if ([self.delegate respondsToSelector:@selector(didSucceedReceiveResponse:)]) 
	{
		[self.delegate performSelectorOnMainThread:@selector(didSucceedReceiveResponse:)
										withObject:self.responseProcessor
									 waitUntilDone:YES];
	}
}

-(void)didFail:(NSError *)error
{
	[self.responseProcessor setError:error];
	if ([self.delegate respondsToSelector:@selector(didFailReceiveResponse:)])
	{
		[self.delegate performSelectorOnMainThread:@selector(didFailReceiveResponse:)
										withObject:self.responseProcessor
									 waitUntilDone:YES];
	}
}

-(void)notifyStart 
{
	[self willChangeValueForKey:@"isExecuting"];
	executing = YES;
	[self didChangeValueForKey:@"isExecuting"];
}

-(void)notifyFinish 
{
	[self willChangeValueForKey:@"isExecuting"];
	[self willChangeValueForKey:@"isFinished"];
	executing = NO;
	finished  = YES;
	[self didChangeValueForKey:@"isFinished"];
	[self didChangeValueForKey:@"isExecuting"];
}

-(BOOL)isConcurrent
{
	return YES;
}

-(BOOL)isExecuting
{
	return executing;
}

-(BOOL)isFinished
{
	return finished;
}

@end
