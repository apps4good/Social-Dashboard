//
//  A4GDownload.m
//  Brandagram
//
//  Created by Dale Zak on 12-10-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "A4GDownload.h"
#import "SBJson.h"
#import "NSError+A4G.h"
#import "NSString+A4G.h"
#import "NSObject+A4G.h"

@interface A4GDownload ()

@property (nonatomic, strong, readwrite) NSObject<A4GDownloadDelegate> *delegate;

@property (nonatomic, strong) NSMutableData *response;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSString *url;

@end

@implementation A4GDownload

@synthesize delegate = _delegate;
@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;
@synthesize url = _url;
@synthesize connection = _connection;
@synthesize response = _response;

+ (id) downloadWithDelegate:(NSObject<A4GDownloadDelegate>*)delegate url:(NSString*)url {
    return [[[A4GDownload alloc] initWithDelegate:delegate url:url] autorelease];
}

- (id) initWithDelegate:(NSObject<A4GDownloadDelegate>*)delegate url:(NSString*)url {
    if ([super init]) {
        self.delegate = delegate;
        self.url = url;
    }
    return self;
}

- (void)dealloc {
    DLog(@"%@ URL:%@", self.class, self.url);
    [_url release];
    [_connection release];
    [_response release];
    [super dealloc];
}

- (void) parseWithDictionary:(NSString*)response {
    DLog(@"%@ URL:%@", self.class, self.url);
}

- (void)start {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
        return;
    }
    DLog(@"%@ URL:%@", self.class, self.url);
    
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self.delegate performSelectorOnMainThread:@selector(download:started:) 
                                 waitUntilDone:YES  
                                   withObjects:self, self.url, nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) finish {
    DLog(@"%@ URL:%@", self.class, self.url);
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];   
} 

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    DLog(@"%@ URL:%@", self.class, self.url);
    self.response = [NSMutableData data];
    [self.delegate performSelectorOnMainThread:@selector(download:connected:) 
                                 waitUntilDone:YES  
                                   withObjects:self, self.url, nil];   
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {       
    [self.response appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {  
    DLog(@"%@ URL:%@ ERROR:%@", self.class, self.url, [error description]);
    [self.delegate performSelectorOnMainThread:@selector(download:finished:error:) 
                                 waitUntilDone:YES  
                                   withObjects:self, self.url, error, nil];
    [self finish];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    DLog(@"%@ URL:%@", self.class, self.url);
    NSString *string = [NSString utf8StringFromData:self.response];
    NSError *error = nil;
    if (string != nil && string.length > 0) {
        NSDictionary *json = [string JSONValue];
        if (json != nil) {
            [self parseWithDictionary:json];
        }
        else {
            error = [NSError errorWithDomain:self.url code:NSURLErrorCannotParseResponse message:@"JSON is NULL"];
        }   
    }
    else {
        error = [NSError errorWithDomain:self.url code:NSURLErrorBadServerResponse message:@"Response is NULL"];
    }
    [self.delegate performSelectorOnMainThread:@selector(download:finished:error:) 
                                 waitUntilDone:YES  
                                   withObjects:self, self.url, error, nil];
    [self finish];
}

@end
