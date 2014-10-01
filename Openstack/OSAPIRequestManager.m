//
//  OSAPIRequestManager.m
//  Openstack
//
//  Created by Zeng Wang on 9/2/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSAPIRequestManager.h"
#import "OSSharedModel.h"
#import "constants.h"
#import "AFNetworking.h"
#import "OSServer.h"
#import "OSImage.h"
#import "OSFlavor.h"
#import "OSNetwork.h"
#import "OSSecurityGroup.h"
#import "OSLimits.h"

@interface OSAPIRequestManager ()

@property (strong, nonatomic) NSString *tokenID;
@property (strong, nonatomic) NSString *tenantID;

@end

@implementation OSAPIRequestManager

- (NSString *)tokenID
{
    if (_tokenID) {
    }
    else {
        _tokenID = [[OSSharedModel sharedModel].user tokenID];
    }
    return _tokenID;
}

- (NSString *)tenantID
{
    if (_tenantID) {
    }
    else {
        _tenantID = [[OSSharedModel sharedModel].user tenantID];
    }
    return _tenantID;
}

// Authentification request
- (void)loginWithUsername:(NSString *)username
             withPassword:(NSString *)password
{
    if ([username isEqualToString:@""] || [password isEqualToString:@""] || (username == nil) || (password == nil))
    {
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // Set URL
    NSString *URLString = [NSString stringWithFormat:URLFormat, HostIP, KEYSTONEport, AuthAPISubURL];
    [request setURL:[NSURL URLWithString:URLString]];
    
    
    // Set HTTP Method
    [request setHTTPMethod:Post];
    
    // Set HTTP Headers
    request = [self setHeaderForRequest:request isWithToekn:NO];
    
    // Set HTTPBody
    NSString *httpBodyString = [NSString stringWithFormat:AuthAPIHTTPRequestBody, username, password];
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Make request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Request succeed
        NSLog(@"Lgoin succesfully");
        [self addCurrentUser:operation.responseData];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginSucceedNotification object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request failed
        NSLog(@"Lgoin failed");
        [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginFailedNotification object:nil];
    }];
    
    [operation start];
}

// List server request
- (void) getListOfServers
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // Set URL
    NSString *listServerAPISubURL = [NSString stringWithFormat:ListServersAPISubURLFormat, self.tenantID];
    NSString *URLString = [NSString stringWithFormat:URLFormat, HostIP, NOVAport, listServerAPISubURL];
    [request setURL:[NSURL URLWithString:URLString]];
    
    // Set HTTP Method
    [request setHTTPMethod:Get];
    
    // Set HTTP Headers
    request = [self setHeaderForRequest:request isWithToekn:YES];
    
    // Make request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Request succeed
        NSLog(@"Get servers successfully");
        NSArray *servers = [self createServersArray:operation.responseData];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:servers forKey:ListofServersKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:GetListServersSucceedNotification object:nil userInfo:userInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request failed
        NSLog(@"Get servers failed. %@", operation.responseString);
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:operation.responseString, @"message",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:GetListServersFailedNotification object:nil userInfo:userInfo];
    }];
    
    [operation start];
}

// List images request
- (void)getListOfImages
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // Set URL
    NSString *listImagesAPISubURL = [NSString stringWithFormat:ListImagesAPISubURLFormat, self.tenantID];
    NSString *URLString = [NSString stringWithFormat:URLFormat, HostIP, NOVAport, listImagesAPISubURL];
    [request setURL:[NSURL URLWithString:URLString]];
    
    // Set HTTP Method
    [request setHTTPMethod:Get];
    
    // Set HTTP Headers
    request = [self setHeaderForRequest:request isWithToekn:YES];
    
    // Make request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Request succeed
        NSLog(@"Get images successfully");
        NSArray *images = [self createImagesArray:operation.responseData];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:images forKey:ImagesArrayKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:GetListSucceedNotification object:nil userInfo:userInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request failed
        NSLog(@"Get images failed. %@", operation.responseString);
        [[NSNotificationCenter defaultCenter] postNotificationName:GetListFailedNotification object:nil];
    }];
    
    [operation start];
}

