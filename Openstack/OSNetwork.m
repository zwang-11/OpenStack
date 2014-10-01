//
//  OSNetwork.m
//  Openstack
//
//  Created by Zeng Wang on 9/12/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSNetwork.h"

@implementation OSNetwork

- (id)initWithDictionary:(NSDictionary *)networkDict
{
    self = [super init];
    if (self) {
        self.networkName = [networkDict objectForKey:@"name"];
        self.networkID = [networkDict objectForKey:@"id"];
        self.networkStatus = [networkDict objectForKey:@"status"];
    }
    return self;
}

@end
