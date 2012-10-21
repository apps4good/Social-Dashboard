//
//  A4GHomeScreenViewController.m
//  SocialDashboard
//
//  Created by Alan Yeung on 2012-10-21.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import "A4GHomeScreenViewController.h"
#import "A4GMediaObject.h"
#import "A4GFeedTableViewController.h"
#import "A4GFacebookPageViewController.h"
#import "A4GRssTableViewController.h"

@interface A4GHomeScreenViewController ()
{
    NSMutableArray *arrayOfMedia;
    UIScrollView *scrollView;
}
@end

#define kMaxColumnPortrait      3.0
#define kMaxColumnLandscape     5.0


@implementation A4GHomeScreenViewController

- (float) numOfColumnForInterfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        return kMaxColumnLandscape;
    }
    else
    {
        return kMaxColumnPortrait;
    }
}

- (void)setup
{
    // Check for Phone, Email, Facebook, Twitter, News RSS
    arrayOfMedia = [NSMutableArray new];
    
    A4GMediaObject *media;
    
    // Phone
    media = [[A4GMediaObject alloc] init];
    media.info = [A4GSettings phoneNumner];
    media.iconImg = [A4GSettings phoneIcon];
    media.type = SMTPhone;
    [arrayOfMedia addObject: media];
    
    // Email
    media = [[A4GMediaObject alloc] init];
    media.info = [A4GSettings emailInfo];
    media.iconImg = [A4GSettings emailIcon];
    media.type = SMTEmail;
    [arrayOfMedia addObject: media];
    
    // Facebook
    media = [[A4GMediaObject alloc] init];
    media.info = [A4GSettings facebookPageLink];
    media.iconImg = [A4GSettings facebookIcon];
    media.type = SMTFacebook;
    [arrayOfMedia addObject: media];
    
    // Twitter
    media = [[A4GMediaObject alloc] init];
    media.info = [A4GSettings twitterFeedLink];
    media.iconImg = [A4GSettings twitterIcon];
    media.type = SMTTwitter;
    [arrayOfMedia addObject: media];
    
    // News
    media = [[A4GMediaObject alloc] init];
    media.info = [A4GSettings newsRssFeedLink];
    media.iconImg = [A4GSettings newsIcon];
    media.type = SMTNewsRSS;
    [arrayOfMedia addObject: media];
}

- (void)loadIcons
{
    UIButton *button = nil;
    int count = 1;
    for (A4GMediaObject *media in arrayOfMedia)
    {
        button = [UIButton buttonWithType: UIButtonTypeCustom];
        [button setFrame: CGRectMake(0, 0, 60, 60)];
        [button setTag: count];
        [button setBackgroundImage: media.iconImg forState:UIControlStateNormal];
        [button setBackgroundImage: media.iconImg forState:UIControlStateHighlighted];
        [button addTarget: self action: @selector(openMedia:) forControlEvents: UIControlEventTouchUpInside];
        [scrollView addSubview: button];
        count++;
    }
    
}

- (void)layoutIcons
{
    float numOfIconPerColumn = [self numOfColumnForInterfaceOrientation];
    float numOfIconPerRow = ceilf((float) arrayOfMedia.count / numOfIconPerColumn);
    int curIconNum;
    UIButton *curButton;
    
    [scrollView setContentSize: CGSizeMake(CGRectGetWidth(self.view.bounds), numOfIconPerRow * 100)];
    
    float xOffset = scrollView.contentSize.width / numOfIconPerColumn;
    float yOffset = scrollView.contentSize.height / numOfIconPerRow;
    
    for (int row = 0;  row < numOfIconPerRow; row++)
    {
        for (int col = 0; col <numOfIconPerColumn; col++)
        {
            curIconNum = row * numOfIconPerColumn + col;
            if (curIconNum < arrayOfMedia.count)
            {
                curButton = [[scrollView subviews] objectAtIndex: curIconNum];
                [curButton setCenter: CGPointMake(xOffset/2+(col*xOffset), yOffset/2+(row*yOffset))];
            }
        }
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    scrollView = [[UIScrollView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    [scrollView setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview: scrollView];
    
    [scrollView setBackgroundColor: [A4GSettings homeScreenBgColor]];
    
    [self setup];
    [self loadIcons];
    [self layoutIcons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self layoutIcons];
}
#pragma mark - Controllers
-(void) openPhoneController:(A4GMediaObject *)mediaObject
{
    UIDevice *device = [UIDevice currentDevice];
    
    if ([[device model] isEqualToString:@"iPhone"] )
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", mediaObject.info]]];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) openEmailController:(A4GMediaObject *)mediaObject
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *shareMailView = [[MFMailComposeViewController alloc] init];
        [shareMailView setCcRecipients: [NSArray arrayWithObject: mediaObject.info]];
        [shareMailView setMailComposeDelegate: self];
        [self presentModalViewController: shareMailView animated: YES];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                        message:@"Require Mail Account"
                                                       delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) openFacebookController:(A4GMediaObject *)mediaObject
{
    NSLog(@"%s", __func__);
    A4GFacebookPageViewController *feedTableVC = [[A4GFacebookPageViewController alloc] initWithStyle: UITableViewStylePlain];
    feedTableVC.title = @"Facebook";
    [self.navigationController pushViewController: feedTableVC animated: YES];
}

-(void) openTwitterController:(A4GMediaObject *)mediaObject
{
    NSLog(@"%s", __func__);
    A4GFeedTableViewController *feedTableVC = [[A4GFeedTableViewController alloc] initWithStyle: UITableViewStylePlain];
    feedTableVC.title = @"Twitter";
    [self.navigationController pushViewController: feedTableVC animated: YES];
}

-(void) openNewsRSSController:(A4GMediaObject *)mediaObject
{
    NSLog(@"%s", __func__);
    A4GRssTableViewController *rssTableVC = [[A4GRssTableViewController alloc] initWithStyle: UITableViewStylePlain];
    rssTableVC.title = @"News";
    [self.navigationController pushViewController: rssTableVC animated: YES];
}

-(void)openMedia:(id)sender
{
    // open media view
    UIButton *button = (UIButton*)sender;
    A4GMediaObject *media = [arrayOfMedia objectAtIndex: button.tag-1];
    
    switch (media.type) {
        case SMTPhone:
            [self openPhoneController: media];
            break;
        case SMTEmail:
            [self openEmailController: media];
            break;
        case SMTFacebook:
            [self openFacebookController: media];
            break;
        case SMTTwitter:
            [self openTwitterController: media];
            break;
        case SMTNewsRSS:
            [self openNewsRSSController: media];
            break;
        default:
            break;
    }
}
#pragma mark - MFMailComposeViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	if ([error code] == MFMailComposeErrorCodeSendFailed)
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"Cannot sent the email message."
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
    
	if (result == MFMailComposeResultSent)
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success"
														message:@"Your message has been successfully sent."
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		
	}
	else if (result == MFMailComposeResultFailed)
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
														message:@"Your email has failed to sent."
													   delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[alert show];
	}
    
	[self dismissModalViewControllerAnimated: YES];
}

@end
