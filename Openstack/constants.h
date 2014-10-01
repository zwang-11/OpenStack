//
//  constants.h
//  Openstack
//
//  Created by Zeng Wang on 8/28/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#ifndef Openstack_constants_h
#define Openstack_constants_h

// Host IP
#define HostIP           @"10.0.1.15"

// Ports
#define KEYSTONEport      @"5000"
#define NOVAport          @"8774"
#define NOVA_EC2port      @"8773"
#define CINDERport        @"8776"
#define CEILOMETERport    @"8777"
#define GLANCEport        @"9292"
#define NEUTRONport       @"9696"
#define KEYSTONE_ADMport  @"35357"

// Userdefaults keys
#define UserdefaultUserKey @"user"
#define UserdefaultTokenIDKey @"tokenID"
#define UserdefaultTokenExpireKey @"expires"
#define UserdefaultTenantIDKey @"tenantID"

// String format
#define URLFormat         @"http://%@:%@%@"
#define ExpireDateFormat @"yyyy-MM-dd'T'HH:mm:ss'Z'"
#define DateFormatToPrint @"yyyy-MM-dd HH:mm:ss"


// URL header value
#define ApplicationJSON @"application/json"

// URL header name
#define HeaderAccept @"Accept"
#define HeaderContentType @"Content-Type"
#define HeaderAuthToken @"X-Auth-Token"

// API URLs
#define AuthAPISubURL @"/v2.0/tokens"

// %@ - tenantID
#define ListServersAPISubURLFormat @"/v2/%@/servers/detail"
#define ListFlavorsAPISubURLFormat @"/v2/%@/flavors/detail"
#define ListImagesAPISubURLFormat @"/v2/%@/images/detail"
#define ListNetworksAPISubURLFormat @"/v2.0/networks"
#define CreateInstanceAPISubURLFormat @"/v2/%@/servers"
#define ListSecurityGroupsAPISubURLFormat @"/v2.0/security-groups"
#define LimitsSummarySubURLFormat @"/v2/%@/limits"

// %@ - tenantID; %@ server/tenant/flavor ID
#define GetServerDetailsAPISubURLFormat @"/v2/%@/servers/%@"
#define GetImageDetailsAPISubURLFormat @"/v2/%@/images/%@"
#define GetFlavorDetailsAPISubURLFormat @"/v2/%@/flavors/%@"

// first %@ - tenantID; second %@ - serverID
#define InstanceActionAPISubURLFormat @"/v2/%@/servers/%@/action"
#define TerminateInstanceAPISubURLFormat @"/v2/%@/servers/%@"

// API HTTP body
#define AuthAPIHTTPRequestBody @"{\"auth\":{\"passwordCredentials\":{\"username\":\"%@\",\"password\":\"%@\"},\"tenantName\":\"admin\"}}"
#define StartActionRequestBody @"{\"os=start\":null}"
#define PauseActionRequestBody @"{\"pause\":null}"
#define UnpauseActionRequestBody @"{\"unpause\":null}"
#define ResumeActionRequestBody @"{\"resume\":null}"
#define SuspendActionRequestBody @"{\"suspend\":null}"
#define SoftRebootActionRequestBody @"{\"reboot\":{\"type\":\"soft\"}}"
#define HardRebootActionRequestBody @"{\"reboot\":{\"type\":\"hard\"}}"
#define RebootActionRequestBody @"{\"reboot\":{\"type\":\"soft\"}}"
#define ShutoffActionRequestBody @"{\"os-stop\":null}"
#define CreateServerRequestBody @"{\"server\":{\"name\":\"%@\",\"imageRef\":\"%@\",\"flavorRef\":\"%@\",\"max_count\":1,\"min_count\":1,\"networks\":[{\"uuid\":\"%@\"}],\"security_groups\": [{\"name\":\"%@\"}]}}"

// API HTTP Method
#define Post @"Post"
#define Get @"Get"
#define Delete @"Delete"

