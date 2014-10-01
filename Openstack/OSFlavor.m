//
//  OSFlavor.m
//  Openstack
//
//  Created by Zeng Wang on 9/9/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSFlavor.h"

#define RAMKey @"ram"
#define DiskKey @"disk"
#define VCPUSKey @"vcpus"
#define FlavorName @"name"
#define FlavorID @"id"

@implementation OSFlavor

- (id)initWithDictionary:(NSDictionary *)flavorDict
{
    self = [super init];
    if (self) {
        self.flavorName = [flavorDict objectForKey:FlavorName];
        self.RAM = [flavorDict objectForKey:RAMKey];
        self.Disk = [flavorDict objectForKey:DiskKey];
        self.VCPUs = [flavorDict objectForKey:VCPUSKey];
        self.flavorID = [flavorDict objectForKey:FlavorID];
    }
    
    return self;
}

@end
