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

#import <Foundation/Foundation.h>

@interface A4GSettings : NSObject

// Home Screen
+ (NSString *) homeScreenTitle;
+ (UIColor *) homeScreenBgColor;

// Social Icons
+ (UIImage *) emailIcon;
+ (UIImage *) phoneIcon;
+ (UIImage *) facebookIcon;
+ (UIImage *) twitterIcon;
+ (UIImage *) newsIcon;

// Social Links
+ (NSString *) emailInfo;
+ (NSString *) phoneNumner;
+ (NSString *) facebookPageLink;
+ (NSString *) twitterFeedLink;
+ (NSString *) newsRssFeedLink;

+ (NSString *) appName;
+ (NSString *) appText;
+ (NSString *) appURL;
+ (NSString *) appVersion;

+ (NSString *) aboutText;
+ (NSString *) aboutEmail;
+ (NSString *) aboutURL;

+ (UIColor *) navBarColor;
+ (UIColor *) toolBarColor;
+ (UIColor *) buttonDoneColor;

+ (UIColor *) tablePlainBackColor;
+ (UIColor *) tablePlainTextColor;

+ (UIColor *) tablePlainRowOddColor;
+ (UIColor *) tablePlainRowEvenColor;

+ (UIColor *) tablePlainHeaderBackColor;
+ (UIColor *) tablePlainHeaderTextColor;

+ (UIColor *) tableGroupedBackColor;
+ (UIColor *) tableGroupedTextColor;

+ (UIColor *) tableGroupedHeaderTextColor;

+ (NSArray *) kmlFiles;

@end
