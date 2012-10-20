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

#import "A4GSettings.h"
#import "UIColor+A4G.h"

@interface A4GSettings ()

+ (NSString*) stringFromBundleForKey:(NSString *)key;
+ (BOOL) boolFromBundleForKey:(NSString *)key;
+ (UIColor*) colorFromBundleForKey:(NSString *)key;
+ (NSDictionary*) dictionaryFromBundleForKey:(NSString *)key;
+ (NSArray*) arrayFromBundleForKey:(NSString *)key;

+ (BOOL) boolFromDefaultsForKey:(NSString*)key defaultValue:(BOOL)value;
+ (NSString*) stringFromDefaultsForKey:(NSString*)key defaultValue:(NSString*)value;
+ (NSInteger) integerFromDefaultsForKey:(NSString*)key defaultValue:(NSInteger)value;
+ (NSDate*) dateFromDefaultsForKey:(NSString*)key defaultValue:(NSDate*)value;

+ (void) setBool:(BOOL)boolean forKey:(NSString*)key;
+ (void) setString:(NSString*)string forKey:(NSString*)key;
+ (void) setInteger:(NSInteger)value forKey:(NSString*)key;
+ (void) setDate:(NSDate*)date forKey:(NSString*)key;

@end

@implementation A4GSettings

+ (NSString *) homeScreenTitle {
    return [A4GSettings stringFromBundleForKey: @"A4GHomeScreen"];
}

+ (NSArray *) kmlFiles {
    return [[NSBundle mainBundle] pathsForResourcesOfType:@"kml" inDirectory:nil];
}

+ (NSString *)appName {
    return [A4GSettings stringFromBundleForKey:@"CFBundleName"]; 
}

+ (NSString *)appText {
    return [A4GSettings stringFromBundleForKey:@"A4GAppText"]; 
}

+ (NSString *)appURL {
    return [A4GSettings stringFromBundleForKey:@"A4GAppURL"]; 
}

+ (NSString *) appVersion {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+(NSString *) aboutText {
    return [A4GSettings stringFromBundleForKey:@"A4GAboutText"]; 
}

+(NSString *) aboutURL {
    return [A4GSettings stringFromBundleForKey:@"A4GAboutURL"]; 
}

+(NSString *) aboutEmail {
    return [A4GSettings stringFromBundleForKey:@"A4GAboutEmail"]; 
}

+ (UIColor *) navBarColor {
    return [A4GSettings colorFromBundleForKey:@"A4GNavBarColor"];
}

+ (UIColor *) buttonDoneColor {
    return [A4GSettings colorFromBundleForKey:@"A4GButtonDoneColor"];
}

+ (UIColor *) tablePlainBackColor {
    return [A4GSettings colorFromBundleForKey:@"A4GTablePlainBackColor"];
}

+ (UIColor *) tablePlainTextColor {
    return [A4GSettings colorFromBundleForKey:@"A4GTablePlainTextColor"];
}

+ (UIColor *) tablePlainRowOddColor {
    return [A4GSettings colorFromBundleForKey:@"A4GTablePlainRowOddColor"];
}

+ (UIColor *) tablePlainRowEvenColor {
    return [A4GSettings colorFromBundleForKey:@"A4GTablePlainRowEvenColor"];
}

+ (UIColor *) tablePlainHeaderBackColor {
    return [A4GSettings colorFromBundleForKey:@"A4GTablePlainHeaderBackColor"];
}

+ (UIColor *) tablePlainHeaderTextColor {
    return [A4GSettings colorFromBundleForKey:@"A4GTablePlainHeaderTextColor"];
}

+ (UIColor *) tableGroupedBackColor {
    return [A4GSettings colorFromBundleForKey:@"A4GTableGroupedBackColor"];
}

+ (UIColor *) tableGroupedTextColor {
    return [A4GSettings colorFromBundleForKey:@"A4GTableGroupedTextColor"];
}

+ (UIColor *) tableGroupedHeaderTextColor {
    return [A4GSettings colorFromBundleForKey:@"A4GTableGroupedHeaderTextColor"];
}

#pragma mark - Helpers

+ (NSString*) stringFromBundleForKey:(NSString *)key {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:key];
}

+ (BOOL) boolFromBundleForKey:(NSString *)key {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSNumber *number = [infoDictionary objectForKey:key];
    return [number boolValue];
}

+ (UIColor*) colorFromBundleForKey:(NSString *)key {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [UIColor colorFromHexString:[infoDictionary objectForKey:key]];
}

+ (NSDictionary*) dictionaryFromBundleForKey:(NSString *)key {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return (NSDictionary *)[infoDictionary objectForKey:key];
}

+ (NSArray*) arrayFromBundleForKey:(NSString *)key {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return (NSArray *)[infoDictionary objectForKey:key];
}

+ (BOOL) boolFromDefaultsForKey:(NSString*)key defaultValue:(BOOL)value {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] != nil
    ? [[NSUserDefaults standardUserDefaults] boolForKey:key] : value;
}

+ (NSString*) stringFromDefaultsForKey:(NSString*)key defaultValue:(NSString*)value {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] != nil
    ? [[NSUserDefaults standardUserDefaults] stringForKey:key] : value;
}

+ (NSDate*) dateFromDefaultsForKey:(NSString*)key defaultValue:(NSDate*)value {
    NSString *dateString = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (dateString != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
        NSDate *date = [formatter dateFromString:dateString];
        return date;
    }
    return value;
}

+ (void) setDate:(NSDate*)date forKey:(NSString*)key {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"]; 
    NSString *dateString = [formatter stringFromDate:date];
    [[NSUserDefaults standardUserDefaults] setValue:dateString forKey:key];
}

+ (void) setBool:(BOOL)boolean forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setBool:boolean forKey:key];
}

+ (void) setString:(NSString*)string forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:key];
}

+ (void) setInteger:(NSInteger)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
}

+ (NSInteger) integerFromDefaultsForKey:(NSString*)key defaultValue:(NSInteger)value {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] != nil
    ? [[NSUserDefaults standardUserDefaults] integerForKey:key] : value;
}

@end
