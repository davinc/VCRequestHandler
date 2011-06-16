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
#import "VCResponseFetchServiceCache.h"

@interface VCResponseFetchService : NSOperation {
	BOOL executing;
	BOOL finished;
}

@property (nonatomic, assign) NSObject<VCResponseFetchServiceDelegate> *delegate;
@property (nonatomic, retain) NSObject<VCDataProcessorDelegate> *responseProcessor;
@property (nonatomic, retain) NSString *url;

@property (nonatomic, assign) VCResponseFetchServiceCache *sharedCache;
@property (nonatomic, assign) VCResponseFetchCaching cachingType;

@end