// List flavors request
- (void)getListOfFlavors
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // Set URL
    NSString *listFlavorsAPISubURL = [NSString stringWithFormat:ListFlavorsAPISubURLFormat, self.tenantID];
    NSString *URLString = [NSString stringWithFormat:URLFormat, HostIP, NOVAport, listFlavorsAPISubURL];
    [request setURL:[NSURL URLWithString:URLString]];
    
    // Set HTTP Method
    [request setHTTPMethod:Get];
    
    // Set HTTP Headers
    request = [self setHeaderForRequest:request isWithToekn:YES];
    
    // Make request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Request succeed
        NSLog(@"Get flaovrs successfully");
        NSArray *flavors = [self createFlavorsArray:operation.responseData];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:flavors forKey:FlavorsArrayKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:GetListSucceedNotification object:nil userInfo:userInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request failed
        NSLog(@"Get flavors failed. %@", operation.responseString);
        [[NSNotificationCenter defaultCenter] postNotificationName:GetListFailedNotification object:nil];
    }];
    
    [operation start];
}


// List networks request
- (void)getListOfNetworks
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // Set URL
    NSString *listNetworksAPISubURL = [NSString stringWithFormat:ListNetworksAPISubURLFormat];
    NSString *URLString = [NSString stringWithFormat:URLFormat, HostIP, NEUTRONport, listNetworksAPISubURL];
    [request setURL:[NSURL URLWithString:URLString]];
    
    // Set HTTP Method
    [request setHTTPMethod:Get];
    
    // Set HTTP Headers
    request = [self setHeaderForRequest:request isWithToekn:YES];
    
    // Make request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Request succeed
        NSLog(@"Get networks successfully");
        NSArray *networks = [self createNetworksArray:operation.responseData];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:networks forKey:NetworksArrayKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:GetListSucceedNotification object:nil userInfo:userInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request failed
        NSLog(@"Get networks failed. %@", operation.responseString);
        [[NSNotificationCenter defaultCenter] postNotificationName:GetListFailedNotification object:nil];
    }];
    
    [operation start];
}

// List server request
- (void)getListOfSecurityGroups
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // Set URL
    NSString *listSecurityGroupsAPISubURL = [NSString stringWithFormat:ListSecurityGroupsAPISubURLFormat];
    NSString *URLString = [NSString stringWithFormat:URLFormat, HostIP, NEUTRONport, listSecurityGroupsAPISubURL];
    [request setURL:[NSURL URLWithString:URLString]];
    
    // Set HTTP Method
    [request setHTTPMethod:Get];
    
    // Set HTTP Headers
    request = [self setHeaderForRequest:request isWithToekn:YES];
    
    // Make request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Request succeed
        NSLog(@"Get security groups successfully");
        NSArray *securityGroups = [self createSecurityGroupsArray:operation.responseData];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:securityGroups forKey:SecurityGroupsArrayKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:GetListSucceedNotification object:nil userInfo:userInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request failed
        NSLog(@"Get servers failed. %@", operation.responseString);
        [[NSNotificationCenter defaultCenter] postNotificationName:GetListFailedNotification object:nil];
    }];
    
    [operation start];
}


// Get details of a image
- (void)getDetailsOfImage:(NSString *)imageID
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // Set URL
    NSString *imageDetailsAPISubURL = [NSString stringWithFormat:GetImageDetailsAPISubURLFormat, self.tenantID, imageID];
    NSString *URLString = [NSString stringWithFormat:URLFormat, HostIP, NOVAport, imageDetailsAPISubURL];
    [request setURL:[NSURL URLWithString:URLString]];
    
    // Set HTTP Method
    [request setHTTPMethod:Get];
    
    // Set HTTP Headers
    request = [self setHeaderForRequest:request isWithToekn:YES];
    
    // Make request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Request succeed
        NSLog(@"Get image details successfully");
        OSImage *image = [self createImage:operation.responseData];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:image forKey:ImageKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:GetImageDetailsSucceedNotification object:nil userInfo:userInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request failed
        NSLog(@"Get image details failed. %@", operation.responseString);
        [[NSNotificationCenter defaultCenter] postNotificationName:GetImageDetailsFailedNotification object:nil];
    }];
    
    [operation start];
}

