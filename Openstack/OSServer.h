//
//  OSServer.h
//  Openstack
//
//  Created by Zeng Wang on 9/2/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSServer : NSObject

@property (strong, nonatomic) NSString *serverStatus;
@property (strong, nonatomic) NSString *serverName;
@property (strong, nonatomic) NSString *serverID;
@property (strong, nonatomic) NSString *hostId;
@property (strong, nonatomic) NSString *imageID;
@property (strong, nonatomic) NSString *flavorID;
@property (strong, nonatomic) NSString *IP;
@property (strong, nonatomic) NSArray *volumns;
@property (nonatomic) NSNumber *powerState;
@property (strong, nonatomic) id taskState;
@property (strong, nonatomic) NSString *launchedTime;
@property (strong, nonatomic) NSString *createdTime;
@property (strong, nonatomic) NSArray *securityGroups;
@property (strong, nonatomic) NSString *updatedTime;
@property (strong, nonatomic) id keyName;
@property int usageRate;

- (id)initWithDictionary:(NSDictionary *)serverDict;
- (NSDictionary *)createBillingDict;

@end
