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

@end
