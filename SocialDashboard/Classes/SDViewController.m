//
//  SDViewController.m
//  SocialDashboard
//
//  Created by Alan Yeung on 2012-10-20.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import "SDViewController.h"
#import "A4GMediaObject.h"
#import "A4GFeedTableViewController.h"
#import "A4GFacebookPageViewController.h"

@interface SDViewController ()
{
    NSMutableArray *arrayOfMedia;
}
@end

@implementation SDViewController

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

    NSLog(@"%d", arrayOfMedia.count);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // intialize all the objects from plist
    [self setup];
    
	// Do any additional setup after loading the view, typically from a nib.
    // Register the nib
    static NSString *myReuseIdentifier = @"A4GHomeScreenCellIdentifier";
    UINib *cellNib = [UINib nibWithNibName:@"A4GHomeScreenCell" bundle:nil];
    [mainTableView registerNib:cellNib forCellReuseIdentifier:myReuseIdentifier];
    
    [mainTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    [mainTableView setBounces: NO];

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
    return ceilf([arrayOfMedia count]/3.0);
}

- (A4GMediaObject*) mediaAtIndex:(int)index
{
    A4GMediaObject* media = nil;
    
    if (index < [arrayOfMedia count])
    {
        media = [arrayOfMedia objectAtIndex: index];
    }
    
    return media;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"A4GHomeScreenCellIdentifier";
    A4GHomeScreenCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    A4GMediaObject *media = nil;
    
    //configure cell
    cell.buttonA.tag = (indexPath.row * 3) + 1;
    cell.buttonB.tag = (indexPath.row * 3) + 2;
    cell.buttonC.tag = (indexPath.row * 3) + 3;

    media = [self mediaAtIndex: cell.buttonA.tag-1];
    [cell.buttonA setBackgroundImage: media.iconImg forState: UIControlStateNormal];
    [cell.buttonA setBackgroundImage: media.iconImg forState: UIControlStateHighlighted];
    
    media = [self mediaAtIndex: cell.buttonB.tag-1];
    [cell.buttonB setBackgroundImage: media.iconImg forState: UIControlStateNormal];
    [cell.buttonB setBackgroundImage: media.iconImg forState: UIControlStateHighlighted];

    media = [self mediaAtIndex: cell.buttonC.tag-1];
    [cell.buttonC setBackgroundImage: media.iconImg forState: UIControlStateNormal];
    [cell.buttonC setBackgroundImage: media.iconImg forState: UIControlStateHighlighted];

    if (indexPath.row == ceilf([arrayOfMedia count] / 3.0) - 1)
    {
        switch ([arrayOfMedia count] % 3)
        {
            case 2:
                cell.buttonC.alpha = 0;
                break;
            case 1:
                cell.buttonB.alpha = 0;
                cell.buttonC.alpha = 0;
                break;
            case 0:
            default:
                break;
        }
    }
    return cell;
}
#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
}

#pragma mark - A4GHomeScreenCellDelegate
-(void)openMediaAtIndex:(int)index
{
    // open media view
    A4GMediaObject *media = [arrayOfMedia objectAtIndex: index];

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
