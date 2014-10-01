//
//  OSImage.m
//  Openstack
//
//  Created by Zeng Wang on 9/9/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSImage.h"

#define ImageNameKey @"name"
#define ImageIDKey @"id"

@implementation OSImage

- (id)initWithDictionary:(NSDictionary *)imageDict
{
    self = [super init];
    if (self) {
        self.imageName = [imageDict objectForKey:ImageNameKey];
        self.imageID = [imageDict objectForKey:ImageIDKey];
    }
    
    return self;
}

@end
