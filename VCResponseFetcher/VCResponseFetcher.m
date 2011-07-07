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
		[_operationQueue setMaxConcurrentOperationCount:3];
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
			  cache:(VCResponseFetchCaching)cache
  responseProcessor:(NSObject<VCDataProcessorDelegate>*)processor
{	
	VCResponseFetchService *operation = [[[VCResponseFetchService alloc] init] autorelease];
	operation.delegate = observer;
	operation.url = url;
	operation.responseProcessor = processor;
	operation.cachingType = cache;
	
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
