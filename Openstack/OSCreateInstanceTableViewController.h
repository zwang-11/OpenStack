//
//  OSCreateInstanceTableViewController.h
//  Openstack
//
//  Created by Zeng Wang on 9/11/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSDataPickTableViewController.h"

@interface OSCreateInstanceTableViewController : UIViewController

@property (nonatomic, assign) BOOL isLoading;

- (void)dataPickTableView:(OSDataPickTableViewController *)dataPickTableView didSelectData:(NSString *)dataID withDataName:(NSString *)dataName forProperty:(NSString *)propertyName;

@end
