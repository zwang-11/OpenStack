//
//  OSBillingViewController.h
//  Openstack
//
//  Created by Zeng Wang on 9/14/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSServer.h"

@interface OSBillingViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *usageTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *usageRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalBillLabel;

@property (strong, nonatomic) OSServer *server;

@property (strong, nonatomic) IBOutlet UILabel *instanceNameLabel;

@end
