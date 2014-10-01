//
//  OSVMHealthTableViewCell.h
//  Openstack
//
//  Created by Zeng Wang on 9/15/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSVMHealthTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *instanceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *instanceUptimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *instanceBillingAmount;
@property (weak, nonatomic) IBOutlet UIButton *heathStatus;

@end
