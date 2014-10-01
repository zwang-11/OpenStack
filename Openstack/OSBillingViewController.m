//
//  OSBillingViewController.m
//  Openstack
//
//  Created by Zeng Wang on 9/14/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSBillingViewController.h"
#import "constants.h"

#define NavBarTitle @"Payment"

@interface OSBillingViewController () <UIAlertViewDelegate>

@end

@implementation OSBillingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.instanceNameLabel.text = self.server.serverName;
    self.usageRateLabel.text = [NSString stringWithFormat:@"%d", self.server.usageRate];
    
    NSDictionary *billingDict = [self.server createBillingDict];
    self.usageTimeLabel.text = [billingDict objectForKey:UptimeKey];
    self.totalBillLabel.text = [billingDict objectForKey:BillingAmountKey];
    
    self.navigationItem.title = NavBarTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
}

- (NSNumber *)minutesBetweenNowAndCreatedTime {
    // Convert expire string into GMT date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    [dateFormatter setDateFormat:DateFormatToPrint];
    NSDate *createdTime = [[NSDate alloc] init];
    createdTime = [dateFormatter dateFromString:self.server.createdTime];
    NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:createdTime];
    
    double secondsInMinute = 60;
    NSNumber *minitesBetweenDates = [[NSNumber alloc] initWithInteger:(distanceBetweenDates / secondsInMinute)];
    
    return minitesBetweenDates;
}

- (IBAction)billPayed:(id)sender{
    NSString *message = [NSString stringWithFormat:@"%@ has been chaged from your credit card. Thank you.", self.totalBillLabel.text];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thank you"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
