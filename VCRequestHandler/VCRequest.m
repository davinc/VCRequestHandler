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

@implementation VCRequest

@synthesize delegate = _delegate;
@synthesize dataService = _dataService;
@synthesize tag = _tag;

- (id)initWithService:(VCDataService *)service
{
	self = [super init];
	if (self) {
		self.delegate = nil;
		self.dataService = service;
	}
	return self;
}

- (void)dealloc
{
	[_dataService release], _dataService = nil;
	[super dealloc];
}

- (void)start
{
	if (self.isCancelled) {
		[self notifyFinish];
		return;
	}
	
	if ([self.dataService URL] == nil) {
		[self notifyFinish];
		return;	
	}
	
	NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
	[self notifyStart];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self.dataService URL]
														   cachePolicy:[self.dataService cachePolicy]
													   timeoutInterval:30];
		
	switch ([self.dataService method]) {
		case VCGETRequest:
			[request setHTTPMethod:@"GET"];
			break;
		case VCPOSTRequest:
			[request setHTTPMethod:@"POST"];
			break;
	}
	
	[request setAllHTTPHeaderFields:[self.dataService allHTTPHeaderFields]];
	[request setHTTPBody:[self.dataService body]];
	
	NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
																delegate:self];
	[connection start];
	
	do {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
	} while (_isExecuting);
	[autoreleasePool release], autoreleasePool = nil;
}

#pragma mark - Private Methods

- (void)didFinish
{
	if ([self.delegate respondsToSelector:@selector(didFinishRequest:)]) 
	{
		[self.delegate performSelectorOnMainThread:@selector(didFinishRequest:)
										withObject:self
									 waitUntilDone:NO];
	}
	[self notifyFinish];
}

- (void)didFail
{
	if ([self.delegate respondsToSelector:@selector(didFailRequest:)])
	{
		[self.delegate performSelectorOnMainThread:@selector(didFailRequest:)
										withObject:self
									 waitUntilDone:NO];
	}
	[self notifyFinish];
}

- (void)notifyStart 
{
	[self willChangeValueForKey:@"isExecuting"];
	_isExecuting = YES;
	_isFinished = NO;
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

- (void)cancel
{
	self.delegate = nil;
	[super cancel];
}

#pragma mark - NSOperationDelegate Methods

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
	if (self.isCancelled) {
		[connection cancel];
		[self didFail];
		return;
	}
	self.dataService.expectedDataLength = [response expectedContentLength];
	[self.dataService willStartReceivingData];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)receivedData
{
	if (self.isCancelled) {
		[connection cancel];
		[self didFail];
		return;
	}
	
	self.dataService.receivedDataLength += [receivedData length];
	[self.dataService didReceiveData:receivedData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (self.isCancelled) {
		[connection cancel];
		[self didFail];
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
