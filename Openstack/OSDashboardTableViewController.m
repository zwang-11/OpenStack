//
//  OSDashboardTableViewController.m
//  Openstack
//
//  Created by Zeng Wang on 9/15/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSDashboardTableViewController.h"
#import "OSDashboardProgressTableViewCell.h"
#import "OSVMHealthTableViewCell.h"
#import "constants.h"
#import "OSSharedModel.h"
#import "OSServer.h"
#import "OSLoadingView.h"

#define OSDashboardProgressTVCell @"OSDashboardProgressTableViewCell"
#define OSVMHealthTVCell @"OSVMHealthTableViewCell"

#define ProgressUsedStringFormatInt @"Used %ld of %ld"
#define ProgressUsedStringFormatFloat @"Used %.2fGB of %.2fGB"

#define LimitsSession 0
#define ServersSession 1

#define DashboardTitle @"Dashboard"

@interface OSDashboardTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property int numberOfRowsInLimitsSection;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) OSLoadingView *loadingView;


@end

@implementation OSDashboardTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) initTableView
{
    self.tableView            = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.hidden     = YES;
}

- (void) initLoadingView
{
    [self.view addSubview:self.loadingView];
    self.isLoading = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableView];
    [self initLoadingView];
    
    // Register table view cell
    UINib *dashboardSummaryCell = [UINib nibWithNibName:OSDashboardProgressTVCell bundle:nil];
    [self.tableView registerNib:dashboardSummaryCell forCellReuseIdentifier:OSDashboardProgressTVCell];
    
    UINib *vmHealthCell = [UINib nibWithNibName:OSVMHealthTVCell bundle:nil];
    [self.tableView registerNib:vmHealthCell forCellReuseIdentifier:OSVMHealthTVCell];
    
    // Add observer for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLimitsSuccessfully:) name:GetLimitsSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLimitsFailed) name:GetLimitsSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getServersSuccessfully:) name:GetListServersSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getServersFailed) name:GetListServersFailedNotification object:nil];
    
    self.navigationItem.title = DashboardTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    
    self.tabBarItem.title = DashboardTitle;
    
    [self loadData];
}

- (void) loadData
{
    [[OSSharedModel sharedModel].requestManager getLimitsSummary];
    [[OSSharedModel sharedModel].requestManager getListOfServers];
    
    self.numberOfRowsInLimitsSection = 0;
    self.isLoading                   = YES;
}

- (void) setIsLoading:(BOOL)isLoading
{
    _isLoading                  = isLoading;
    
    // set frame
    CGRect frame                = CGRectZero;
    frame.size                  = self.view.frame.size;
    self.loadingView.frame      = frame;
    
    if (_isLoading) {
        [self.loadingView.activitiyIndicatorView startAnimating];
        self.loadingView.hidden = NO;
    }
    else {
        [self.loadingView.activitiyIndicatorView stopAnimating];
        self.loadingView.hidden = YES;
    }
}

/**
 lazy load loadingView, when create, add to subview
 */
- (OSLoadingView* ) loadingView
{
    if (nil != _loadingView) {
        return _loadingView;
    }
    
    _loadingView        = [[OSLoadingView alloc] init];
    
    _loadingView.hidden = YES;
    return _loadingView;
}


// Get limits successfully
- (void)getLimitsSuccessfully:(NSNotification *)notification
{
    self.numberOfRowsInLimitsSection = 5;
    NSDictionary *userInfo = [notification userInfo];
    self.limits = [userInfo objectForKey:LimitsKey];
    
    NSIndexSet *indexSet   = [[NSIndexSet alloc] initWithIndex:LimitsSession];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (self.servers){
        self.isLoading         = NO;
        self.tableView.hidden  = NO;
    }
}

// Get limits failed
- (void)getLimitsFailed
{
    if (self.servers){
        self.isLoading         = NO;
        self.tableView.hidden  = NO;
    }
}

// Get servers successfully
- (void)getServersSuccessfully:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    self.servers = [userInfo objectForKey:ServersArrayKey];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:ServersSession];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (self.numberOfRowsInLimitsSection > 0) {
        self.isLoading         = NO;
        self.tableView.hidden  = NO;
    }
}

