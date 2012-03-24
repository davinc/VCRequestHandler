//
//  VCResponseProcessor.h
//  VCRequestHandler
//
//  Created by Vinay Chavan on 24/03/12.
//  Copyright (c) 2012 Bytefeast. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VCResponseProcessor <NSObject>

@optional
- (void)willStartReceivingData;                          // To specify that download will start
- (void)didReceiveData:(NSData*)data;                    // To process any partial data.
- (void)didFinishReceivingData;                          // To notify that the receiving process is complete, whole data is now ready to be processed if necessary.
- (void)didFailReceivingDataWithError:(NSError *)error;  // To notify that download has failed

@end
