//
//  VCResponseFetchServiceCache.m
//  Demo
//
//  Created by Vinay Chavan on 16/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCResponseFetchServiceCache.h"

#import <CommonCrypto/CommonDigest.h>

@interface VCResponseFetchServiceCache()

- (NSString*)keyForUrl:(NSString*)urlString;
- (NSString*)cacheFolderPath;
- (NSString*)cachePathForFile:(NSString*)fileName;
- (NSString*)cachePathForUrl:(NSString*)url;

@end

@implementation VCResponseFetchServiceCache

- (id)init 
{
	self = [super init];
	if (self) 
	{
		memoryCache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc 
{
	[memoryCache release], memoryCache = nil;
	[super dealloc];
}

+ (VCResponseFetchServiceCache*)sharedCache
{
	static VCResponseFetchServiceCache* sharedCache = nil;
	if (sharedCache == nil) {
		sharedCache = [[VCResponseFetchServiceCache alloc] init];
	}
	return sharedCache;
}

#pragma mark - Private Methods

- (NSString*)keyForUrl:(NSString*)urlString
{
	NSData *urlData = [urlString dataUsingEncoding:NSUTF8StringEncoding];
	unsigned char result[20];
	CC_SHA1([urlData bytes], [urlData length], result);
	
	return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15],
			result[16], result[17], result[18], result[19]
			];
}

- (NSString*)cacheFolderPath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];	
}

- (NSString*)cachePathForFile:(NSString*)fileName 
{
	return [[self cacheFolderPath] stringByAppendingPathComponent:fileName];
}

- (NSString*)cachePathForUrl:(NSString*)url 
{
	return [self cachePathForFile:[self keyForUrl:url]];
}

#pragma mark - Public Methods

- (BOOL)isCachedDataAvailableForUrl:(NSString*)url 
{
	NSString* filePath = [self cachePathForUrl:url];
	NSFileManager* fm = [NSFileManager defaultManager];
	return [fm fileExistsAtPath:filePath];
}

- (NSData*)cachedDataForUrl:(NSString*)url 
{
	NSData *data = nil;
	NSString *key = [self keyForUrl:url];
	
	data = [memoryCache objectForKey:key];
	
	if (data == nil) {
		NSString* filePath = [self cachePathForUrl:url];
		NSFileManager* fm = [NSFileManager defaultManager];
		if ([fm fileExistsAtPath:filePath]) {		
			data = [NSData dataWithContentsOfFile:filePath];
			if ([memoryCache count] > 10) {
				[self clearCache:NO];
			}
			[memoryCache setObject:data forKey:key];			
		}
	}
	
	return data;
}

- (BOOL)saveData:(NSData*)data forUrl:(NSString*)url 
{
	NSString* filePath = [self cachePathForUrl:url];
	NSFileManager* fm = [NSFileManager defaultManager];
	
	return [fm createFileAtPath:filePath contents:data attributes:nil];
}

- (void)clearCache:(BOOL)fromDisk 
{
	[memoryCache removeAllObjects];
	
	if (fromDisk) {
		NSFileManager* fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:[self cacheFolderPath] error:nil];
	}
}

@end
