//
//  SDViewController.h
//  SocialDashboard
//
//  Created by Alan Yeung on 2012-10-20.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A4GHomeScreenCell.h"

@interface SDViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, A4GHomeScreenCellDelegate>
{
    IBOutlet UITableView *mainTableView;
}

@end
