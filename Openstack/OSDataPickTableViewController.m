//
//  OSDataPickTableViewController.m
//  Openstack
//
//  Created by Zeng Wang on 9/13/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSDataPickTableViewController.h"
#import "OSImage.h"
#import "OSFlavor.h"
#import "OSNetwork.h"
#import "OSSecurityGroup.h"
#import "constants.h"

#define UITableViewCellIdentifier @"UITableViewCell"

@interface OSDataPickTableViewController ()

@end

@implementation OSDataPickTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:UITableViewCellIdentifier];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Select a %@", self.propertyName];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.propertyName isEqualToString:SecurityGroupPropertyName])
    {
        return 1;
    }
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if ([self.propertyName isEqualToString:ImagePropertyName]) {
        OSImage *image = [self.dataArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = image.imageName;
    }
    else if ([self.propertyName isEqualToString:FlavorPropertyName]) {
        OSFlavor *flavor = [self.dataArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = flavor.flavorName;
    }
    else if ([self.propertyName isEqualToString:NetworkPropertyName]) {
        OSNetwork *network = [self.dataArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = network.networkName;
    }
    else if ([self.propertyName isEqualToString:SecurityGroupPropertyName]) {
        OSSecurityGroup *securityGroup = [self.dataArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = securityGroup.securityGroupName;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(dataPickTableView:didSelectData:withDataName:forProperty:)]) {
        if ([self.propertyName isEqualToString:ImagePropertyName]) {
            OSImage *image = (OSImage *)[self.dataArray objectAtIndex:[indexPath row]];
            NSString *dataID = image.imageID;
            NSString *dataName = image.imageName;
            [self.delegate dataPickTableView:self didSelectData:dataID withDataName:dataName forProperty:self.propertyName];
        }
        else if ([self.propertyName isEqualToString:FlavorPropertyName]) {
            OSFlavor *flavor = (OSFlavor *)[self.dataArray objectAtIndex:[indexPath row]];
            NSString *dataID = flavor.flavorID;
            NSString *dataName = flavor.flavorName;
            [self.delegate dataPickTableView:self didSelectData:dataID withDataName:dataName forProperty:self.propertyName];
        }
        else if ([self.propertyName isEqualToString:NetworkPropertyName]) {
            OSNetwork *network = (OSNetwork *)[self.dataArray objectAtIndex:[indexPath row]];
            NSString *dataID = network.networkID;
            NSString *dataName = network.networkName;
            [self.delegate dataPickTableView:self didSelectData:dataID withDataName:dataName forProperty:self.propertyName];
        }
        else if ([self.propertyName isEqualToString:SecurityGroupPropertyName]) {
            OSSecurityGroup *securityGroup = (OSSecurityGroup *)[self.dataArray objectAtIndex:[indexPath row]];
            NSString *dataID = securityGroup.securityGroupID;
            NSString *dataName = securityGroup.securityGroupName;
            [self.delegate dataPickTableView:self didSelectData:dataID withDataName:dataName forProperty:self.propertyName];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