// Get details of a flavor
- (void)getDetailsOfFlavor:(NSString *)flavorID
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // Set URL
    NSString *flavorDetailsAPISubURL = [NSString stringWithFormat:GetFlavorDetailsAPISubURLFormat, self.tenantID, flavorID];
    NSString *URLString = [NSString stringWithFormat:URLFormat, HostIP, NOVAport, flavorDetailsAPISubURL];
    [request setURL:[NSURL URLWithString:URLString]];
    
    // Set HTTP Method
    [request setHTTPMethod:Get];
    
    // Set HTTP Headers
    request = [self setHeaderForRequest:request isWithToekn:YES];
    
    // Make request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Request succeed
        NSLog(@"Get flaovr details successfully");
        OSFlavor *flavor = [self createFlavor:operation.responseData];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:flavor forKey:FlavorKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:GetFlavorDetailsSucceedNotification object:nil userInfo:userInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request failed
        NSLog(@"Get flavor details failed. %@", operation.responseString);
        [[NSNotificationCenter defaultCenter] postNotificationName:GetFlavorDetailsFailedNotification object:nil];
    }];
    
    [operation start];
}

// Get limits summary
- (void)getLimitsSummary
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // Set URL
    NSString *limitsAPISubURL = [NSString stringWithFormat:LimitsSummarySubURLFormat, self.tenantID];
    NSString *URLString = [NSString stringWithFormat:URLFormat, HostIP, NOVAport, limitsAPISubURL];
    [request setURL:[NSURL URLWithString:URLString]];
    
    // Set HTTP Method
    [request setHTTPMethod:Get];
    
    // Set HTTP Headers
    request = [self setHeaderForRequest:request isWithToekn:YES];
    
    // Make request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Request succeed
        NSLog(@"Get limits successfully");
        OSLimits *limits = [self createLimite:operation.responseData];
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:limits, LimitsKey, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:GetLimitsSucceedNotification object:nil userInfo:userInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request failed
        NSLog(@"Get limits failed. %@", operation.responseString);
        [[NSNotificationCenter defaultCenter] postNotificationName:GetLimitsFailedNotification object:nil];
    }];
    
    [operation start];
}


