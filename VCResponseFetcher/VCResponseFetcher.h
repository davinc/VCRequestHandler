//
//  VCResponseFetcher.h
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

#import <Foundation/Foundation.h>

// Main Service
#import "VCResponseFetchAsyncService.h"
#import "VCResponseFetchServiceDelegate.h"
#import "VCDataResponseProcessor.h"

@interface VCResponseFetcher : NSObject {
@private
    NSOperationQueue *_networkOperationQueue;
}

+(VCResponseFetcher*)sharedInstance;

- (VCResponseFetchAsyncService *)addObserver:(NSObject<VCResponseFetchServiceDelegate> *)observer
										 url:(NSString *)url
									   cache:(NSURLRequestCachePolicy)cache
						   responseProcessor:(VCDataResponseProcessor *)processor;

- (VCResponseFetchAsyncService *)addObserver:(NSObject<VCResponseFetchServiceDelegate> *)observer
									  method:(NSString *)method
										 url:(NSString *)url
							 allHeaderFields:(NSDictionary *)allHeaderFields
										body:(NSData *)body
									   cache:(NSURLRequestCachePolicy)cache
						   responseProcessor:(VCDataResponseProcessor *)processor;

@end
