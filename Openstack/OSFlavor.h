//
//  OSFlavor.h
//  Openstack
//
//  Created by Zeng Wang on 9/9/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSFlavor : NSObject

@property (strong, nonatomic) NSNumber *RAM;
@property (strong, nonatomic) NSNumber *VCPUs;
@property (strong, nonatomic) NSNumber *Disk;
@property (strong, nonatomic) NSString *flavorName;
@property (strong, nonatomic) NSString *flavorID;

- (id)initWithDictionary:(NSDictionary *)flavorDict;

@end