// NSNotification identifiers
#define UserLoginSucceedNotification @"loginSucceedNotification"
#define UserLoginFailedNotification @"loginFailedNotification"

#define GetListServersSucceedNotification @"getServersSucceedNotification"
#define GetListServersFailedNotification @"getServersFailedNotification"
#define GetListImagesSucceedNotification @"getImagesSucceedNotification"
#define GetListImagesFailedNotification @"getImagesFailedNotification"
#define GetListFlavorsSucceedNotification @"getFlavorsSucceedNotification"
#define GetListFlavorsFailedNotification @"getFlavorsFailedNotification"
#define GetListNetworksSucceedNotification @"getNetworksSucceedNotification"
#define GetListNetworksFailedNotification @"getNetworksFailedNotification"

#define GetListSucceedNotification @"getListSucceedNotification"
#define GetListFailedNotification @"getListFailedNotification"

#define GetLimitsSucceedNotification @"getLimitsSucceedNotification"
#define GetLimitsFailedNotification @"getLimitsFailedNotification"

#define GetImageDetailsSucceedNotification @"getImageDetailsSucceedNotification"
#define GetImageDetailsFailedNotification @"getImageDetailsSucceedNotification"
#define GetFlavorDetailsSucceedNotification @"getFlavorDetailsSucceedNotification"
#define GetFlavorDetailsFailedNotification @"getFlavorDetailsFailedNotification"
#define GetServerDetailsSucceedNotification @"getServerDetailsSucceedNotification"
#define GetServerDetailsFailedNotification @"getServerDetailsFailedNotification"

#define CreateInstanceSucceedNotification @"createInstanceSucceedNotification"
#define CreateInstanceFailedNotification @"createInstanceFailedNotification"
#define PerformActionSucceedNotification @"instanceAcctionSucceedNotification"
#define PerformActionFailedNotification @"instanceAcctionFailedNotification"

#define TerminateInstanceSucceedNotification @"terminateInstanceSucceedNotification"
#define TerminateInstanceFailedNotification @"terminateInstanceFailedNotification"

#define ShowBillingNotification @"ShowBilling"

// Userinfo Keys
#define ResponseDataKey @"responseData"

// Reponse Dictionary keys
#define ServerIDKey @"id"

#define ActionKey @"action"
#define ListofServersKey @"servers"

// Sever status
#define ServerStatusActive @"active"
#define ServerStatusShutoff @"shutoff"
#define ServerStatusPaused @"paused"
#define ServerStatusStopped @"stopped"
#define ServerStatusSuspend @"suspended"

// Actiion Button Title
#define ServerShutoffTitle @"Shut Off"
#define ServerStartTitle @"Start"
#define ServerSuspendTitle @"Suspend"
#define ServerPauseTitle @"Pause"
#define ServerSoftRebootTitle @"Soft Reboot"
#define ServerHardRebootTitle @"Hard Reboot"
#define ServerResumeTitle @"Resume"
#define ServerUnpauseTitle @"Unpause"
#define ServerRebootTitle @"Reboot"

// Key name
#define ImagesArrayKey @"images"
#define FlavorsArrayKey @"flavors"
#define ServersArrayKey @"servers"
#define NetworksArrayKey @"networks"
#define SecurityGroupsArrayKey @"security_groups"

#define ImageKey @"image"
#define FlavorKey @"flavor"
#define ServerKey @"server"
#define NetworkKey @"network"
#define SecurityGroupKey @"securitygroup"
#define LimitsKey @"limits"

#define ImagePropertyName @"Image"
#define FlavorPropertyName @"Flavor"
#define NetworkPropertyName @"Network"
#define SecurityGroupPropertyName @"Security Group"

#define MessageKey @"message"

// Image name
#define RedImage @"red.png"

// Dashboard
#define UptimeKey @"Uptime"
#define BillingAmountKey @"BillingAmount"
#define BillingAmountStringFormat @"$%2.2f"
#define UpdateTimeStringFormat @"%d hours %d minutes"
#endif