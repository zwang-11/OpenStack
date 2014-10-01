//
//  OSInstanceDetailTableViewController.h
//  Openstack
//
//  Created by Zeng Wang on 9/4/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSServer.h"
#import "OSImage.h"
#import "OSFlavor.h"

@interface OSInstanceDetailTableViewController : UITableViewController

@property (strong, nonatomic) OSServer *server;
@property (strong, nonatomic) OSImage *image;
@property (strong, nonatomic) OSFlavor *flavor;

@end
