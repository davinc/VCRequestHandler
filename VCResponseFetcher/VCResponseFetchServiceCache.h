//
//  VCResponseFetchServiceCache.h
//  Demo
//
//  Created by Vinay Chavan on 16/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum VCResponseFetchCaching {
	VCResponseFetchNoCache = 0,
	VCResponseFetchOnlyCache = 1,
	VCResponseFetchRemoteIfNoCache = 2,
};
typedef NSUInteger VCResponseFetchCaching;


@interface VCResponseFetchServiceCache : NSObject {
	NSMutableDictionary *memoryCache;
}

+ (VCResponseFetchServiceCache*)sharedCache;

- (BOOL)isCachedDataAvailableForUrl:(NSString*)url;

- (NSData*)cachedDataForUrl:(NSString*)url;

- (BOOL)saveData:(NSData*)data forUrl:(NSString*)url;

- (void)clearCache:(BOOL)fromDisk;

@end
