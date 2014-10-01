//
//  OSSharedModel.m
//  Openstack
//
//  Created by Zeng Wang on 8/28/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSSharedModel.h"

@implementation OSSharedModel

- (id)init
{
    self = [super init];
    if (self)
    {
        self.user = [[OSUser alloc] init];
        self.requestManager = [[OSAPIRequestManager alloc] init];
    }
    return self;
}


+ (OSSharedModel *)sharedModel
{
    static dispatch_once_t once;
    static id sharedModel;
    dispatch_once(&once, ^{sharedModel = [[self alloc] init];});
    return sharedModel;
}
@end
