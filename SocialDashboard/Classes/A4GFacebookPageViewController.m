//
//  A4GFacebookPageViewController.m
//  SocialDashboard
//
//  Created by Alan Yeung on 2012-10-20.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import "A4GFacebookPageViewController.h"
#import "A4GFacebookRSSParseOperation.h"
#import "A4GRSSEntry.h"

@interface A4GFacebookPageViewController ()
{
    NSMutableArray *arrayOfFBFeeds;

    // for downloading the xml data
    NSURLConnection *facebookFeedConnection;
    NSMutableData *rssData;
}

@end

@implementation A4GFacebookPageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    static NSString *facebookURL = @"http://www.facebook.com/feeds/page.php?format=rss20&id=";
    NSString *feedURLString = [facebookURL stringByAppendingString: [A4GSettings facebookPageLink]];
    NSMutableURLRequest *earthquakeURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:feedURLString]];
    facebookFeedConnection = [[NSURLConnection alloc] initWithRequest:earthquakeURLRequest delegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addFacebookEntries:)
                                                 name:kAddFacebookEntryNotif
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return arrayOfFBFeeds.count;
}

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier];
    }
    
    // Configure the cell...
    A4GRSSEntry *entry = [arrayOfFBFeeds objectAtIndex: indexPath.row];
    
    if ([allTrim(entry.title) length] > 0)
    {
        cell.textLabel.text = entry.title;
    }
    else
    {
        cell.textLabel.text = [entry stringForDate];
    }
    
    cell.detailTextLabel.text = [entry stringDescriptionByStrippingHTMLForDetail];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    A4GRSSEntry *entry = [arrayOfFBFeeds objectAtIndex: indexPath.row];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    [viewController.view setFrame: [[UIScreen mainScreen] bounds]];
    [viewController.view setBackgroundColor: [UIColor whiteColor]];
    [viewController setTitle: entry.title];
    
    UITextView *textView = [[UITextView alloc] initWithFrame: CGRectInset(viewController.view.bounds, 20, 20)];
    [textView setText: entry.stringDescriptionByStrippingHTML];
    [textView setFont: [UIFont systemFontOfSize: 20]];
    [textView setEditable: NO];
    [viewController.view addSubview: textView];
    
    [self.navigationController pushViewController: viewController animated: YES];
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

// The following are delegate methods for NSURLConnection. Similar to callback functions, this is
// how the connection object, which is working in the background, can asynchronously communicate back
// to its delegate on the thread from which it was started - in this case, the main thread.
//
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // check for HTTP status code for proxy authentication failures
    // anything in the 200 to 299 range is considered successful,
    // also make sure the MIMEType is correct:
    //
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (([httpResponse statusCode]/100) == 2)
    {
        rssData = [NSMutableData new];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [rssData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([error code] == kCFURLErrorNotConnectedToInternet) {
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:
         NSLocalizedString(@"No Connection Error",
                           @"Error message displayed when not connected to the Internet.")
                                    forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                         code:kCFURLErrorNotConnectedToInternet
                                                     userInfo:userInfo];
        [self handleError:noConnectionError];
    }
    else
    {
        // otherwise handle the error generically
        [self handleError:error];
    }
    
    [facebookFeedConnection cancel];
    facebookFeedConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    A4GFacebookRSSParseOperation *parseOperation = [[A4GFacebookRSSParseOperation alloc] initWithData: rssData];
    
    NSOperationQueue *parseQueue = [NSOperationQueue new];
    [parseQueue addOperation: parseOperation];

    rssData = nil;
    facebookFeedConnection = nil;
}


- (void)handleError:(NSError *)error {
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:
     NSLocalizedString(@"Error Title",
                       @"Title for alert displayed when download or parse error occurs.")
                               message:errorMessage
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [alertView show];
}



- (void)addFacebookEntries:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    [self addFacebookEntryToList:[[notif userInfo] valueForKey:kFacebookResultsKey]];
}


- (void)earthquakesError:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    [self handleError:[[notif userInfo] valueForKey:kFacebookMsgErrorKey]];
}

- (void)addFacebookEntryToList:(NSArray *)entries
{
    arrayOfFBFeeds = [entries mutableCopy];
    [self.tableView reloadData];
}

@end
