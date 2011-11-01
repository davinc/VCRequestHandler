//
//  VCResponseFetcher.m
//  Demo
//
//  Created by Vinay Chavan on 15/06/11.
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

#import "VCResponseFetcher.h"

@interface VCResponseFetcher()

- (void)showNetworkActivityIndicator;
- (void)hideNetworkActivityIndicatorIfRequired;

@end

@implementation VCResponseFetcher

- (id)init 
{
	self = [super init];
	if (self) 
	{
		_networkOperationQueue = [[NSOperationQueue alloc] init];
		[_networkOperationQueue setMaxConcurrentOperationCount:4];
	}
	return self;
}

- (void)dealloc 
{
	[_networkOperationQueue release], _networkOperationQueue = nil;
	[super dealloc];
}

+(VCResponseFetcher*)sharedInstance 
{
	static VCResponseFetcher *sharedInstance = nil;
	
	if (sharedInstance == nil) 
	{
		sharedInstance = [[VCResponseFetcher alloc] init];
	}
	
	return sharedInstance;
}

- (VCResponseFetchAsyncService *)addObserver:(NSObject<VCResponseFetchServiceDelegate>*)observer
										 url:(NSString*)url
									   cache:(NSURLRequestCachePolicy)cache
						   responseProcessor:(VCDataResponseProcessor *)processor
{
#if DEBUG
	NSLog(@"%@", url);
#endif
	VCResponseFetchAsyncService *operation = [[VCResponseFetchAsyncService alloc] init];
	operation.delegate = observer;
	operation.url = url;
	operation.responseProcessor = processor;
	operation.cachePolicy = cache;
	
	[_networkOperationQueue addOperation:operation];
	
	[self showNetworkActivityIndicator];
	
	return [operation autorelease];
}

- (VCResponseFetchAsyncService *)addObserver:(NSObject<VCResponseFetchServiceDelegate>*)observer
									  method:(NSString*)method
										 url:(NSString*)url
							 allHeaderFields:(NSDictionary*)allHeaderFields
										body:(NSData*)body
									   cache:(NSURLRequestCachePolicy)cache
						   responseProcessor:(VCDataResponseProcessor *)processor
{
#if DEBUG
	NSLog(@"%@", url);
#endif
	VCResponseFetchAsyncService *operation = [[VCResponseFetchAsyncService alloc] init];
	operation.delegate = observer;
	operation.method = method;
	operation.url = url;
	operation.allHTTPHeaderFields = allHeaderFields;
	operation.body = body;
	operation.responseProcessor = processor;
	operation.cachePolicy = cache;
	
	[_networkOperationQueue addOperation:operation];
	
	[self showNetworkActivityIndicator];
	
	return [operation autorelease];
}

- (void)addOperation:(VCResponseFetchAsyncService *)service
{
	[_networkOperationQueue addOperation:service];
	[self showNetworkActivityIndicator];
}

#pragma mark - Private Methods

- (void)showNetworkActivityIndicator
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	[self performSelector:@selector(hideNetworkActivityIndicatorIfRequired) withObject:nil afterDelay:1.0];
}

- (void)hideNetworkActivityIndicatorIfRequired
{
	if ([_networkOperationQueue operationCount] == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}else {
		[self performSelector:@selector(hideNetworkActivityIndicatorIfRequired) withObject:nil afterDelay:1.0];
	}
}

@end
