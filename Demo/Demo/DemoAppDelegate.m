//
//  DemoAppDelegate.m
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

#import "DemoAppDelegate.h"

#import "VCDataResponseProcessor.h"
#import "VCImageResponseProcessor.h"
#import "VCFileDownloadProcessor.h"

@implementation DemoAppDelegate


@synthesize window=_window;
@synthesize responseTextView = _responseTextView;
@synthesize responseImageView = _responseImageView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override point for customization after application launch.
	[self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void)dealloc
{
	[_window release];
    [_responseTextView release];
    [_responseImageView release];
    [super dealloc];
}





#pragma mark - Action Methods

- (IBAction)didTapGetGoogleResponseButton:(id)sender {
	self.responseTextView.text = [NSString string];
	
	VCDataResponseProcessor *processor = [[[VCDataResponseProcessor alloc] init] autorelease];
	processor.tag = 1;
	[[VCResponseFetcher sharedInstance] addObserver:self
												url:@"http://www.google.com"
											  cache:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
								  responseProcessor:processor];
//	[[VCResponseFetcher sharedInstance] addObserver:self
//											 method:[NSString stringWithString:@"POST"] 
//												url:@"http://posttestserver.com/post.php"
//									allHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:@"UTF8", @"Content-Type", nil]
//											   body:[[NSString stringWithString:@"\r\nTESTING DATA\r\n"] dataUsingEncoding:NSUTF8StringEncoding]
//											  cache:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
//								  responseProcessor:processor];
}

- (IBAction)didTapGetImageResponseButton:(UIButton*)sender {
	self.responseImageView.image = nil;
		
	VCImageResponseProcessor *processor = [[[VCImageResponseProcessor alloc] init] autorelease];
	processor.tag = 2;
	[[VCResponseFetcher sharedInstance] addObserver:self 
												url:@"http://images.apple.com/home/images/promo_lion.png"
											  cache:NSURLRequestReturnCacheDataElseLoad
								  responseProcessor:processor];
}

- (IBAction)didTapDownloadFileButton:(id)sender {
	VCFileDownloadProcessor *processor = [[[VCFileDownloadProcessor alloc] init] autorelease];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	processor.filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"file.png"];
	
	[[VCResponseFetcher sharedInstance] addObserver:self
												url:@"http://f.cl.ly/items/341z2F3h2m1C0a0e291J/Beide.png"
											  cache:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
								  responseProcessor:processor];
}




#pragma mark - VCResponseFetchServiceDelegate Methods

-(void)didSucceedReceiveResponse:(VCDataResponseProcessor *)response {
	
	if (response.tag == 1 ) {
		self.responseTextView.textColor = [UIColor blackColor];
		VCDataResponseProcessor *processor = (VCDataResponseProcessor*)response;
		NSString *stringResponse = [[NSString alloc] initWithData:processor.data encoding:NSUTF8StringEncoding];
		self.responseTextView.text = stringResponse;
		[stringResponse release];
	}
	else if(response.tag == 2) {
		VCImageResponseProcessor *processor = (VCImageResponseProcessor *)response;
		self.responseImageView.image = processor.image;
	}
}

-(void)didFailReceiveResponse:(VCDataResponseProcessor *)response {
	self.responseTextView.textColor = [UIColor redColor];

	self.responseTextView.text = [NSString stringWithFormat:@"%@", [[response error]localizedDescription]];
}

@end
