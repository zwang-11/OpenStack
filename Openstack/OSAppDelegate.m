//
//  OSAppDelegate.m
//  Openstack
//
//  Created by Zeng Wang on 8/28/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSAppDelegate.h"
#import "OSLoginViewController.h"
#import "OSInstancesViewController.h"
#import "OSDashboardTableViewController.h"

#define InstanceImageName @"instances.png"
#define DashboardImageName @"dashboard.png"

#define InstanceTabBarItemTitle @"Instances"
#define DashboardTabBarItemTitle @"Dashboard"

@implementation OSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *tabBarController=[[UITabBarController alloc] init];
    
    // First view Controller
    OSInstancesViewController *instancesViewController = [[OSInstancesViewController alloc] init];
    UINavigationController *firstNavController = [[UINavigationController alloc] initWithRootViewController:instancesViewController];
    
    // Second view controller
    OSDashboardTableViewController *dashboardViewController = [[OSDashboardTableViewController alloc] init];
    UINavigationController *secondNavController = [[UINavigationController alloc] initWithRootViewController:dashboardViewController];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects: firstNavController, secondNavController, nil];
    tabBarController.selectedIndex = 0;
    tabBarController.tabBar.translucent  = NO;
    UITabBarItem *itemOne= [[[tabBarController tabBar] items ]objectAtIndex:0];
    itemOne.image = [UIImage imageNamed:InstanceImageName];
    itemOne.title = InstanceTabBarItemTitle;
    
    UITabBarItem *itemTwo= [[[tabBarController tabBar] items ] objectAtIndex:1];
    itemTwo.image = [UIImage imageNamed:DashboardImageName];
    itemTwo.title = DashboardTabBarItemTitle;
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
