//
//  VCFormDataService.m
//  VCRequestHandler
//
//  Created by Vinay Chavan on 15/07/14.
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

#import "VCFormDataService.h"

@interface VCFormDataService ()
{
	NSString * _boundary;
}
@end

@implementation VCFormDataService

- (id)init
{
	self = [super init];
	if (self) {
		_boundary = [self formDataBoundary];
	}
	return self;
}

- (id)initWithFormData:(NSDictionary *)aFormData
{
	self = [self init];
	if (self) {
		_formData = [aFormData retain];
	}
	return self;
}

- (void)dealloc
{
	[_boundary release], _boundary = nil;
	[_formData release], _formData = nil;
	[super dealloc];
}

- (NSString *)formDataBoundary
{
	return @"----WebKitFormBoundaryp7MA4YWxkTrZu0gW";
}


#pragma mark - VCDataService Overloading

- (NSDictionary *)allHTTPHeaderFields
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"gzip", @"Accept-Encoding",
			[NSString stringWithFormat:@"multipart/form-data; boundary=%@", _boundary], @"Content-Type",
			nil];
}

- (NSData *)body
{
	if (_formData == nil) return nil;
	
	NSMutableData *data = [[NSMutableData alloc] init];
	
	NSArray *keys = [_formData allKeys];
	for (NSString *key in keys) {
		id value = [_formData objectForKey:key];
		
		[data appendData:[self dataWithKey:key value:value]];
	}
	
	[data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	return [data autorelease];
}

- (NSData *)dataWithKey:(NSString *)key value:(NSString *)value
{
	return [[NSString stringWithFormat:@"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@",
			 _boundary, key, value]
			dataUsingEncoding:NSUTF8StringEncoding];
}

@end
