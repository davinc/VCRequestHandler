//
//  VCDataService.h
//  VCRequestHandler
//
//  Created by Vinay Chavan on 4/7/11.
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

/*
 * For any custom implementation, extend this class and override any required methods.
 * 
 * Methods that can be extended at the moment,
 *
 * - (NSURL *)URL;
 * - (VCRequestMethod)method;
 * - (NSURLRequestCachePolicy)cachePolicy;
 * - (NSDictionary *)allHTTPHeaderFields;
 * - (NSData *)body;
 *
 * - (void)willStartReceivingData;
 * - (void)didReceiveData:(NSData*)data;
 * - (void)didFinishReceivingData;
 * - (void)didFailReceivingDataWithError:(NSError *)error;
 *
 */

#import <Foundation/Foundation.h>
#import "VCRequestSource.h"
#import "VCResponseProcessor.h"

@interface VCDataService : NSObject <VCRequestSource, VCResponseProcessor> {
	NSMutableData *_data;
	NSError *_error;
}

@property (nonatomic, readonly) NSData *data;        // Received data
@property (nonatomic, retain) NSError *error;        // error is nil if the request completes with success, else holds an error that occured during the process.

@end
