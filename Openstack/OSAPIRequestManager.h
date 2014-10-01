//
//  OSAPIRequestManager.h
//  Openstack
//
//  Created by Zeng Wang on 9/2/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSAPIRequestManager : NSObject

- (void)loginWithUsername:(NSString *)username
             withPassword:(NSString *)password;
- (void)getListOfServers;
- (void)getListOfImages;
- (void)getListOfFlavors;
- (void)getListOfNetworks;
- (void)getListOfSecurityGroups;
- (void)getLimitsSummary;

- (void)getDetailsOfImage:(NSString *)imageID;
- (void)getDetailsOfFlavor:(NSString *)flavorID;
- (void)createNewInstance:(NSString *)name withImage:(NSString *)imageID withFlavor:(NSString *)flavorID withNetwork:(NSString *)networkID withSecurityGroup:(NSString *)securityGroup;

- (void)performInstanceAction:(NSString *)serverID forAction:(NSString *)action;

- (void)terminateInstance:(NSString *)serverID;

@end