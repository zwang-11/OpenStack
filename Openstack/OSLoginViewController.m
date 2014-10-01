//
//  OSLoginViewController.m
//  Openstack
//
//  Created by Zeng Wang on 8/28/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSLoginViewController.h"
#import "OSSharedModel.h"
#import "OSInstancesViewController.h"
#import "constants.h"
#import "AFNetworking.h"
#import "OSUser.h"
#import "OSLoadingView.h"

@interface OSLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) OSLoadingView *loadingView;


@end

@implementation OSLoginViewController

- (void) initLoadingView
{
    [self.view addSubview:self.loadingView];
    self.loadingView.titleLabel.text = @"Signing in";
    self.isLoading = NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [self initLoadingView];
    
    // Hide navigation bar
    self.navigationController.navigationBar.hidden = YES;
    
    // Add observer for notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceeded) name:UserLoginSucceedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:UserLoginFailedNotification object:nil];
}

- (IBAction)login:(id)sender
{
    BOOL isValidInput = [self checkInputValue];
    if (isValidInput == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid" message:@"Username and Password are required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [[OSSharedModel sharedModel].requestManager loginWithUsername:self.usernameTextField.text withPassword:self.passwordTextField.text];
        self.isLoading = YES;
    }
}

- (BOOL)checkInputValue
{
    if ([self.usernameTextField.text isEqualToString: @""]) {
        return NO;
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void)loginSucceeded
{
    // Show instances view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginFailed
{
    // Reset username and password filed
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                        message:@"Invalid Username or Password. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    self.isLoading = NO;
}

// TestField delegate function
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
