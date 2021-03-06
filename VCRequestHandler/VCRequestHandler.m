//
//  VCRequestHandler.m
//  VCRequestHandler
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

#import "VCRequestHandler.h"

@interface VCRequestHandler()

- (void)addOperation:(VCRequest *)operation;
- (void)showNetworkActivityIndicator;
- (void)hideNetworkActivityIndicatorIfRequired;

@end

@implementation VCRequestHandler

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

+ (VCRequestHandler*)sharedInstance 
{
	static dispatch_once_t once;
    static VCRequestHandler *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
	
    return sharedInstance;
}


#pragma mark - Public

- (void)setMaxConcurrentRequestCount:(NSInteger)count
{
	[_networkOperationQueue setMaxConcurrentOperationCount:count];
}

- (void)requestWithRequest:(VCRequest *)request
{
	if (request) {
		[self addOperation:request];
	}
}


#pragma mark - Private

- (void)addOperation:(VCRequest *)operation
{
	__block typeof(self) handler = self;
	operation.completionBlock = ^{
		[handler hideNetworkActivityIndicatorIfRequired];
	};
	[_networkOperationQueue addOperation:operation];
	[self showNetworkActivityIndicator];
}

- (void)showNetworkActivityIndicator
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)hideNetworkActivityIndicatorIfRequired
{
	if ([_networkOperationQueue operationCount] == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}

@end
