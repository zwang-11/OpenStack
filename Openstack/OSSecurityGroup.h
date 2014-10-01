//
//  OSSecurityGroup.h
//  Openstack
//
//  Created by Zeng Wang on 9/12/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSSecurityGroup : NSObject

@property (strong, nonatomic) NSString *securityGroupName;
@property (strong, nonatomic) NSString *securityGroupID;

- (id)initWithDictionary:(NSDictionary *)securityGroupDict;

@end
