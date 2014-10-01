//
//  OSFormTextFieldTableViewCell.h
//  Openstack
//
//  Created by Zeng Wang on 9/11/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSFormTextFieldTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *propertyName;
@property (weak, nonatomic) IBOutlet UITextField *propertyValue;

@end
