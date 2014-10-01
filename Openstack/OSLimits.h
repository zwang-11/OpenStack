//
//  OSLimits.h
//  Openstack
//
//  Created by Zeng Wang on 9/15/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSLimits : NSObject

@property long numberOfInstanceUsed;
@property long totalOfInstances;
@property long numberOfVCPUsUsed;
@property long totalOfVCPUs;
@property float numberOfRAMUsed;
@property float totalOfRAM;
@property long numberOfFloatingIPsUsed;
@property long totalOfFloatingIPs;
@property long numberOfSecurityGroupsUsed;
@property long totalOfSecurityGroups;

- (id)initWithDictionary:(NSDictionary *)limitsDict;
@end
