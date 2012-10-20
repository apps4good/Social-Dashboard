// ##########################################################################################
//
// Copyright (c) 2012, Apps4Good. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
//
// 1) Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
// 2) Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
// 3) Neither the name of the Apps4Good nor the names of its contributors may be used to
//    endorse or promote products derived from this software without specific prior written
//    permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
// SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
// OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
// TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// ##########################################################################################


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
    return [[A4GDownload alloc] initWithDelegate:delegate url:url];
}

- (id) initWithDelegate:(NSObject<A4GDownloadDelegate>*)delegate url:(NSString*)url {
    if ([super init]) {
        self.delegate = delegate;
        self.url = url;
    }
    return self;
}

- (void) parseWithDictionary:(NSString*)response {
    NSLog(@"%@ URL:%@", self.class, self.url);
}

- (void)start {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
        return;
    }
    NSLog(@"%@ URL:%@", self.class, self.url);
    
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
    NSLog(@"%@ URL:%@", self.class, self.url);
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];   
} 

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@ URL:%@", self.class, self.url);
    self.response = [NSMutableData data];
    [self.delegate performSelectorOnMainThread:@selector(download:connected:) 
                                 waitUntilDone:YES  
                                   withObjects:self, self.url, nil];   
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {       
    [self.response appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {  
    NSLog(@"%@ URL:%@ ERROR:%@", self.class, self.url, [error description]);
    [self.delegate performSelectorOnMainThread:@selector(download:finished:error:) 
                                 waitUntilDone:YES  
                                   withObjects:self, self.url, error, nil];
    [self finish];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%@ URL:%@", self.class, self.url);
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
