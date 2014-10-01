//
//  OSInstanceDetailTableViewCell.h
//  Openstack
//
//  Created by Zeng Wang on 9/10/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSInstanceDetailTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* propertyName;
@property (nonatomic, weak) IBOutlet UILabel* propertyValue;

@end