// VM actions request
- (void)performInstanceAction:(NSString *)serverID forAction:(NSString *)action
{
    NSLog(@"%@", serverID);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // Set URL
    NSString *instanceActionSubURL = [NSString stringWithFormat:InstanceActionAPISubURLFormat, self.tenantID, serverID];
    NSString *URLString = [NSString stringWithFormat:URLFormat, HostIP, NOVAport, instanceActionSubURL];
    [request setURL:[NSURL URLWithString:URLString]];
    
    // Set HTTP Method
    [request setHTTPMethod:Post];
    
    // Set HTTP Headers
    request = [self setHeaderForRequest:request isWithToekn:YES];
    
    // Set HTTPBody
    if ([action isEqualToString:ServerStartTitle]) {
        [request setHTTPBody:[StartActionRequestBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if ([action isEqualToString:ServerPauseTitle]) {
        [request setHTTPBody:[PauseActionRequestBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if ([action isEqualToString:ServerShutoffTitle]) {
        [request setHTTPBody:[ShutoffActionRequestBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if ([action isEqualToString:ServerSoftRebootTitle]) {
        [request setHTTPBody:[SoftRebootActionRequestBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if ([action isEqualToString:ServerHardRebootTitle]) {
        [request setHTTPBody:[HardRebootActionRequestBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if ([action isEqualToString:ServerUnpauseTitle]) {
        [request setHTTPBody:[UnpauseActionRequestBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if ([action isEqualToString:ServerResumeTitle]) {
        [request setHTTPBody:[ResumeActionRequestBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if ([action isEqualToString:ServerRebootTitle]) {
        [request setHTTPBody:[RebootActionRequestBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if ([action isEqualToString:ServerSuspendTitle]) {
        [request setHTTPBody:[SuspendActionRequestBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // Make request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Request succeed
        NSLog(@"Action performaed successfully, %@", operation.responseString);
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:serverID, ServerIDKey, action, ActionKey, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:PerformActionSucceedNotification object:nil userInfo:userInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request failed
        NSLog(@"Action performaed failed. %@", operation.responseString);
        NSDictionary *userInfo = [self getConflictRequestMessage:operation.responseData];

        [[NSNotificationCenter defaultCenter] postNotificationName:PerformActionFailedNotification object:nil userInfo:userInfo];
    }];
    
    [operation start];
}

// Post request to create a new instance
- (void)createNewInstance:(NSString *)name withImage:(NSString *)imageID withFlavor:(NSString *)flavorID withNetwork:(NSString *)networkID withSecurityGroup:(NSString *)securityGroup
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // Set URL
    NSString *createInstanceAPISubURL = [NSString stringWithFormat:CreateInstanceAPISubURLFormat, self.tenantID];
    NSString *URLString = [NSString stringWithFormat:URLFormat, HostIP, NOVAport, createInstanceAPISubURL];
    [request setURL:[NSURL URLWithString:URLString]];
    
    // Set HTTP Method
    [request setHTTPMethod:Post];
    
    // Set HTTP Headers
    request = [self setHeaderForRequest:request isWithToekn:YES];
    
    // Set HTTP Body
    NSString *httpBody = [NSString stringWithFormat:CreateServerRequestBody, name, imageID, flavorID, networkID, securityGroup];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];

    // Make request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Request succeed
        NSLog(@"Create instance successfully");
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:operation.responseData, @"response", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:CreateInstanceSucceedNotification object:nil userInfo:userInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request failed
        NSLog(@"Create instance failed. %@", operation.responseString);
        [[NSNotificationCenter defaultCenter] postNotificationName:CreateInstanceFailedNotification object:nil];
    }];
    
    [operation start];

}

// Terminate instance
- (void)terminateInstance:(NSString *)serverID
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // Set URL
    NSString *terminateInstanceAPISubURL = [NSString stringWithFormat:TerminateInstanceAPISubURLFormat, self.tenantID, serverID];
    NSString *URLString = [NSString stringWithFormat:URLFormat, HostIP, NOVAport, terminateInstanceAPISubURL];
    [request setURL:[NSURL URLWithString:URLString]];
    
    // Set HTTP Method
    [request setHTTPMethod:Delete];
    
    // Set HTTP Headers
    request = [self setHeaderForRequest:request isWithToekn:YES];
    
    // Make request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Request succeed
        NSLog(@"Terminate instance successfully");
        [[NSNotificationCenter defaultCenter] postNotificationName:TerminateInstanceSucceedNotification object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request failed
        NSLog(@"Terminate instance failed. %@", operation.responseString);
        [[NSNotificationCenter defaultCenter] postNotificationName:TerminateInstanceFailedNotification object:nil];
    }];
    
    [operation start];
}

// Deal with error message
- (NSDictionary *)getConflictRequestMessage:(NSData *)responseData
{
    NSError* error;
    NSDictionary* responseDict = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:kNilOptions
                                  error:&error];
    NSDictionary* conflictingRequestDict = [responseDict objectForKey:@"conflictingRequest"];
    if (conflictingRequestDict) {
        NSString *message = [conflictingRequestDict objectForKey:@"message"];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:@"message"];
        return userInfo;
    }
    return nil;
}

// Set headers
- (NSMutableURLRequest *)setHeaderForRequest:(NSMutableURLRequest *)request isWithToekn:(BOOL)isWithToken
{
    [request setValue:ApplicationJSON forHTTPHeaderField:HeaderContentType];
    [request setValue:ApplicationJSON forHTTPHeaderField:HeaderAccept];
    if (isWithToken) {
        [request setValue:self.tokenID forHTTPHeaderField:HeaderAuthToken];
    }
    return request;

}

// Parse reponse date into a OSUser object
- (void)addCurrentUser:(NSData *)responseData
{
    NSError* error;
    NSDictionary* responseDict = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:kNilOptions
                                  error:&error];
    
    NSDictionary* tokenDict = [[responseDict objectForKey:@"access"] objectForKey:@"token"];
    NSString *tokenExpireString = [tokenDict objectForKey:@"expires"];
    NSString *tokenID = [tokenDict objectForKey:@"id"];
    
    NSDictionary* tenant = [tokenDict objectForKey:@"tenant"];
    NSString *tenantID = [tenant objectForKey:@"id"];
    
    // Set value to user object
    OSUser *currentUser =[OSSharedModel sharedModel].user;
    [currentUser setTokenID:tokenID];
    [currentUser setTenantID:tenantID];
    [currentUser setTokenExpireTimeString:tokenExpireString];
    
    // Add into standard userdefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:tokenID forKey:UserdefaultTokenIDKey];
    [defaults setObject:tenantID forKey:UserdefaultTenantIDKey];
    [defaults setObject:tokenExpireString forKey:UserdefaultTokenExpireKey];
    [defaults synchronize];
}

// Parse response data into an array of OSServer
- (NSArray *)createServersArray:(NSData *)responseData
{
    NSMutableArray *serversArray = [[NSMutableArray alloc] init];
    NSError* error;
    NSDictionary* responseDict = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:kNilOptions
                                  error:&error];

    NSArray *servers = [responseDict objectForKey:ListofServersKey];
    NSUInteger numberOfServers = [servers count];
    if (numberOfServers > 0) {
        for (int i = 0; i < numberOfServers; i++) {
            NSDictionary *serverDict = [servers objectAtIndex:i];
            OSServer *server = [[OSServer alloc] initWithDictionary:serverDict];
            [serversArray addObject:server];
        }
    }
    return serversArray;
}

// Parse response data into an array of OSServer
- (NSArray *)createImagesArray:(NSData *)responseData
{
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    NSError* error;
    NSDictionary* responseDict = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:kNilOptions
                                  error:&error];
    
    NSArray *images = [responseDict objectForKey:ImagesArrayKey];
    NSUInteger numberOfImages = [images count];
    if (numberOfImages > 0) {
        for (int i = 0; i < numberOfImages; i++) {
            NSDictionary *imageDict = [images objectAtIndex:i];
            OSImage *image = [[OSImage alloc] initWithDictionary:imageDict];
            [imagesArray addObject:image];
        }
    }
    return imagesArray;
}

// Parse response data into an array of OSServer
- (NSArray *)createFlavorsArray:(NSData *)responseData
{
    NSMutableArray *flavorsArray = [[NSMutableArray alloc] init];
    NSError* error;
    NSDictionary* responseDict = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:kNilOptions
                                  error:&error];
    
    NSArray *flavors = [responseDict objectForKey:FlavorsArrayKey];
    NSUInteger numberOfFlavors = [flavors count];
    if (numberOfFlavors > 0) {
        for (int i = 0; i < numberOfFlavors; i++) {
            NSDictionary *flaovorDict = [flavors objectAtIndex:i];
            OSFlavor *flavor = [[OSFlavor alloc] initWithDictionary:flaovorDict];
            [flavorsArray addObject:flavor];
        }
    }
    return flavorsArray;
}

// Parse response data into an array of OSNetwork
- (NSArray *)createNetworksArray:(NSData *)responseData
{
    NSMutableArray *networksArray = [[NSMutableArray alloc] init];
    NSError* error;
    NSDictionary* responseDict = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:kNilOptions
                                  error:&error];
    NSArray *networks = [responseDict objectForKey:NetworksArrayKey];
    NSUInteger numberOfNetworks = [networks count];
    if (numberOfNetworks > 0) {
        for (int i = 0; i < numberOfNetworks; i++) {
            NSDictionary *networkDict = [networks objectAtIndex:i];
            OSNetwork *network = [[OSNetwork alloc] initWithDictionary:networkDict];
            [networksArray addObject:network];
        }
    }
    return networksArray;
}

// Parse response data into an array of OSSecurityGroups
- (NSArray *)createSecurityGroupsArray:(NSData *)responseData
{
    NSMutableArray *securityGroupsArray = [[NSMutableArray alloc] init];
    NSError* error;
    NSDictionary* responseDict = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:kNilOptions
                                  error:&error];
    NSArray *securityGroups = [responseDict objectForKey:SecurityGroupsArrayKey];
    NSUInteger numberOfSecurityGroups = [securityGroups count];
    if (numberOfSecurityGroups > 0) {
        for (int i = 0; i < numberOfSecurityGroups; i++) {
            NSDictionary *networkDict = [securityGroups objectAtIndex:i];
            OSSecurityGroup *securityGroup = [[OSSecurityGroup alloc] initWithDictionary:networkDict];
            [securityGroupsArray addObject:securityGroup];
        }
    }
    return securityGroupsArray;
}

// Create image
- (OSImage *)createImage:(NSData *)responseData
{
    NSError* error;
    NSDictionary* responseDict = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:kNilOptions
                                  error:&error];
    
    NSDictionary *imageDict = [responseDict objectForKey:ImageKey];
    OSImage *image = [[OSImage alloc] initWithDictionary:imageDict];
    return image;
}

// Create flavor
- (OSFlavor *)createFlavor:(NSData *)responseData
{
    NSError* error;
    NSDictionary* responseDict = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:kNilOptions
                                  error:&error];

    NSDictionary *flavorDict = [responseDict objectForKey:FlavorKey];
    OSFlavor *flavor = [[OSFlavor alloc] initWithDictionary:flavorDict];
    return flavor;
}

// Create limits
- (OSLimits *)createLimite:(NSData *)responseData
{
    NSError* error;
    NSDictionary* responseDict = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:kNilOptions
                                  error:&error];
    
    NSDictionary *limitsDict = [responseDict objectForKey:LimitsKey];
    OSLimits *limits = [[OSLimits alloc] initWithDictionary:limitsDict];
    return limits;
}


@end
