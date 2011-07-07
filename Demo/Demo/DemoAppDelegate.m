//
//  DemoAppDelegate.m
//  Demo
//
//  Created by Vinay Chavan on 15/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DemoAppDelegate.h"

#import "VCDataResponseProcessor.h"
#import "VCImageResponseProcessor.h"

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
	
	[[VCResponseFetcher sharedInstance] addObserver:self
												url:@"http://www.google.com"
											  cache:VCResponseFetchNoCache
								  responseProcessor:[[[VCDataResponseProcessor alloc] init] autorelease]];
}

- (IBAction)didTapGetImageResponseButton:(UIButton*)sender {
	self.responseImageView.image = nil;
	
	NSString *url = nil;
	switch (sender.tag) {
		case 0:
			url = [NSString stringWithString:@"http://images.apple.com/home/images/promo_ios5.png"];
			break;
		case 1:
			url = [NSString stringWithString:@"http://images.apple.com/home/images/promo_lion.png"];
			break;
	}
	
	[[VCResponseFetcher sharedInstance] addObserver:self 
												url:url
											  cache:VCResponseFetchRemoteIfNoCache
								  responseProcessor:[[[VCImageResponseProcessor alloc] init] autorelease]];
}




#pragma mark - VCResponseFetchServiceDelegate Methods

-(void)didSucceedReceiveResponse:(NSObject<VCDataProcessorDelegate> *)response {
	
	if ([response isKindOfClass:[VCDataResponseProcessor class]] ) {
		self.responseTextView.textColor = [UIColor blackColor];
		VCDataResponseProcessor *processor = (VCDataResponseProcessor*)response;
		NSString *stringResponse = [[NSString alloc] initWithData:processor.data encoding:NSUTF8StringEncoding];
		self.responseTextView.text = stringResponse;
		[stringResponse release];
	}
	else if([response isKindOfClass:[VCImageResponseProcessor class]]) {
		VCImageResponseProcessor *processor = (VCImageResponseProcessor *)response;
		self.responseImageView.image = processor.image;
	}
}

-(void)didFailReceiveResponse:(NSObject<VCDataProcessorDelegate> *)response {
	self.responseTextView.textColor = [UIColor redColor];

	self.responseTextView.text = [NSString stringWithFormat:@"%@", [[response error]localizedDescription]];
}

@end
