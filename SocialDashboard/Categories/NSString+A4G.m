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

#import "NSString+A4G.h"

@implementation NSString (A4G)

+ (NSString *) utf8StringFromData:(NSData*)data {
    if (data != nil && data.length > 0) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (BOOL) isNilOrEmpty:(NSString *)string {
	return string == nil || [[string  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}

+ (BOOL) isPhoneNumber:(NSString *)string {
    NSString *regex = @"[\\d() -]+"; 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; 
    return [predicate evaluateWithObject:string];    
}

+ (BOOL) isEmailAddress:(NSString *)string {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; 
    return [predicate evaluateWithObject:string];    
}

+ (BOOL) isWebURL:(NSString *)string {
    NSString *regex = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?"; 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; 
    return [predicate evaluateWithObject:string]; 
}

+ (BOOL) isPhotoURL:(NSString *)string {
    if ([NSString isWebURL:string]) {
        for (NSString *extension in [NSArray arrayWithObjects:@".jpg", @".png", @".gif", nil]) {
            if ([[string lowercaseString] hasSuffix:extension]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (BOOL) isTwitterURL:(NSString *)string {
    if ([NSString isWebURL:string]) {
        if ([string hasPrefix:@"http://twitter.com"] || [string hasPrefix:@"https://twitter.com"]) {
            return YES;
        }
    }
    if ([string hasPrefix:@"@"]) {
        return YES;
    }
    return NO;
}

- (NSString *) stringWithNumbersOnly {
    NSCharacterSet *characteterToRemove = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[self componentsSeparatedByCharactersInSet:characteterToRemove] componentsJoinedByString:@""];
}

- (NSString *) stringWithLettersOnly {
    NSCharacterSet *characteterToRemove = [[NSCharacterSet letterCharacterSet] invertedSet];
    return [[self componentsSeparatedByCharactersInSet:characteterToRemove] componentsJoinedByString:@""];
}

- (NSString *) removeTwitterURL {
    NSMutableString *tweet = [NSMutableString string];
    for (NSString *prefix in [NSArray arrayWithObjects:@"http://twitter.com/", @"https://twitter.com/", @"http://www.twitter.com/", nil]) {
        if ([self hasPrefix:prefix]) {
            [tweet appendFormat:@"%@ ", [self stringByReplacingOccurrencesOfString:prefix withString:@"@"]];
        }
    }
    return tweet;
}

- (NSString *)makePretty {
    NSString *original = [[self stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    @try {
        NSMutableString *pretty = [NSMutableString stringWithCapacity:original.length];
        for (NSString *word in [original componentsSeparatedByString:@" "]) {
            if (pretty.length > 0) {
                [pretty appendString:@" "];
            }
            if (word.length > 1) {
                [pretty appendString:[word stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[word substringToIndex:1] capitalizedString]]];    
            }
            else {
                [pretty appendString:[word capitalizedString]];
            }
        }
        return pretty;   
    }
    @catch (NSException *exception) {
        return original;
    }
}

@end
