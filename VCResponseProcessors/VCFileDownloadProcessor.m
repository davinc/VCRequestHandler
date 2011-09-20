//
//  VCFileDownloadProcessor.m
//  VCResponseFetcherTest
//
//  Created by Vinay Chavan on 19/09/11.
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

#import "VCFileDownloadProcessor.h"


@implementation VCFileDownloadProcessor

@synthesize filePath = _filePath;

-(id)init
{
	self = [super init];
	if (self) {
		_filePath = nil;
		_outStream = nil;
	}
	return self;
}

-(void)dealloc
{
	[_filePath release], _filePath = nil;
	[_outStream release], _outStream = nil;
	[super dealloc];
}


#pragma mark - Public Method

- (void)didReceiveData:(NSData *)data
{
	if (self.filePath == nil) {
		return;
	}
	
	if (_outStream == nil) {
		_outStream = [[NSOutputStream alloc] initToFileAtPath:self.filePath append:NO];
		[_outStream open];
	}
	
	NSUInteger leftToWrite = [data length];
	NSUInteger written = 0;
	do {
		written = [_outStream write:[data bytes] maxLength:leftToWrite];
		if (written == -1) break;
		leftToWrite -= written;
	} while (leftToWrite > 0);
	
	if (leftToWrite) {
		NSLog(@"stream error: %@", [_outStream streamError]);
	}
}

- (void)didFinishReceivingData
{
	// Process received data
	if (_outStream) {
		[_outStream close];
		[_outStream release], _outStream = nil;
	}
}

@end
