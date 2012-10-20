//
//  NSObject+A4G.h
//  Brandagram
//
//  Created by Dale Zak on 12-10-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (A4G)

- (void)performSelectorOnMainThread:(SEL)selector 
                      waitUntilDone:(BOOL)wait 
                        withObjects:(NSObject *)object, ... NS_REQUIRES_NIL_TERMINATION;

@end
