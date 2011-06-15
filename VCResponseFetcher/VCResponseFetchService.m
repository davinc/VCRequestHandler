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

@synthesize delegate, url, responseProcessor;

-(id)init
{
	self = [super init];
	if (self) {
		self.delegate = nil;
		self.url = nil;
		self.responseProcessor = nil;
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
	if( [self isCancelled] ) return;
	
	[self notifyStart];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSError *error = nil;
	NSData *data = [NSData dataWithContentsOfURL:url
										 options:NSDataReadingMapped
										   error:&error];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	if( [self isCancelled] ) return;
	
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
	if ([self.delegate respondsToSelector:@selector(didSucceedReceiveResponse:)]) {
		[self.delegate performSelectorOnMainThread:@selector(didSucceedReceiveResponse:)
										withObject:self.responseProcessor
									 waitUntilDone:YES];
	}
}

-(void)didFail:(NSError *)error
{
	[self.responseProcessor setError:error];
	if ([self.delegate respondsToSelector:@selector(didFailReceiveResponse:)]) {
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
