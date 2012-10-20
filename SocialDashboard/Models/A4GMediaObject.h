//
//  A4GMediaObject.h
//  SocialDashboard
//
//  Created by Alan Yeung on 2012-10-20.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import <Foundation/Foundation.h>

enum SocialMediaType
{
    SMTPhone,
    SMTEmail ,
    SMTFacebook,
    SMTTwitter ,
    SMTNewsRSS ,
};


@interface A4GMediaObject : NSObject

@property (nonatomic, strong) NSString* iconImgName;
@property (nonatomic, strong) NSString* info;
@property (nonatomic, assign) enum SocialMediaType type;

@end
