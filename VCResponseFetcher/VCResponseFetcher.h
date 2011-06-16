//
//  VCResponseFetcher.h
//  Demo
//
//  Created by Vinay Chavan on 15/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Main Service
#import "VCResponseFetchService.h"
#import "VCDataProcessorDelegate.h"
#import "VCResponseFetchServiceDelegate.h"

// Devived Classes
#import "VCDataResponseProcessor.h"
#import "VCImageResponseProcessor.h"

@interface VCResponseFetcher : NSObject {
@private
    NSOperationQueue *_operationQueue;
}

+(VCResponseFetcher*)sharedInstance;

- (void)addObserver:(NSObject<VCResponseFetchServiceDelegate>*)observer
				url:(NSString*)url
	responseOfClass:(Class)respose;

@end
