//
//  OSNetwork.h
//  Openstack
//
//  Created by Zeng Wang on 9/12/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNetwork : NSObject

@property (strong, nonatomic) NSString *networkID;
@property (strong, nonatomic) NSString *networkName;
@property (strong, nonatomic) NSString *networkStatus;

- (id)initWithDictionary:(NSDictionary *)networkDict;

@end
