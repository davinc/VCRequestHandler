//
//  VCRequestSource.h
//  VCRequestHandler
//
//  Created by Vinay Chavan on 24/03/12.
//  Copyright (c) 2012 Bytefeast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	VCGETRequest,
	VCPOSTRequest
}VCRequestMethod;

@protocol VCRequestSource <NSObject>

@required
- (NSURL *)URL;
- (VCRequestMethod)method;

@optional
- (NSURLRequestCachePolicy)cachePolicy;
- (NSDictionary *)allHTTPHeaderFields;
- (NSData *)body;

@end
