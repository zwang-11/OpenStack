//
//  OSInstancesViewController.m
//  Openstack
//
//  Created by Zeng Wang on 8/28/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSInstancesViewController.h"
#import "OSInstanceTableViewCell.h"
#import "OSSharedModel.h"
#import "OSServer.h"
#import "constants.h"
#import "OSInstanceDetailTableViewController.h"
#import "OSCreateInstanceTableViewController.h"
#import "OSLoginViewController.h"
#import "OSLoadingView.h"
#import "OSBillingViewController.h"

#define OSInstanceTableViewCellIdentifier @"OSInstanceTableViewCell"
#define NOInstanceMessage @"No Instance"
#define ConnectionError @"Connection Error"
#define LabelHeight 50
#define LabelWidth 300
#define ButtonWidth 100
#define ButtonHeight 40
#define ButtonTitle @"Refresh"
#define space 20
#define RightButtonTitle @"Log out"
#define LeftButtonTitle @"Create"
#define NavBarTitle @"Instances"
#define ConnectionErrorMessage @"Connection is failed. Can't get a list of instances."
#define TableViewCellHeight 150
#define RequireAuthorizationMessage @"Authentication required"
#define InstancesTitle @"Instances"

@interface OSInstancesViewController ()

@property (strong, nonatomic) NSArray*          servers;
@property (strong, nonatomic) UITableView*      tableView;
@property (strong, nonatomic) UIView*           messageView;
@property (strong, nonatomic) UILabel*          messageLabel;
@property (strong, nonatomic) UIButton*         refreshButton;
@property (strong, nonatomic) OSLoadingView*    loadingView;

@end

