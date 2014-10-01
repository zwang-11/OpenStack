//
//  OSLimits.m
//  Openstack
//
//  Created by Zeng Wang on 9/15/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSLimits.h"

@implementation OSLimits : NSObject

- (id)initWithDictionary:(NSDictionary *)limitsDict
{
    self = [super init];
    if (self) {
        NSDictionary *absolute = [limitsDict objectForKey:@"absolute"];
        self.numberOfInstanceUsed = [[absolute objectForKey:@"totalInstancesUsed"] longValue];
        self.totalOfInstances = [[absolute objectForKey:@"maxTotalInstances"] longValue];
        
        self.numberOfVCPUsUsed = [[absolute objectForKey:@"totalCoresUsed"] longValue];
        self.totalOfVCPUs = [[absolute objectForKey:@"maxTotalCores"] longValue];
        
        NSString *numberOfRAMUsedString = [absolute objectForKey:@"totalRAMUsed"];
        self.numberOfRAMUsed = [numberOfRAMUsedString floatValue];
        NSString *totalOfRAMString = [absolute objectForKey:@"maxTotalRAMSize"];
        self.totalOfRAM = [totalOfRAMString floatValue];
        
        self.numberOfFloatingIPsUsed = [[absolute objectForKey:@"totalFloatingIpsUsed"] longValue];
        self.totalOfFloatingIPs = [[absolute objectForKey:@"maxTotalFloatingIps"] longValue];
        
        self.numberOfSecurityGroupsUsed = [[absolute objectForKey:@"totalSecurityGroupsUsed"] longValue];
        self.totalOfSecurityGroups = [[absolute    objectForKey:@"maxSecurityGroups"] longValue];
    }
    return self;
}

@end
