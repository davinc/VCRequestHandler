//
//  VCRequest.m
//  VCRequestHandler
//
//  Created by Vinay Chavan on 04/09/11.
//
//  Copyright (C) 2011 by Vinay Chavan
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "VCRequest.h"

#import "VCDataService.h"


@interface VCRequest ()

- (void)didFinish;
- (void)didFail;
- (void)notifyStart;
- (void)notifyFinish;

@end


@implementation VCRequest

@synthesize delegate = _delegate;
@synthesize dataService = _dataService;
@synthesize tag = _tag;
@synthesize expectedDataLength = _expectedDataLength;
@synthesize receivedDataLength = _receivedDataLength;

- (id)initWithService:(VCDataService *)service
{
	self = [super init];
	if (self) {
		self.delegate = nil;
		self.dataService = service;

		_isExecuting = NO;
		_isFinished = NO;
		_isCancelled = NO;
	}
	return self;
}

- (void)dealloc
{
	_delegate = nil;
	[_connection release], _connection = nil;
	[_dataService release], _dataService = nil;
	[super dealloc];
}

- (void)start
{
	if ([self isCancelled]) {
		[self notifyFinish];
		return;
	}

	NSURL *url = [self.dataService URL];
	if (url == nil) {
		[self cancel];
		[self notifyFinish];
		return;
	}

	[self notifyStart];

	@autoreleasepool {
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
															   cachePolicy:[self.dataService cachePolicy]
														   timeoutInterval:30];
		
		[request setHTTPMethod:[self HTTPMethodForRequestMethod:[self.dataService method]]];
		[request setAllHTTPHeaderFields:[self.dataService allHTTPHeaderFields]];
		[request setHTTPBody:[self.dataService body]];

		_connection = [[NSURLConnection connectionWithRequest:request
													 delegate:self] retain];
		[_connection start];

		[self willBegin];
		
		do {
			[[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
		} while (_isExecuting);
	}
}


#pragma mark - Private Methods

- (NSString *)HTTPMethodForRequestMethod:(VCRequestMethod)method
{
	if (method == VCGETRequest) {
		return @"GET";
	}else if (method == VCPOSTRequest) {
		return @"POST";
	}
	
	// return GET by default
	return @"GET";
}

- (void)willBegin
{
	dispatch_async(dispatch_get_main_queue(), ^{
		if ([self.delegate respondsToSelector:@selector(willBeginRequest:)])
		{
			[self.delegate willBeginRequest:self];
		}
	});
}

- (void)didFinish
{
	dispatch_async(dispatch_get_main_queue(), ^{
		if ([self.delegate respondsToSelector:@selector(didFinishRequest:)])
		{
			[self.delegate didFinishRequest:self];
		}
	});
	[self notifyFinish];
}

- (void)didFail
{
	dispatch_async(dispatch_get_main_queue(), ^{
		if ([self.delegate respondsToSelector:@selector(didFailRequest:)])
		{
			[self.delegate didFailRequest:self];
		}
	});
	[self notifyFinish];
}

- (void)notifyStart
{
	_receivedDataLength = 0;
	_expectedDataLength = 0;

	[self willChangeValueForKey:@"isExecuting"];
	_isExecuting = YES;
	[self didChangeValueForKey:@"isExecuting"];
}

- (void)notifyFinish
{
	[self willChangeValueForKey:@"isExecuting"];
	[self willChangeValueForKey:@"isFinished"];
	_isExecuting = NO;
	_isFinished  = YES;
	[self didChangeValueForKey:@"isFinished"];
	[self didChangeValueForKey:@"isExecuting"];
}


#pragma mark Overriden

- (BOOL)isConcurrent
{
	return NO;
}

- (BOOL)isExecuting
{
	return _isExecuting;
}

- (BOOL)isFinished
{
	return _isFinished;
}

- (BOOL)isCancelled
{
	return _isCancelled;
}

- (void)cancel
{
	[self willChangeValueForKey:@"isCancelled"];
	self.delegate = nil;
	_isCancelled = YES;
	[self didChangeValueForKey:@"isCancelled"];
}


#pragma mark - NSURLConnectionDelegate Methods

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSCachedURLResponse *memOnlyCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response
																						  data:cachedResponse.data
																					  userInfo:cachedResponse.userInfo
																				 storagePolicy:NSURLCacheStorageAllowed];
    return [memOnlyCachedResponse autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if ([self isCancelled]) {
		[connection cancel];
		[self notifyFinish];
		return;
	}

	self.expectedDataLength = [response expectedContentLength];
	[self.dataService willStartReceivingData];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)receivedData
{
	if ([self isCancelled]) {
		[connection cancel];
		[self notifyFinish];
		return;
	}

	self.receivedDataLength += [receivedData length];
	[self.dataService didReceiveData:receivedData];

	dispatch_async(dispatch_get_main_queue(), ^{
		if ([self.delegate respondsToSelector:@selector(didProgressRequest:)]) {
			[self.delegate didProgressRequest:self];
		}
	});
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if ([self isCancelled]) {
		[connection cancel];
		[self notifyFinish];
		return;
	}

	[self.dataService didFinishReceivingData];

	if (self.dataService.error) {
		[self didFail];
	}else {
		[self didFinish];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self.dataService didFailReceivingDataWithError:error];
	[self didFail];
}

@end
