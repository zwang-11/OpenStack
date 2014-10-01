//
//  OSDataPickTableViewController.h
//  Openstack
//
//  Created by Zeng Wang on 9/13/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OSDataPickTableViewController;

@protocol DataPickTableViewControllerDelegate <NSObject>

- (void)dataPickTableView:(OSDataPickTableViewController *)dataPickTableView didSelectData:(NSString *)dataID withDataName:(NSString *)dataName forProperty:(NSString *)propertyName;
@end

@interface OSDataPickTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSString *propertyName;
@property (weak, nonatomic) id <DataPickTableViewControllerDelegate> delegate;

@end
