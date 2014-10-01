//
//  OSInstancesViewController.h
//  Openstack
//
//  Created by Zeng Wang on 8/28/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSInstancesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL  isLoading;

@end
