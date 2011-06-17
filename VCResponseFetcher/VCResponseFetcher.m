//
//  VCResponseFetcher.m
//  Demo
//
//  Created by Vinay Chavan on 15/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCResponseFetcher.h"


@implementation VCResponseFetcher

- (id)init 
{
	self = [super init];
	if (self) 
	{
		_operationQueue = [[NSOperationQueue alloc] init];
	}
	return self;
}

- (void)dealloc 
{
	[_operationQueue release], _operationQueue = nil;
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

- (void)addObserver:(NSObject<VCResponseFetchServiceDelegate>*)observer
				url:(NSString*)url
	responseOfClass:(Class)respose 
{
	[self removeObserver:observer];
	
	VCResponseFetchService *operation = [[[VCResponseFetchService alloc] init] autorelease];
	operation.delegate = observer;
	operation.url = url;
	operation.responseProcessor = [[[respose alloc] init] autorelease];
	operation.cachingType = VCResponseFetchNoCache;
	
	[_operationQueue addOperation:operation];
}

- (void)removeObserver:(NSObject<VCResponseFetchServiceDelegate>*)observer 
{
	for (VCResponseFetchService *operation in [_operationQueue operations]) {
		if (operation.delegate == observer) {
			[operation cancel];
		}
	}
}

@end
