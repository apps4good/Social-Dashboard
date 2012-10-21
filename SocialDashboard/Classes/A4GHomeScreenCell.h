//
//  A4GHomeScreenCell.h
//  SocialDashboard
//
//  Created by Alan Yeung on 2012-10-20.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol A4GHomeScreenCellDelegate <NSObject>

@required
-(void)openMediaAtIndex:(int)index;

@end

@interface A4GHomeScreenCell : UITableViewCell
{
    UIButton *mediaButton[3];
}

-(IBAction)openMedia:(id)sender;

@property (assign, nonatomic) id <A4GHomeScreenCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *buttonA;
@property (strong, nonatomic) IBOutlet UIButton *buttonB;
@property (strong, nonatomic) IBOutlet UIButton *buttonC;

@end
