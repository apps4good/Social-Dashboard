//
//  A4GRSSEntry.h
//  SocialDashboard
//
//  Created by Yudi Xue on 2012-10-21.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A4GRSSEntry : NSObject {
@private
// Date and time at which the earthquake occurred.
NSDate *date;
// The application uses this URL to open that page in Safari.
NSURL *url;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSURL *url;
@end
