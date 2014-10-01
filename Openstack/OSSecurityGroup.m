//
//  OSSecurityGroup.m
//  Openstack
//
//  Created by Zeng Wang on 9/12/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSSecurityGroup.h"

@implementation OSSecurityGroup

- (id)initWithDictionary:(NSDictionary *)securityGroupDict
{
    self = [super init];
    if (self) {
        self.securityGroupName = [securityGroupDict objectForKey:@"name"];
        self.securityGroupID = [securityGroupDict objectForKey:@"id"];
    }
    return self;
}


@end
