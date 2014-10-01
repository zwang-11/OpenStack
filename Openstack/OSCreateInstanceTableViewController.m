//
//  OSCreateInstanceTableViewController.m
//  Openstack
//
//  Created by Zeng Wang on 9/11/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSCreateInstanceTableViewController.h"
#import "OSFormTextFieldTableViewCell.h"
#import "OSSharedModel.h"
#import "OSInstanceDetailTableViewController.h"
#import "OSNetwork.h"
#import "OSSecurityGroup.h"
#import "OSLoadingView.h"

#define TextFieldTableViewCellIdentifier @"OSFormTextFieldTableViewCell"

@interface OSCreateInstanceTableViewController () <UIAlertViewDelegate, UITextFieldDelegate, DataPickTableViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *imageID;
@property (strong, nonatomic) NSString *flavorID;
@property (strong, nonatomic) NSString *networkID;
@property (strong, nonatomic) NSString *securityGroup;
@property (strong, nonatomic) NSString *serverID;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *flavors;
@property (strong, nonatomic) NSArray *networks;
@property (strong, nonatomic) NSArray *securityGroups;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) OSLoadingView *loadingView;

@end

@implementation OSCreateInstanceTableViewController

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource   = self;
    self.tableView.delegate     = self;
    [self.view addSubview:self.tableView];
    [self.tableView setFrame:self.view.frame];
}

- (void)initLoadingView
{
    [self.view addSubview:self.loadingView];
    self.isLoading = NO;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableView];
    [self initLoadingView];
    
    // Register tableviewcell
    UINib *tableViewCellNib = [UINib nibWithNibName:TextFieldTableViewCellIdentifier bundle:nil];
    [self.tableView registerNib:tableViewCellNib forCellReuseIdentifier:TextFieldTableViewCellIdentifier];
    
    // Navigationbar
    self.navigationItem.title = @"New Instance";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNewInstance)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneNewInstance)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];

    // Add observer for notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createNewInstaceSuccessfully:) name:CreateInstanceSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createNewInstaceFailed) name:CreateInstanceFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListSuccessfully:) name:GetListSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListFailed) name:GetListFailedNotification object:nil];

    // Get available images, flavros, networks and security Groups
    [[OSSharedModel sharedModel].requestManager getListOfImages];
    [[OSSharedModel sharedModel].requestManager getListOfFlavors];
    [[OSSharedModel sharedModel].requestManager getListOfNetworks];
    [[OSSharedModel sharedModel].requestManager getListOfSecurityGroups];
    
    self.isLoading = YES;
    self.tableView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Cancel create new instance
- (void)cancelNewInstance
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Commit create new instance
- (void)doneNewInstance
{
    if (![self validateInputs])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"All the fields are required. Please try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    self.isLoading = YES;
    self.tableView.hidden = YES;
    
    // Get instance name cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    OSFormTextFieldTableViewCell *cell = (OSFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [[OSSharedModel sharedModel].requestManager createNewInstance:cell.propertyValue.text withImage:self.imageID withFlavor:self.flavorID withNetwork:self.networkID withSecurityGroup:self.securityGroup];
    

}

// Validate Inputs
- (BOOL)validateInputs
{
    // Get instance name cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    OSFormTextFieldTableViewCell *cell = (OSFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [cell.propertyValue.text stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        return FALSE;
    }
    
    if (!self.imageID || !self.flavorID || !self.networkID || !self.securityGroup)
    {
        return FALSE;
    }
    return TRUE;
}

// Create new instance successfully
- (void)createNewInstaceSuccessfully:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSError* error;
    NSDictionary* responseDict = [NSJSONSerialization
                                  JSONObjectWithData:[userInfo objectForKey:@"response"]
                                  options:kNilOptions
                                  error:&error];
     self.serverID = [[responseDict objectForKey:@"server"] objectForKey:@"id"];

    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Succeeded"
                                                        message:@"New instace is created successfully."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Create new instance failed
- (void)createNewInstaceFailed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                        message:@"Create new instance error."
                                                        delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [alertView show];
}


- (void)getListSuccessfully:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    if ([[userInfo allKeys] containsObject:ImagesArrayKey]) {
        self.images = [userInfo objectForKey:ImagesArrayKey];
    }
    
    if ([[userInfo allKeys] containsObject:FlavorsArrayKey]) {
        self.flavors = [userInfo objectForKey:FlavorsArrayKey];
    }
    if ([[userInfo allKeys] containsObject:NetworksArrayKey]) {
        self.networks = [userInfo objectForKey:NetworksArrayKey];
    }
    if ([[userInfo allKeys] containsObject:SecurityGroupsArrayKey]) {
        self.securityGroups= [userInfo objectForKey:SecurityGroupsArrayKey];
    }
    
    if (self.images && self.flavors && self.networks && self.securityGroups) {
        self.isLoading = NO;
        self.tableView.hidden = NO;
    }
}

