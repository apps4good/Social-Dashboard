//
//  NSObject+A4G.m
//  Brandagram
//
//  Created by Dale Zak on 12-10-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSObject+A4G.h"

@implementation NSObject (A4G)

-(void)performSelectorOnMainThread:(SEL)selector waitUntilDone:(BOOL)wait withObjects:(NSObject *)firstObject, ... {
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    if (signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        va_list args;
        va_start(args, firstObject);
        int index = 2;
        for (NSObject *object = firstObject; index < [signature numberOfArguments]; object = va_arg(args, NSObject*)) {
            if (object != [NSNull null]) {
                [invocation setArgument:&object atIndex:index];
            } 
            index++;
        }  
        va_end(args);
        [invocation retainArguments];
        [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];   
    }
}

@end