// Get servers failed
- (void)getServersFailed
{
    if (self.numberOfRowsInLimitsSection > 0) {
        self.isLoading         = NO;
        self.tableView.hidden  = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == LimitsSession) {
        // 1 - instance
        // 2 - VCPUs
        // 3 - RAM
        // 4 - Floating IPs
        // 5 - Security Groups
        return self.numberOfRowsInLimitsSection;
    }
    else if (section == ServersSession)
    {
        return [self.servers count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == LimitsSession) {
        OSDashboardProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OSDashboardProgressTVCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([indexPath row] == 0) {
            cell.progressNameLabel.text = @"Instances";
            cell.progress = 0;
            cell.progressProgressLabel.text = [NSString stringWithFormat:ProgressUsedStringFormatInt, (long)0, (long)0];
        }
        else if ([indexPath row] == 1) {
            cell.progressNameLabel.text = @"VCPUs";
            cell.progress = 0;
            cell.progressProgressLabel.text = [NSString stringWithFormat:ProgressUsedStringFormatInt, (long)0, (long)0];
        }
        else if ([indexPath row] == 2) {
            cell.progressNameLabel.text = @"RAM";
            cell.progress = 0;
            cell.progressProgressLabel.text = [NSString stringWithFormat:ProgressUsedStringFormatInt, (long)0, (long)0];
        }
        else if ([indexPath row] == 3) {
            cell.progressNameLabel.text = @"Floating IPs";
            cell.progress = 0;
            cell.progressProgressLabel.text = [NSString stringWithFormat:ProgressUsedStringFormatFloat, 0.0, 0.0];
        }
        else if ([indexPath row] == 4) {
            cell.progressNameLabel.text = @"Security Groups";
            cell.progress = 0;
            cell.progressProgressLabel.text = [NSString stringWithFormat:ProgressUsedStringFormatInt, (long)0, (long)0];
        }
        if (self.limits) {
            if ([indexPath row] == 0) {
                cell.progressProgressLabel.text = [NSString stringWithFormat:ProgressUsedStringFormatInt, self.limits.numberOfInstanceUsed, self.limits.totalOfInstances];
                float progress = (float)self.limits.numberOfInstanceUsed / self.limits.totalOfInstances;
                cell.progressView.progress = progress;
            }
            else if ([indexPath row] == 1) {
                cell.progressProgressLabel.text = [NSString stringWithFormat:ProgressUsedStringFormatInt, self.limits.numberOfVCPUsUsed, self.limits.totalOfVCPUs];
                float progress = (float)self.limits.numberOfVCPUsUsed / self.limits.totalOfVCPUs;
                cell.progressView.progress = progress;
            }
            else if ([indexPath row] == 2) {
                cell.progressProgressLabel.text = [NSString stringWithFormat:ProgressUsedStringFormatFloat, self.limits.numberOfRAMUsed / 1024, self.limits.totalOfRAM/ 1024];
                float progress = (float)self.limits.numberOfRAMUsed / self.limits.totalOfRAM;
                cell.progressView.progress = progress;

            }
            else if ([indexPath row] == 3) {
                cell.progressProgressLabel.text = [NSString stringWithFormat:ProgressUsedStringFormatInt, self.limits.numberOfFloatingIPsUsed, self.limits.totalOfFloatingIPs];
                float progress = (float)self.limits.numberOfFloatingIPsUsed/ self.limits.totalOfFloatingIPs;
                cell.progressView.progress = progress;

            }
            else if ([indexPath row] == 4) {
                cell.progressProgressLabel.text = [NSString stringWithFormat:ProgressUsedStringFormatInt, self.limits.numberOfSecurityGroupsUsed, self.limits.totalOfSecurityGroups];
                float progress = (float)self.limits.numberOfSecurityGroupsUsed / self.limits.totalOfSecurityGroups;
                cell.progressView.progress = progress;
            }

        }
        return cell;
    }
    else {
        OSVMHealthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OSVMHealthTVCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.servers) {
            OSServer *server = [self.servers objectAtIndex:[indexPath row]];
            cell.instanceNameLabel.text = server.serverName;
            NSDictionary *instanceDict = [server createBillingDict];
            cell.instanceUptimeLabel.text = [instanceDict objectForKey:UptimeKey];
            cell.instanceBillingAmount.text = [instanceDict objectForKey:BillingAmountKey];
            
            if ([server.serverStatus isEqualToString:ServerStatusActive]) {
                cell.heathStatus.backgroundColor = [UIColor greenColor];
            }
            else if ([server.serverStatus isEqualToString:@"error"]) {
                cell.heathStatus.backgroundColor = [UIColor redColor];
            }
            else {
                cell.heathStatus.backgroundColor = [UIColor orangeColor];
            }
        }
        
        return cell;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == LimitsSession) {
        return 70;
    }
    else {
        return 105;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == LimitsSession) {
        return @"Limits Summary";
    }
    else {
        return @"Status and Billing";
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
