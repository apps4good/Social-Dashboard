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

#import "A4GFacebookRSSParseOperation.h"
#import "A4GRSSEntry.h"

// NSNotification name for sending earthquake data back to the app delegate
NSString *kAddFacebookEntryNotif = @"AddEarthquakesNotif";

// NSNotification userInfo key for obtaining the earthquake data
NSString *kFacebookResultsKey = @"EarthquakeResultsKey";

// NSNotification name for reporting errors
NSString *kFacebookErrorNotif = @"EarthquakeErrorNotif";

// NSNotification userInfo key for obtaining the error message
NSString *kFacebookMsgErrorKey = @"EarthquakesMsgErrorKey";

@interface A4GFacebookRSSParseOperation () <NSXMLParserDelegate>
    @property (nonatomic, strong) A4GRSSEntry *currentEntryObject;
    @property (nonatomic, strong) NSMutableArray *currentParseBatch;
    @property (nonatomic, strong) NSMutableString *currentParsedCharacterData;
@end

@implementation A4GFacebookRSSParseOperation

@synthesize fbRSSData, currentEntryObject, currentParsedCharacterData, currentParseBatch;

- (id)initWithData:(NSData *)parseData
{
    if (self = [super init]) {
        fbRSSData = [parseData copy];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"ccc', 'dd' 'LLL' 'yyyy' 'HH':'mm':'ss' 'z:"];
    }
    return self;
}

- (void)addFacebookEntryToList:(NSArray *)entries {
    assert([NSThread isMainThread]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddFacebookEntryNotif
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:entries
                                                                                           forKey:kFacebookResultsKey]];
}

// the main function for this NSOperation, to start the parsing
- (void)main {
    self.currentParseBatch = [NSMutableArray array];
    self.currentParsedCharacterData = [NSMutableString string];
    
    // It's also possible to have NSXMLParser download the data, by passing it a URL, but this is
    // not desirable because it gives less control over the network, particularly in responding to
    // connection errors.
    //
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.fbRSSData];
    [parser setDelegate:self];
    [parser parse];
    
    // depending on the total number of earthquakes parsed, the last batch might not have been a
    // "full" batch, and thus not been part of the regular batch transfer. So, we check the count of
    // the array and, if necessary, send it to the main thread.
    //
    if ([self.currentParseBatch count] > 0) {
        [self performSelectorOnMainThread:@selector(addFacebookEntryToList:)
                               withObject:self.currentParseBatch
                            waitUntilDone:NO];
    }
    
    self.currentEntryObject = nil;
    self.currentParseBatch = nil;
    self.currentParsedCharacterData = nil;
}

#pragma mark -
#pragma mark Parser constants

// Limit the number of parsed earthquakes to 50
// (a given day may have more than 50 earthquakes around the world, so we only take the first 50)
//
static const const NSUInteger kMaximumNumberOfEarthquakesToParse = 50;

// When an Earthquake object has been fully constructed, it must be passed to the main thread and
// the table view in RootViewController must be reloaded to display it. It is not efficient to do
// this for every Earthquake object - the overhead in communicating between the threads and reloading
// the table exceed the benefit to the user. Instead, we pass the objects in batches, sized by the
// constant below. In your application, the optimal batch size will vary
// depending on the amount of data in the object and other factors, as appropriate.
//
static NSUInteger const kSizeOfEarthquakeBatch = 10;

// Reduce potential parsing errors by using string constants declared in a single place.
static NSString * const kEntryElementName = @"item";
static NSString * const kLinkElementName = @"link";
static NSString * const kAuthorElementName = @"author";
static NSString * const kTitleElementName = @"title";
static NSString * const kUpdatedElementName = @"pubDate";
static NSString * const kDescriptElementName = @"description";


#pragma mark -
#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict {
    // If the number of parsed earthquakes is greater than
    // kMaximumNumberOfEarthquakesToParse, abort the parse.
    //
    if (parsedCounter >= 21) {
        didAbortParsing = YES;
        [parser abortParsing];
    }
    if ([elementName isEqualToString:kEntryElementName]) {
        A4GRSSEntry *entry = [[A4GRSSEntry alloc] init];
        self.currentEntryObject = entry;
    } else {
        accumulatingParsedCharacterData = YES;
        // The mutable string needs to be reset to empty.
        [currentParsedCharacterData setString:@""];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kEntryElementName]) {
        [self.currentParseBatch addObject:self.currentEntryObject];
        parsedCounter++;
        if ([self.currentParseBatch count] >= kMaximumNumberOfEarthquakesToParse) {
            [self performSelectorOnMainThread:@selector(addFacebookEntryToList:)
                                   withObject:self.currentParseBatch
                                waitUntilDone:NO];
            self.currentParseBatch = [NSMutableArray array];
        }
    } else if ([elementName isEqualToString:kTitleElementName]) {
        self.currentEntryObject.title = [self.currentParsedCharacterData copy];
    }
    else if ([elementName isEqualToString:kUpdatedElementName]) {
        if (self.currentEntryObject != nil) {
            self.currentEntryObject.date =
            [dateFormatter dateFromString:self.currentParsedCharacterData];
        }
        else {
            // fail gracefully
            
            // kUpdatedElementName can be found outside an entry element (i.e. in the XML header)
            // so don't process it here.
        }
    } else if ([elementName isEqualToString:kAuthorElementName]) {
        self.currentEntryObject.author = [self.currentParsedCharacterData copy];
        
    } else if ([elementName isEqualToString:kLinkElementName]) {
        self.currentEntryObject.url = [NSURL URLWithString:self.currentParsedCharacterData];
    }
    else if ([elementName isEqualToString:kDescriptElementName]) {
        self.currentEntryObject.description = [self.currentParsedCharacterData copy];
    }
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;
}

// This method is called by the parser when it find parsed character data ("PCDATA") in an element.
// The parser is not guaranteed to deliver all of the parsed character data for an element in a single
// invocation, so it is necessary to accumulate character data until the end of the element is reached.
//
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        //
        [self.currentParsedCharacterData appendString:string];
    }
}

// an error occurred while parsing the earthquake data,
// post the error as an NSNotification to our app delegate.
//
- (void)handleEarthquakesError:(NSError *)parseError {
    [[NSNotificationCenter defaultCenter] postNotificationName:kFacebookErrorNotif
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:parseError
                                                                                           forKey:kFacebookMsgErrorKey]];
}

// an error occurred while parsing the earthquake data,
// pass the error to the main thread for handling.
// (note: don't report an error if we aborted the parse due to a max limit of earthquakes)
//
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if ([parseError code] != NSXMLParserDelegateAbortedParseError && !didAbortParsing)
    {
        [self performSelectorOnMainThread:@selector(handleEarthquakesError:)
                               withObject:parseError
                            waitUntilDone:NO];
    }
}

@end
