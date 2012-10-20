//
//  A4GDownload.h
//  Brandagram
//
//  Created by Dale Zak on 12-10-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol A4GDownloadDelegate;

@interface A4GDownload : NSOperation<NSURLConnectionDelegate>

@property (nonatomic, strong, readonly) NSObject<A4GDownloadDelegate> *delegate;
@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;

+ (id) downloadWithDelegate:(NSObject<A4GDownloadDelegate>*)delegate url:(NSString*)url;
- (id) initWithDelegate:(NSObject<A4GDownloadDelegate>*)delegate url:(NSString*)url;

- (void) parseWithDictionary:(NSDictionary*)json;

@end

@protocol A4GDownloadDelegate <NSObject>

@optional

- (void) download:(A4GDownload*)download started:(NSString*)url;
- (void) download:(A4GDownload*)download connected:(NSString*)url;
- (void) download:(A4GDownload*)download downloaded:(NSString*)url;
- (void) download:(A4GDownload*)download finished:(NSString*)url error:(NSError*)error;

@end
