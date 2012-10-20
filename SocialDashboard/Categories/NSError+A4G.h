//
//  NSError+A4G.h
//  Brandagram
//
//  Created by Dale Zak on 12-10-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (A4G)

+ (NSError *) errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message;

@end
