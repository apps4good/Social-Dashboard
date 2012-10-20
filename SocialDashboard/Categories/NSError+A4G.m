//
//  NSError+A4G.m
//  Brandagram
//
//  Created by Dale Zak on 12-10-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSError+A4G.h"

@implementation NSError (A4G)

+ (NSError *) errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message {
	return [NSError errorWithDomain:domain 
                               code:code 
                           userInfo:[NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey]];	
}

@end
