//
//  OSServer.m
//  Openstack
//
//  Created by Zeng Wang on 9/2/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSServer.h"
#import "constants.h"

#define ServerStatusKey @"OS-EXT-STS:vm_state"
#define ServerNameKey @"name"
#define ServerHostID @"hostId"
#define ServerImageID @"imageId"
#define ServerFlavorID @"flavorId"
#define ServerIPAddressKey @"addr"
#define ServerVolumnsKey @"os-extended-volumes:volumes_attached"
#define ServerPowerStateKey @"OS-EXT-STS:power_state"
#define ServerTaskStateKey @"OS-EXT-STS:task_state"
#define ServerLaunchedTimeKey @"OS-SRV-USG:launched_at"
#define ServerKeyNameKey @"key_name"
#define ServerSecurityGroupsKey @"security_groups"
#define ServerCreatedTimeKey @"created"
#define ServerUpdatedTimeKey @"updated"

#define LaunchTimeFormat @"yyyy-MM-dd'T'HH:mm:ss.000000"
#define TimeFormat @"yyyy-MM-dd'T'HH:mm:ss'Z'"


#define SecurityGroupNameKey @"name"

@implementation OSServer
- (id)initWithDictionary:(NSDictionary *)serverDict
{
    self = [super init];
    if (self) {
        self.serverStatus = [serverDict objectForKey:ServerStatusKey];
        self.serverName = [serverDict objectForKey:ServerNameKey];
        self.serverID = [serverDict objectForKey:ServerIDKey];
        self.hostId = [serverDict objectForKey:ServerHostID];
        
        NSDictionary *image = [serverDict objectForKey:ImageKey];
        self.imageID = [image objectForKey:@"id"];
        
        NSDictionary *flavor = [serverDict objectForKey:FlavorKey];
        self.flavorID = [[NSString alloc] initWithString:[flavor objectForKey:@"id"]];
        
        NSDictionary *addresses = [serverDict objectForKey:@"addresses"];
        if ([addresses count] > 0) {
            NSArray *keys = [addresses allKeys];
            NSArray *netArray = [addresses objectForKey:[keys objectAtIndex:0]];
            NSDictionary *addressDict = [netArray objectAtIndex:0];
            if (addressDict) {
                self.IP = [addressDict objectForKey:ServerIPAddressKey];
            }
        }
        else {
            self.IP = @"";
        }

        
        self.volumns = [serverDict objectForKey:ServerVolumnsKey];
        self.powerState = [serverDict objectForKey:ServerPowerStateKey];
        
        if ([[serverDict objectForKey:ServerTaskStateKey] isEqual:[NSNull null]]) {
            self.taskState = @"None";
        }
        else {
            self.taskState = [serverDict objectForKey:ServerTaskStateKey];
        }
        self.keyName = [serverDict objectForKey:ServerKeyNameKey];
        self.securityGroups = [serverDict objectForKey:ServerSecurityGroupsKey];
        
        NSString *launchedTimeString = [serverDict objectForKey:ServerLaunchedTimeKey];
        self.launchedTime = [NSString stringWithString:[self convertDateString:launchedTimeString withFormat:LaunchTimeFormat]];

        NSString *createdTimeString = [serverDict objectForKey:ServerCreatedTimeKey];
        self.createdTime = [NSString stringWithString:[self convertDateString:createdTimeString withFormat:TimeFormat]];
        
        NSString *updatedTimeString = [serverDict objectForKey:ServerUpdatedTimeKey];
        self.updatedTime = [NSString stringWithString:[self convertDateString:updatedTimeString  withFormat:TimeFormat]];
        
        if ([self.flavorID intValue] == 1) {
            self.usageRate = 1;
        }
        else if ([self.flavorID intValue] == 2) {
            self.usageRate = 2;
        }
        else if ([self.flavorID intValue] == 3) {
            self.usageRate = 3;
        }
        else if ([self.flavorID intValue] == 4) {
            self.usageRate = 4;
        }
        else {
            self.usageRate = 5;
        }
        
    }
    return self;
}

- (NSString *)convertDateString:(NSString *)dateStringToConvert withFormat:(NSString *)format
{
    if ([dateStringToConvert isEqual:[NSNull null]]) {
        return @"";
    }
    // Convert expire string into GMT date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    [dateFormatter setDateFormat:format];
    NSDate *dateToReturn = [[NSDate alloc] init];
    dateToReturn = [dateFormatter dateFromString:dateStringToConvert];
    
    NSDateFormatter *dateFormatterToPrint = [[NSDateFormatter alloc] init];
    [dateFormatterToPrint setDateFormat:DateFormatToPrint];
    NSString *dateString = [dateFormatterToPrint stringFromDate:dateToReturn];
    return dateString;
}

// Convert uptime to string
- (NSDictionary *)createBillingDict
{
    // Convert expire string into GMT date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    [dateFormatter setDateFormat:DateFormatToPrint];
    NSDate *createdTime = [[NSDate alloc] init];
    createdTime = [dateFormatter dateFromString:self.createdTime];
    NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:createdTime];
    
    // Update
    double secondsInMinute = 60;
    double secondsInHour = 3600;
    
    int hours = (int)distanceBetweenDates / secondsInHour;
    int minutes = (int)(distanceBetweenDates - hours * secondsInHour) / secondsInMinute;
    
    NSString *uptimeString = [NSString stringWithFormat:UpdateTimeStringFormat, hours, minutes];
    
    // Billing amount
    float billingAmount = distanceBetweenDates / secondsInMinute * self.usageRate / 100;
    NSString *billingAmountString = [NSString stringWithFormat:BillingAmountStringFormat, billingAmount];
    NSDictionary *instancesDict = [[NSDictionary alloc] initWithObjectsAndKeys:uptimeString, UptimeKey, billingAmountString, BillingAmountKey, nil];
    
    return instancesDict;
}

@end
