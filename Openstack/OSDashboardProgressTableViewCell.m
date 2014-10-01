//
//  OSDashboardProgressTableViewCell.m
//  Openstack
//
//  Created by Zeng Wang on 9/14/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSDashboardProgressTableViewCell.h"

@implementation OSDashboardProgressTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.progressView.progress = self.progress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
