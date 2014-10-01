//
//  OSDashboardProgressTableViewCell.h
//  Openstack
//
//  Created by Zeng Wang on 9/14/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSDashboardProgressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *progressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressProgressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property float progress;

@end
