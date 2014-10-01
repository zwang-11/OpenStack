//
//  OSInstanceDetailTableViewController.m
//  Openstack
//
//  Created by Zeng Wang on 9/4/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSInstanceDetailTableViewController.h"
#import "OSInstanceDetailTableViewCell.h"
#import "OSSharedModel.h"
#import "OSFlavor.h"
#import "OSImage.h"
#import "OSBillingViewController.h"

#define DetailTableViewCellIdentifier @"OSInstanceDetailTableViewCell"
#define ViewControllerTitle @"Details"
#define TerminateBarButtonTitle @"Terminate"

@interface OSInstanceDetailTableViewController ()
@end

@implementation OSInstanceDetailTableViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[OSSharedModel sharedModel].requestManager getDetailsOfImage:self.server.imageID];
    [[OSSharedModel sharedModel].requestManager getDetailsOfFlavor:self.server.flavorID];
    
    // Add observer to notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageDetailsSuccessfully:) name:GetImageDetailsSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFlavorDetailsSuccessfully:) name:GetFlavorDetailsSucceedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(terminateInstanceSuccessfully) name:TerminateInstanceSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(terminateInstanceFailed) name:TerminateInstanceFailedNotification object:nil];
    
    UINib *detailTableViewCellNib = [UINib nibWithNibName:DetailTableViewCellIdentifier bundle:nil];
    [self.tableView registerNib:detailTableViewCellNib forCellReuseIdentifier:DetailTableViewCellIdentifier];
    
    self.navigationItem.title = ViewControllerTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    
    UIBarButtonItem *terminateButton = [[UIBarButtonItem alloc] initWithTitle:TerminateBarButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(terminateInstance)];
    self.navigationItem.rightBarButtonItem = terminateButton;
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBackToInstancesViewController)];
//    self.navigationItem.leftBarButtonItem = backButton;
}

// Get image detail info successfully
- (void)getImageDetailsSuccessfully:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    if ([userInfo objectForKey:ImageKey]) {
        self.image = [userInfo objectForKey:ImageKey];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:4];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

// Get flavor detail info successfully
- (void)getFlavorDetailsSuccessfully:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    if ([userInfo objectForKey:FlavorKey]) {
        self.flavor = [userInfo objectForKey:FlavorKey];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:1];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

// Go back to Instances View Controller
- (void)goBackToInstancesViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Terminate instance
- (void)terminateInstance
{
    [[OSSharedModel sharedModel].requestManager terminateInstance:self.server.serverID];
}

// Terminate action executed successfully
- (void)terminateInstanceSuccessfully
{
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:self.server, ServerKey, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowBillingNotification object:self userInfo:userInfo];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Terminate InstanceFailed
- (void)terminateInstanceFailed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Terminate Instance failed."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // 1 - info
    // 2 - spec
    // 3 - ip
    // 4 - security groups
    // 5 - meta
    // 6 - volumes attached
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 5;
    }
    else if (section == 1) {
        return 4;
    }
    else if (section == 2) {
        return 1;
    }
    else if (section == 3) {
        return 1;
    }
    else if (section == 4){
        return 2;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OSInstanceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailTableViewCellIdentifier forIndexPath:indexPath];
    cell.propertyValue.text = @"";
    [cell.propertyValue setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
    // Info group
    if ([indexPath section] == 0) {
        if ([indexPath row] == 0) {
            cell.propertyName.text = @"Name";
            cell.propertyValue.text = self.server.serverName;
        }
        else if ([indexPath row] == 1) {
            cell.propertyName.text = @"ID";
            cell.propertyValue.text = self.server.serverID;
            [cell.propertyValue setFont:[UIFont fontWithName:@"Helvetica" size:9.0]];
        }
        else if ([indexPath row] == 2) {
            cell.propertyName.text = @"Status";
            cell.propertyValue.text = self.server.serverStatus;
        }
        else if ([indexPath row] == 3) {
            cell.propertyName.text = @"Created";
            cell.propertyValue.text = self.server.createdTime;
        }
        else if ([indexPath row] == 4) {
            cell.propertyName.text = @"Updated";
            cell.propertyValue.text = self.server.updatedTime;
        }
    }
    // Specs group
    else if ([indexPath section] == 1) {
        if ([indexPath row] == 0) {
            cell.propertyName.text = FlavorKey;
            if (self.flavor) {
                cell.propertyValue.text = self.flavor.flavorName;
            }
        }
        else if ([indexPath row] == 1) {
            cell.propertyName.text = @"RAM";
            if (self.flavor) {
                cell.propertyValue.text = [self.flavor.RAM stringValue];
            }
        }
        else if ([indexPath row] == 2) {
            cell.propertyName.text = @"VCPUs";
            if (self.flavor) {
                cell.propertyValue.text = [self.flavor.VCPUs stringValue];
            }
        }
        else if ([indexPath row] == 3) {
            cell.propertyName.text = @"Disk";
            if (self.flavor) {
                cell.propertyValue.text = [self.flavor.Disk stringValue];
            }
        }
    }
    // IP Addresses group
    else if ([indexPath section] == 2) {
        cell.propertyName.text = @"Net1";
        cell.propertyValue.text = self.server.IP;
    }
    // Security groups
    else if ([indexPath section] == 3) {
        cell.propertyName.text = @"Name";
        if ([self.server.securityGroups count] > 0) {
            NSString *securityGroupName = [[self.server.securityGroups objectAtIndex:0] objectForKey:@"name"];
            cell.propertyValue.text = securityGroupName;
        }
    }
    // Meta
    else if ([indexPath section] == 4) {
        if ([indexPath row] == 0) {
            cell.propertyName.text = @"Key Name";
            if ([self.server.keyName isEqual:[NSNull null]]) {
                cell.propertyValue.text = @"None";
            }
            else {
                cell.propertyValue.text = self.server.keyName;
            }
        }
        else {
            cell.propertyName.text = @"Image Name";
            if (self.image) {
                cell.propertyValue.text = self.image.imageName;
            }
        }
    }
    else {
        cell.propertyName.text = @"Volume";
        if ([self.server.volumns count] == 0) {
            cell.propertyValue.text = @"No volums attached.";
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Info";
    }
    else if (section == 1) {
        return @"Specs";
    }
    else if (section == 2) {
        return @"IP Addresses";
    }
    else if (section == 3) {
        return @"Security Groups";
    }
    else if (section == 4){
        return @"Meta";
    }
    else {
        return @"Volumns Attached";
    }
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
