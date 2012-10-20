//
//  SDViewController.m
//  SocialDashboard
//
//  Created by Alan Yeung on 2012-10-20.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import "SDViewController.h"
#import "A4GMediaObject.h"
#import "A4GHomeScreenCell.h"

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
//    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    A4GMediaObject *media = nil;
    
    //configure cell
    cell.buttonA.tag = (indexPath.row * 3) + 1;
    cell.buttonB.tag = (indexPath.row * 3) + 2;
    cell.buttonC.tag = (indexPath.row * 3) + 3;

    media = [self mediaAtIndex: cell.buttonA.tag-1];
    cell.buttonA.backgroundColor = [UIColor greenColor];
    
    media = [self mediaAtIndex: cell.buttonB.tag-1];
    cell.buttonB.backgroundColor = [UIColor greenColor];

    media = [self mediaAtIndex: cell.buttonC.tag-1];
    cell.buttonC.backgroundColor = [UIColor greenColor];

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
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