- (void)getListFailed
{
    
}

#pragma mark - Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Name
    //Image
    //Flavor
    //Network
    //SecurityGroups
    
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OSFormTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldTableViewCellIdentifier forIndexPath:indexPath];
    cell.propertyName.text = @"";
    cell.propertyValue.text = @"";
    cell.propertyValue.placeholder = @"";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.propertyValue.delegate = self;
    
    if ([indexPath row] == 0){
        cell.propertyName.text = @"Instance Name*";
        cell.propertyValue.placeholder = @"Add Instance Name";
    }
    else if ([indexPath row] == 1){
        cell.propertyName.text = @"Image*";
        cell.propertyValue.placeholder = @"Add Image";
    }
    else if ([indexPath row] == 2){
        cell.propertyName.text = @"Flavor*";
        cell.propertyValue.placeholder = @"Add Flavor";
    }
    else if ([indexPath row] == 3){
        cell.propertyName.text = @"Network*";
        cell.propertyValue.placeholder = @"Add Network";
        
    }
    else if ([indexPath row] == 4){
        cell.propertyName.text = @"Security Group*";
        cell.propertyValue.placeholder = @"Add Security Group";
    }
    return cell;
}

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}


#pragma mark - Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSIndexPath *indexPath;
    OSFormTextFieldTableViewCell *textFieldCell = [[OSFormTextFieldTableViewCell alloc] init];
    
    // Image cell
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    textFieldCell = (OSFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([textFieldCell.propertyValue isFirstResponder])
    {
        OSDataPickTableViewController *dataPickerTableViewController = [[OSDataPickTableViewController alloc] initWithStyle:UITableViewStylePlain];
        dataPickerTableViewController.delegate = self;
        dataPickerTableViewController.dataArray = self.images;
        dataPickerTableViewController.propertyName = ImagePropertyName;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dataPickerTableViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    
    // flavor cell
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    textFieldCell = (OSFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([textFieldCell.propertyValue isFirstResponder])
    {
        OSDataPickTableViewController *dataPickerTableViewController = [[OSDataPickTableViewController alloc] initWithStyle:UITableViewStylePlain];
        dataPickerTableViewController.delegate = self;
        dataPickerTableViewController.dataArray = self.flavors;
        dataPickerTableViewController.propertyName = FlavorPropertyName;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dataPickerTableViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    
    // network cell
    indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    textFieldCell = (OSFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([textFieldCell.propertyValue isFirstResponder])
    {
        OSDataPickTableViewController *dataPickerTableViewController = [[OSDataPickTableViewController alloc] initWithStyle:UITableViewStylePlain];
        dataPickerTableViewController.delegate = self;
        dataPickerTableViewController.dataArray = self.networks;
        dataPickerTableViewController.propertyName = NetworkPropertyName;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dataPickerTableViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    
    // security group cell
    indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    textFieldCell = (OSFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([textFieldCell.propertyValue isFirstResponder])
    {
        OSDataPickTableViewController *dataPickerTableViewController = [[OSDataPickTableViewController alloc] initWithStyle:UITableViewStylePlain];
        dataPickerTableViewController.delegate = self;
        dataPickerTableViewController.dataArray = self.securityGroups;
        dataPickerTableViewController.propertyName = SecurityGroupPropertyName;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dataPickerTableViewController];
        
        [self presentViewController:navigationController animated:YES completion:nil];
    }

}

#pragma mark - DataPickTableViewControllerDelegate
- (void)dataPickTableView:(OSDataPickTableViewController *)dataPickTableView didSelectData:(NSString *)dataID withDataName:(NSString *)dataName forProperty:(NSString *)propertyName
{
    NSIndexPath *indexPath;
    OSFormTextFieldTableViewCell *textFieldCell = [[OSFormTextFieldTableViewCell alloc] init];

    if ([propertyName isEqualToString:ImagePropertyName]) {
        self.imageID = dataID;
        // image cell
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        textFieldCell = (OSFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        textFieldCell.propertyValue.text = dataName;
    }
    else if ([propertyName isEqualToString:FlavorPropertyName]) {
        self.flavorID = dataID;
        // flavor cell
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        textFieldCell = (OSFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        textFieldCell.propertyValue.text = dataName;
    }
    else if ([propertyName isEqualToString:NetworkPropertyName]) {
        self.networkID = dataID;
        // network cell
        indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        textFieldCell = (OSFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        textFieldCell.propertyValue.text = dataName;
    }
    else if ([propertyName isEqualToString:SecurityGroupPropertyName]) {
        self.securityGroup = dataName;
        // securityGroup cell
        indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        textFieldCell = (OSFormTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        textFieldCell.propertyValue.text = dataName;
    }
}

@end
