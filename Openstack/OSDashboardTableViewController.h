//
//  OSDashboardTableViewController.h
//  Openstack
//
//  Created by Zeng Wang on 9/15/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSLimits.h"

@interface OSDashboardTableViewController : UIViewController

@property (strong, nonatomic) NSArray       *servers;
@property (strong, nonatomic) OSLimits      *limits;
@property (nonatomic, assign) BOOL          isLoading;

@end
