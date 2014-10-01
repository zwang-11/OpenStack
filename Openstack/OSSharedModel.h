//
//  OSSharedModel.h
//  Openstack
//
//  Created by Zeng Wang on 8/28/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSUser.h"
#import "OSAPIRequestManager.h"

@interface OSSharedModel : NSObject

@property (strong, nonatomic) OSUser *user;
@property (strong, nonatomic) OSAPIRequestManager *requestManager;

+ (OSSharedModel *)sharedModel;

@end