@implementation OSInstancesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self.messageView = [[UIView alloc] init];
        self.messageLabel = [[UILabel alloc] init];
        self.refreshButton = [[UIButton alloc] init];
        [self.refreshButton setTitle:ButtonTitle forState:UIControlStateNormal];
        
        [self.refreshButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.refreshButton addTarget:self action:@selector(refreshServers) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:RightButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:LeftButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(createNewInstance)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.title = NavBarTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];

    // add the loading view.
    [self.view addSubview:self.loadingView];
    
    // Register tableViewCell class
    UINib *instanceNib = [UINib nibWithNibName:OSInstanceTableViewCellIdentifier bundle:nil];
    [self.tableView registerNib:instanceNib forCellReuseIdentifier:OSInstanceTableViewCellIdentifier];
    
    // Add as notifications observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListOfServersSucceed:) name:GetListServersSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListOfServersFailed:) name:GetListServersFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionPerformedSuccessfully:) name:PerformActionSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionPerformedFailed:) name:PerformActionFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentBillingCOntroller:) name:ShowBillingNotification object:nil];
    
    // Set frame for subviews
    float subviewWidth = self.view.frame.size.width;
    float subviewHeight = self.view.frame.size.height;
    
    [self.tableView setFrame:CGRectMake(0, 66, subviewWidth, subviewHeight)];
    [self.messageView setFrame:CGRectMake(0, 0, subviewWidth, subviewHeight)];
    
    // Set message view's subview
    float labelOriginY = (subviewHeight - LabelHeight - ButtonHeight - space)/2;
    [self.messageLabel setFrame:CGRectMake((subviewWidth - LabelWidth)/2, labelOriginY, LabelWidth, LabelHeight)];
    [self.refreshButton setFrame:CGRectMake((subviewWidth - ButtonWidth)/2, labelOriginY + space + LabelHeight, ButtonWidth, ButtonHeight)];
    
    [self.messageView addSubview:self.messageLabel];
    [self.messageView addSubview:self.refreshButton];
    
    // Add subviews
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.messageView];
    self.tableView.hidden = YES;
    self.messageView.hidden = YES;

    self.tabBarItem.title = @"Instances";
    
    // If user is already logined in and token is still valid
    // Present next view controller
    if (![[OSSharedModel sharedModel].user isUserLoginedIn]) {
        OSLoginViewController *loginViewController = [[OSLoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [self refreshServers];
}

- (void) viewDidDisappear:(BOOL)animated
{
    self.tableView.hidden = YES;
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

// Function called when servers request responsed successfully
- (void) getListOfServersSucceed:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSArray *servers = [userInfo objectForKey:ListofServersKey];
    self.servers = servers;
    if ([servers count] > 0) {
        self.tableView.hidden = NO;
        self.messageView.hidden = YES;
        [self.tableView reloadData];
    }
    else {
        self.messageView.hidden = NO;
        self.messageLabel.text = NOInstanceMessage;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.refreshButton.hidden = YES;
    }

    self.isLoading  = NO;
    [self updateServers];

}

// Function called when servers request failed
- (void)getListOfServersFailed:(NSNotification *)notification
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ConnectionError
//                                                        message:ConnectionErrorMessage
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//    [alertView show];
    
    NSDictionary *userInfo = [notification userInfo];
    if ([[userInfo objectForKey:@"message"] isEqualToString:RequireAuthorizationMessage]) {
        OSLoginViewController *loginViewController = [[OSLoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
    
    self.tableView.hidden = YES;
    self.messageView.hidden = NO;
    self.messageLabel.text = ConnectionError;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.refreshButton.hidden = NO;
    
    self.isLoading  = NO;
}


- (void)presentBillingCOntroller:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    OSServer *server = [userInfo objectForKey:ServerKey];
    
    OSBillingViewController *billingViewController = [[OSBillingViewController alloc] init];
    billingViewController.server = server;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:billingViewController];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
// Loop
- (void)updateServers
{
    for (int i = 0; i < [self.servers count]; i++) {
        OSServer *server = [self.servers objectAtIndex:i];
        if (![server.taskState isEqualToString:@"None"]){
            [self performSelector:@selector(getListOfServers) withObject:nil afterDelay:5];
            return;
        }
    }
}

- (void)getListOfServers
{
    [[OSSharedModel sharedModel].requestManager getListOfServers];
}


// User logout
- (void)logout
{
    // Remove user info
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:UserdefaultTokenExpireKey];
    [defaults removeObjectForKey:UserdefaultTokenIDKey];
    [defaults removeObjectForKey:UserdefaultTenantIDKey];
    [defaults synchronize];
    
    OSLoginViewController *loginViewController = [[OSLoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

// Launch newinstance
- (void)createNewInstance
{
    OSCreateInstanceTableViewController *createInstanceTableViewController = [[OSCreateInstanceTableViewController alloc] init];
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:createInstanceTableViewController];
    [self.navigationController presentViewController:navigationViewController animated:YES completion:nil];
}

// refresh servers, make restAPI call
- (void)refreshServers
{
    // Request data
    [[OSSharedModel sharedModel].requestManager getListOfServers];
    self.isLoading  = YES;
    self.messageView.hidden = YES;
    self.tableView.hidden = YES;
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.servers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OSInstanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OSInstanceTableViewCellIdentifier];
    OSServer *server = [self.servers objectAtIndex:[indexPath row]];
    
    cell.selected = NO;
    
    // Reset cell's title and serverID
    [cell.buttonOne setTitle:@"" forState:UIControlStateNormal];
    cell.buttonOne.serverID = @"";
    [cell.buttonTwo setTitle:@"" forState:UIControlStateNormal];
    cell.buttonOne.serverID = @"";
    [cell.buttonThree setTitle:@"" forState:UIControlStateNormal];
    cell.buttonOne.serverID = @"";
    cell.instanceName.text = @"";
    cell.status.text = @"";
    cell.task.text = @"";
    cell.serverID = nil;
    
    cell.instanceName.text = server.serverName;
    cell.status.text = server.serverStatus;
    cell.task.text = server.taskState;
    cell.serverID = server.serverID;
    
    cell = [self setCellButtons:cell forCellStatus:server.serverStatus withTaskState:server.taskState withServerID:cell.serverID];
    return cell;
}


#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    
    OSInstanceDetailTableViewController *instanceDetailViewController = [[OSInstanceDetailTableViewController alloc] init];
    instanceDetailViewController.server = [self.servers objectAtIndex:[indexPath row]];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:instanceDetailViewController];
    
    [self.navigationController pushViewController:instanceDetailViewController animated:YES];
}


- (OSInstanceTableViewCell *)setCellButtons:(OSInstanceTableViewCell *)cell
                              forCellStatus:(NSString *)serverStatus
                              withTaskState:(NSString *)serverTask
                               withServerID:(NSString *)serverID
{
    if (![serverTask isEqualToString:@"None"]) {
        cell.buttonOne.userInteractionEnabled = NO;
        cell.buttonTwo.userInteractionEnabled = NO;
        cell.buttonThree.userInteractionEnabled = NO;
        
        return cell;
    }
    
    if ([serverStatus isEqualToString:ServerStatusActive]) {
        cell.buttonOne.userInteractionEnabled = YES;
        cell.buttonTwo.userInteractionEnabled = YES;
        cell.buttonThree.userInteractionEnabled = YES;
        
        cell.buttonOne.serverID = cell.serverID;
        cell.buttonTwo.serverID = cell.serverID;
        cell.buttonThree.serverID = cell.serverID;
        
        cell.buttonOne = [self setPauseButton:cell.buttonOne];
        cell.buttonTwo = [self setSuspendButton:cell.buttonTwo];
        cell.buttonThree = [self setShutoffButton:cell.buttonThree];
    }
    else if ([serverStatus isEqualToString:ServerStatusPaused])
    {
        cell.buttonOne.userInteractionEnabled = NO;
        cell.buttonTwo.userInteractionEnabled = NO;
        cell.buttonThree.userInteractionEnabled = YES;
        
        cell.buttonThree.serverID = cell.serverID;
        
        cell.buttonThree = [self setUnpauseButton:cell.buttonThree];
    }
    else if ([serverStatus isEqualToString:ServerStatusShutoff])
    {
        cell.buttonOne.userInteractionEnabled = NO;
        cell.buttonTwo.userInteractionEnabled = YES;
        cell.buttonThree.userInteractionEnabled = YES;
        
        cell.buttonTwo.serverID = cell.serverID;
        cell.buttonThree.serverID = cell.serverID;
        
        cell.buttonTwo = [self setSoftRebootButton:cell.buttonTwo];
        cell.buttonThree = [self setHardRebootButton:cell.buttonThree];
    }
    else if ([serverStatus isEqualToString:ServerStatusSuspend])
    {
        cell.buttonOne.userInteractionEnabled = NO;
        cell.buttonTwo.userInteractionEnabled = NO;
        cell.buttonThree.userInteractionEnabled = YES;
        
        cell.buttonThree.serverID = cell.serverID;
        
        cell.buttonThree = [self setResumeButton:cell.buttonThree];
    }
    else if ([serverStatus isEqualToString:ServerStatusStopped])
    {
        cell.buttonOne.userInteractionEnabled = NO;
        cell.buttonTwo.userInteractionEnabled = NO;
        cell.buttonThree.userInteractionEnabled = YES;
        
        cell.buttonThree.serverID = cell.serverID;
        
        cell.buttonThree = [self setRebootButton:cell.buttonThree];
    }
    else
    {
        cell.buttonOne.userInteractionEnabled = NO;
        cell.buttonTwo.userInteractionEnabled = NO;
        cell.buttonThree.userInteractionEnabled = NO;
    }
    return cell;
}

// Configure buttons
- (OSCellButton *)setShutoffButton:(OSCellButton *)button
{
    [button setTitle:ServerShutoffTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (OSCellButton *)setStartButton:(OSCellButton *)button
{
    button.titleLabel.text = ServerStartTitle;
    [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (OSCellButton *)setSuspendButton:(OSCellButton *)button
{
    [button setTitle:ServerSuspendTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (OSCellButton *)setPauseButton:(OSCellButton *)button
{
    [button setTitle:ServerPauseTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (OSCellButton *)setUnpauseButton:(OSCellButton *)button
{
    [button setTitle:ServerUnpauseTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (OSCellButton *)setResumeButton:(OSCellButton *)button
{
    [button setTitle:ServerResumeTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (OSCellButton *)setSoftRebootButton:(OSCellButton *)button
{
    [button setTitle:ServerSoftRebootTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (OSCellButton *)setHardRebootButton:(OSCellButton *)button
{
    [button setTitle:ServerHardRebootTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (OSCellButton *)setRebootButton:(OSCellButton *)button
{
    [button setTitle:ServerRebootTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// Make server call
- (void)performAction:(OSCellButton *)sender
{
    if (sender.serverID && ![sender.serverID isEqualToString:@""])
    {
        NSLog(@"%@", sender.serverID);
        [[OSSharedModel sharedModel].requestManager performInstanceAction:sender.serverID forAction:sender.titleLabel.text];
    }
}

// Action is performed successfully
- (void)actionPerformedSuccessfully:(NSNotification *)notification
{
    [[OSSharedModel sharedModel].requestManager getListOfServers];
}

// Action is performed failed
- (void)actionPerformedFailed:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    if (userInfo) {
        NSString *message = [userInfo objectForKey:@"message"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Conficting Request"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Action Error"
                                                            message:@"Action is failed."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

// Update server status
- (NSString *)updateServerStatus:(NSString *)action
{
    if ([action isEqualToString:ServerPauseTitle]) {
        return ServerStatusPaused;
    }
    else if ([action isEqualToString:ServerShutoffTitle])
    {
        return ServerStatusShutoff;
    }
    else if ([action isEqualToString:ServerSuspendTitle])
    {
        return ServerStatusSuspend;
    }
    else
    {
        return ServerStatusActive;
    }
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
