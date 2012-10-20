//
//  SDAppDelegate.h
//  SocialDashboard
//
//  Created by Alan Yeung on 2012-10-20.
//  Copyright (c) 2012 Apps4Good. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDViewController;

@interface SDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SDViewController *viewController;

@end
