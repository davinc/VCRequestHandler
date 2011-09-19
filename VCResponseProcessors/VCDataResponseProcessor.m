//
//  VCDataResponseProcessor.m
//  VCResponseFetcherTest
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

#import "VCDataResponseProcessor.h"


@implementation VCDataResponseProcessor

@synthesize data = _data, error = _error, tag;

-(id)init
{
	self = [super init];
	if (self) {
		_data = nil;
		_error = nil;
	}
	return self;
}

-(void)dealloc
{
	[_data release], _data = nil;
	[_error release], _error = nil;
	[super dealloc];
}

#pragma mark - Public Method

- (void)didReceiveData:(NSData*)data
{
	if (_data == nil) {
		_data = [[NSMutableData alloc] init];
	}
	
	[_data appendData:data];
}

- (void)didFinishReceivingData
{
	// Process received data
}

@end
