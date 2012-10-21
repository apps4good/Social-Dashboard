//
//  A4GFeedTableViewController.m
//  SocialDashboard
//
//  Created by Alan Yeung on 2012-10-20.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import "A4GFeedTableViewController.h"

@interface A4GFeedTableViewController ()
{
    NSMutableArray *tweetData;
    NSMutableArray *tweetUser;
    NSMutableArray *tweetUserUrl;
    dispatch_queue_t imageQueue;
}
@end



@implementation A4GFeedTableViewController


- (id)init
{
    if (self = [super init]) {
        imageQueue = dispatch_queue_create("com.company.app.imageQueue", NULL);
    }
    return self;
}


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
    
    tweetData    = [NSMutableArray new];
    tweetUser    = [NSMutableArray new];
    tweetUserUrl = [NSMutableArray new];
    
    NSString *twitterSearch = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@", [A4GSettings twitterFeedLink]];
    
    
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:twitterSearch] parameters:nil requestMethod:TWRequestMethodGET];
    

	
	// Perform the request created above and create a handler block to handle the response.
	[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
		NSString *output;
		
		if ([urlResponse statusCode] == 200) {
			// Parse the responseData, which we asked to be in JSON format for this request, into an NSDictionary using NSJSONSerialization.
			NSError *jsonParsingError = nil;
			NSDictionary *publicTimeline = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
			output = [NSString stringWithFormat:@"HTTP response status: %i\nPublic timeline:\n%@", [urlResponse statusCode], publicTimeline];
            NSArray *tweets = [publicTimeline objectForKey:@"results"];
            for (NSDictionary *tweet in tweets) {
                [tweetData    addObject:[tweet objectForKey:@"text"]];
                [tweetUser    addObject:[tweet objectForKey:@"from_user"]];
                [tweetUserUrl addObject:[tweet objectForKey:@"profile_image_url"]];
            }
		}
		else {
			output = [NSString stringWithFormat:@"HTTP response status: %i\n", [urlResponse statusCode]];
            NSLog(@"GOT FROM TWTITER STATUS CODE %@", output);
		}
        [self.tableView reloadData];
        
	}];
    
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
    return tweetData.count;
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
    
        NSString *tweet       = [tweetData    objectAtIndex:indexPath.row];
        NSString *user        = [tweetUser    objectAtIndex:indexPath.row];
        NSString *profileUrl  = [tweetUserUrl objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat: @"@%@", user];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.text =  [NSString stringWithFormat: @"%@", tweet];
    
        if (cell.imageView.image == nil)
        {
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //this will start the image loading in bg
            dispatch_async(concurrentQueue, ^{
                NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:profileUrl]];
                
                //this will set the image when loading is finished
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = [UIImage imageWithData:image];
//                    //
//                    dispatch_release(concurrentQueue);
                    [tableView reloadData];
                    
                });
            });
        }
    
        //cell.imageView =

    
    return cell;
}

#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
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

@end
