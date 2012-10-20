//
//  SDViewController.m
//  SocialDashboard
//
//  Created by Alan Yeung on 2012-10-20.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import "SDViewController.h"
#import "A4GMediaObject.h"

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
    media.info = [A4GSettings stringFromBundleForKey: kPhoneNumber];
    media.type = SMTPhone;
    [arrayOfMedia addObject: media];

    // Email
    media = [[A4GMediaObject alloc] init];
    media.info = [A4GSettings stringFromBundleForKey: kEmailInfo];
    media.type = SMTEmail;
    [arrayOfMedia addObject: media];

    // Facebook
    media = [[A4GMediaObject alloc] init];
    media.info = [A4GSettings stringFromBundleForKey: kFacebookPage];
    media.type = SMTFacebook;
    [arrayOfMedia addObject: media];

    // Twitter
    media = [[A4GMediaObject alloc] init];
    media.info = [A4GSettings stringFromBundleForKey: kTwitterFeed];
    media.type = SMTTwitter;
    [arrayOfMedia addObject: media];

    // News
    media = [[A4GMediaObject alloc] init];
    media.info = [A4GSettings stringFromBundleForKey: kNewsRSSFeed];
    media.type = SMTNewsRSS;
    [arrayOfMedia addObject: media];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // intialize all the objects from plist
    [self setup];
    
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
