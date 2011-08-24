//
//  CGResponseFetchService.h
//  VCResponseFetcherTest
//
//  Created by Vinay Chavan on 4/7/11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCResponseFetchServiceDelegate.h"
#import "VCDataProcessorDelegate.h"

@interface VCResponseFetchService : NSOperation {
	NSObject<VCResponseFetchServiceDelegate> *delegate;
	NSObject<VCDataProcessorDelegate> *responseProcessor;
	NSString *url;
	NSURLRequestCachePolicy cachePolicy;
	NSString *method;
	NSDictionary *allHTTPHeaderFields;
	NSData *body;

	BOOL executing;
	BOOL finished;
}

@property (nonatomic, assign) NSObject<VCResponseFetchServiceDelegate> *delegate;
@property (nonatomic, retain) NSObject<VCDataProcessorDelegate> *responseProcessor;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic, retain) NSDictionary *allHTTPHeaderFields;
@property (nonatomic, retain) NSData *body;
@property (nonatomic, retain) NSString *method;

@end
