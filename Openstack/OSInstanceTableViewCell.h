//
//  OSInstanceTableViewCell.h
//  Openstack
//
//  Created by Zeng Wang on 8/28/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSCellButton.h"

@interface OSInstanceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *instanceName;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *task;
@property (weak, nonatomic) IBOutlet OSCellButton *buttonOne;
@property (weak, nonatomic) IBOutlet OSCellButton *buttonTwo;
@property (weak, nonatomic) IBOutlet OSCellButton *buttonThree;

@property (strong, nonatomic) NSString *serverID;

@end
