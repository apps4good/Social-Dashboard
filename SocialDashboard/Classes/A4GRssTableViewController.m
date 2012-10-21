//
//  A4GRssTableViewController.m
//  SocialDashboard
//
//  Created by Dan Merino on 10/21/12.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import "A4GRssTableViewController.h"
#import "A4GFacebookRSSParseOperation.h"
#import "A4GRSSEntry.h"

@interface A4GRssTableViewController ()
{
    NSMutableArray *arrayOfRssFeeds;
    
    // for downloading the xml data
    NSURLConnection *rssFeedConnection;
    NSMutableData *rssData;
}
@end

@implementation A4GRssTableViewController


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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *feedURLString = [A4GSettings newsRssFeedLink];
    NSLog(@"URL being used %@", feedURLString);
    NSMutableURLRequest *rssURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:feedURLString]];
    rssFeedConnection = [[NSURLConnection alloc] initWithRequest:rssURLRequest delegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addRssEntries:)
                                                 name:kAddFacebookEntryNotif
                                               object:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier];
    }
    
    // Configure the cell...
    A4GRSSEntry *entry = [arrayOfRssFeeds objectAtIndex: indexPath.row];
    


    cell.textLabel.text = entry.title;

    
    cell.detailTextLabel.text =  entry.author;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
    return arrayOfRssFeeds.count;
}


#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

// Our NSNotification callback from the running NSOperation to add the earthquakes
//

- (void)addRssEntries:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    NSLog(@"Addeded a new RSS entry");
    [self addRssEntryToList:[[notif userInfo] valueForKey:kFacebookResultsKey]];
}

// Our NSNotification callback from the running NSOperation when a parsing error has occurred
//
- (void)earthquakesError:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    [self handleError:[[notif userInfo] valueForKey:kFacebookMsgErrorKey]];
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
    
    [rssFeedConnection cancel];
    rssFeedConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    A4GFacebookRSSParseOperation *parseOperation = [[A4GFacebookRSSParseOperation alloc] initWithData: rssData];
    
    NSOperationQueue *parseQueue = [NSOperationQueue new];
    [parseQueue addOperation: parseOperation];
    
    rssData = nil;
    rssFeedConnection = nil;
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

// The NSOperation "ParseOperation" calls addEarthquakes: via NSNotification, on the main thread
// which in turn calls this method, with batches of parsed objects.
// The batch size is set via the kSizeOfEarthquakeBatch constant.
//

- (void)addRssEntryToList:(NSArray *)entries
{
    arrayOfRssFeeds = [entries mutableCopy];
    [self.tableView reloadData];
    // insert the earthquakes into our rootViewController's data source (for KVO purposes)
    // [self.rootViewController insertEarthquakes:earthquakes];
}

@end

