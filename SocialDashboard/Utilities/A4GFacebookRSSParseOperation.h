//
//  A4GFacebookRSSParseOperation.h
//  SocialDashboard
//
//  Created by Yudi Xue on 2012-10-20.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A4GFacebookRSSParseOperation : NSOperation {
    NSData *fbRSSData;
    
@private
    NSDateFormatter *dateFormatter;
    
    // these variables are used during parsing
    // Earthquake *currentEarthquakeObject;
    NSMutableArray *currentParseBatch;
    NSMutableString *currentParsedCharacterData;
    
    BOOL accumulatingParsedCharacterData;
    BOOL didAbortParsing;
    NSUInteger parsedCounter;
}
@property (copy, readonly) NSData *fbRSSData;

@end
