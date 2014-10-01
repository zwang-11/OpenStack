//
//  OSUser.m
//  Openstack
//
//  Created by Zeng Wang on 9/2/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSUser.h"

@implementation OSUser

#define tokenExpireTimeKey @"tokenExpireTime"
#define tokenIDKey @"tokenID"
#define tenantIDKey @"tenantID"

- (id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        self.tokenExpireTimeString = [[NSString alloc] init];
        self.tokenID = [[NSString alloc] init];
        self.tenantID = [[NSString alloc] init];
        
        self.tokenExpireTimeString = [defaults objectForKey:UserdefaultTokenExpireKey];
        self.tokenID = [defaults objectForKey:UserdefaultTokenIDKey];
        self.tenantID = [defaults objectForKey:UserdefaultTenantIDKey];
    }
    return self;
}

//- (void)encodeWithCoder:(NSCoder *)encoder {
//    //Encode properties, other class variables, etc
//    [encoder encodeObject:self.tokenExpireTimeString forKey:tokenExpireTimeKey];
//    [encoder encodeObject:self.tokenID forKey:tokenIDKey];
//    [encoder encodeObject:self.tenantID forKey:tenantIDKey];
//}
//
//- (id)initWithCoder:(NSCoder *)decoder {
//    if((self = [super init])) {
//        //decode properties, other class vars
//        self.tokenExpireTimeString = [decoder decodeObjectForKey:tokenExpireTimeKey];
//        self.tokenID = [decoder decodeObjectForKey:tokenIDKey];
//        self.tenantID = [decoder decodeObjectForKey:tenantIDKey];
//    }
//    return self;
//}

- (BOOL)isUserLoginedIn
{
    // Convert expire string into GMT date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    [dateFormatter setDateFormat:ExpireDateFormat];
    NSDate *expireDate = [[NSDate alloc] init];
    expireDate = [dateFormatter dateFromString:self.tokenExpireTimeString];
    
    // Convert local time into GMT time
    NSTimeZone *timezone = [NSTimeZone localTimeZone];
    NSInteger seconds = -[timezone secondsFromGMTForDate:[NSDate date]];
    NSDate *now = [NSDate dateWithTimeInterval:seconds sinceDate:[NSDate date]];
    
    if ([expireDate compare:now] == NSOrderedAscending) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
