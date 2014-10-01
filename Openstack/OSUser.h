//
//  OSUser.h
//  Openstack
//
//  Created by Zeng Wang on 9/2/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constants.h"  

@interface OSUser : NSObject
@property (strong, nonatomic) NSString *tokenExpireTimeString;
@property (strong, nonatomic) NSString *tokenID;
@property (strong, nonatomic) NSString *tenantID;

- (BOOL)isUserLoginedIn;

@end
