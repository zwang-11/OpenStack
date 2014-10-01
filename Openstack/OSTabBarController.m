//
//  OSTabBarController.m
//  Openstack
//
//  Created by Zeng Wang on 9/15/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSTabBarController.h"
#import "OSSharedModel.h"
#import "OSLoginViewController.h"
#import "OSInstancesViewController.h"
#import "OSDashboardTableViewController.h"

@interface OSTabBarController ()

@end

@implementation OSTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // First view Controller
        OSInstancesViewController *instancesViewController = [[OSInstancesViewController alloc] init];
        UINavigationController *firstNavController = [[UINavigationController alloc] initWithRootViewController:instancesViewController];
        
        // Second view controller
        OSDashboardTableViewController *dashboardViewController = [[OSDashboardTableViewController alloc] init];
        UINavigationController *secondNavController = [[UINavigationController alloc] initWithRootViewController:dashboardViewController];
        
        self.viewControllers = [NSArray arrayWithObjects: firstNavController, secondNavController, nil];
        self.selectedIndex = 0;
        self.tabBar.translucent  = NO;
        
        // If user is already logined in and token is still valid
        // Present next view controller
        if (![[OSSharedModel sharedModel].user isUserLoginedIn]) {
            OSLoginViewController *loginViewController = [[OSLoginViewController alloc] init];
            [self presentViewController:loginViewController animated:YES completion:nil];
        }

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
