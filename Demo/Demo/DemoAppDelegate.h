//
//  DemoAppDelegate.h
//  Demo
//
//  Created by Vinay Chavan on 15/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VCResponseFetcher.h"

@interface DemoAppDelegate : NSObject <UIApplicationDelegate, VCResponseFetchServiceDelegate> {	
	UITextView *_responseTextView;
	UIImageView *_responseImageView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITextView *responseTextView;
@property (nonatomic, retain) IBOutlet UIImageView *responseImageView;

- (IBAction)didTapGetGoogleResponseButton:(id)sender;
- (IBAction)didTapGetImageResponseButton:(id)sender;
@end
