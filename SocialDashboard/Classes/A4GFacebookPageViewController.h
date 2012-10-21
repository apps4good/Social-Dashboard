//
//  A4GFacebookPageViewController.h
//  SocialDashboard
//
//  Created by Alan Yeung on 2012-10-20.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface A4GFacebookPageViewController : UITableViewController{

@private
// for downloading the xml data
NSURLConnection *facebookFeedConnection;
NSMutableData *rssData;

NSOperationQueue *parseQueue;
}

@end
