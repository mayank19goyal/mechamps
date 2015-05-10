//
//  LoginViewController.m
//  Appathon
//
//  Created by Shreyansh Bhardwaj on 09/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import "LoginViewController.h"
#import "constants.h"
#import "WalletViewController.h"
#import "DashboardViewController.h"

@interface LoginViewController() <BaseWebAccessLayerDelegate>
{
    WebAccessLayer *webLayer;
}
@end


@implementation LoginViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

//    UIImageView *imgHeder=    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoSplash"]];
//    imgHeder.frame = CGRectMake(0, 10, 120, 44);
//    imgHeder.contentMode=UIViewContentModeScaleAspectFit;
//    [self.navigationItem setTitleView:imgHeder];
    
//    self.forgetPasswordButton.titleLabel.textColor = kThemeColor;
//    [self.forgetPasswordButton setTitleColor:kThemeColor forState:UIControlStateNormal];
//    [self.forgetPasswordButton setTitleColor:kThemeColor forState:UIControlStateHighlighted];
    
    self.navigationItem.title = @"Login";
//    self.navigationController.navigationBar.titleTextAttributes= kDashboardTitleColor;

    self.loginButton.layer.cornerRadius = 5.0;
    self.loginButton.backgroundColor = kmPayThemeColor;
    self.navigationItem.title = @"Login";
    self.navigationController.navigationBar.titleTextAttributes= kDashboardTitleColor;
    self.passwordTextField.secureTextEntry = YES;
    
    self.usernameTextField.layer.borderWidth = 1.0;
    self.usernameTextField.layer.borderColor = kTextFieldBorderColor;

    self.passwordTextField.layer.borderWidth = 1.0;
    self.passwordTextField.layer.borderColor = kTextFieldBorderColor;
}

-(IBAction) forgetPasswordtapped:(id) sender {
}

 - (IBAction)loginButtonTapped:(id)sender
{
    
    if(_usernameTextField.text.length == 0 || _passwordTextField.text.length == 0)
    {
        [self showAlertWithMessage:@"Please enter all the fields."];
        return;
    }
    
    BOOL isMobileNumber = NO;
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([_usernameTextField.text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        // newString consists only of the digits 0 through 9
        isMobileNumber = YES;
    }
    
    if(![self NSStringIsValidEmail:_usernameTextField.text] && !isMobileNumber)
    {
        [self showAlertWithMessage:@"Please enter valid email address."];
        return;
    }
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [APP_DELEGATE showLaoder];
    
    NSString *body = [NSString stringWithFormat:@"{\"mobileNo\":\"%@\", \"password\":\"%@\", \"emailId\":\"%@\"}", isMobileNumber?_usernameTextField.text:@"",_passwordTextField.text,isMobileNumber?@"":_usernameTextField.text];
    // 9599765900 // 123456
    if([APP_DELEGATE isServerReachable])
    {
        if(webLayer)
        {
            webLayer.callBack = nil;
            webLayer = nil;
        }
        webLayer = [WebAccessLayer new];
        webLayer.callBack = self;
        [webLayer getDataFromWeService:YES withURL:HOME_URL(@"login") withBody:body withTag:1];
    }
    else
    {
        [APP_DELEGATE showNoInternetAlert];
    }
    
    //     DashboardViewController *vwCont= [[DashboardViewController alloc] init];
    //     [self.navigationController pushViewController:vwCont animated:YES];
}



// Pushpendra
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma WebAccessLayer Delegate Methods

- (void)operationCompletedSuccessfully:(id)result andOperationTag:(NSInteger)tag
{
    [APP_DELEGATE performSelectorOnMainThread:@selector(hideLoader) withObject:nil waitUntilDone:YES];
    
    NSLog(@"%@", (NSDictionary *)result);
    if([result isKindOfClass:[NSDictionary class]])
    {
        /*
         "_id" = 554e3147d7c5e9310056b0b9;
         emailId = "bansal.defi@gmail.com";
         firstName = Defi;
         lastName = Bansal;
         mobileNo = 9599765900;
         password = 123456;
         userId = hzgh5196
         */
        
        NSDictionary *ditcData = (NSDictionary *)result;
        if([[ditcData objectForKey:@"Message"] length])
        {
            [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:[ditcData objectForKey:@"Message"] waitUntilDone:YES ];
        }
        else
        {
            [[UserBO sharedObject] setUserId:[ditcData objectForKey:@"userId"]];
            [[UserBO sharedObject] setEmail:[ditcData objectForKey:@"emailId"]];
            [[UserBO sharedObject] setFirstName:[ditcData objectForKey:@"firstName"]];
            [[UserBO sharedObject] setLastName:[ditcData objectForKey:@"lastName"]];
            [[UserBO sharedObject] setMobileNumber:[ditcData objectForKey:@"mobileNo"]];
            [[UserBO sharedObject] setPassword:[ditcData objectForKey:@"password"]];
            [self performSelectorOnMainThread:@selector(navigateToHomeView) withObject:nil waitUntilDone:YES ];
            
        }
        
    }
    else if([result isKindOfClass:[NSArray class]])
    {
        NSArray *arrResponse = (NSArray *)result;
        NSDictionary *ditcData = [arrResponse firstObject];
        [[UserBO sharedObject] setUserId:[ditcData objectForKey:@"userId"]];
        [[UserBO sharedObject] setEmail:[ditcData objectForKey:@"emailId"]];
        [[UserBO sharedObject] setFirstName:[ditcData objectForKey:@"firstName"]];
        [[UserBO sharedObject] setLastName:[ditcData objectForKey:@"lastName"]];
        [[UserBO sharedObject] setMobileNumber:[ditcData objectForKey:@"mobileNo"]];
        [[UserBO sharedObject] setPassword:[ditcData objectForKey:@"password"]];
        
        [self performSelectorOnMainThread:@selector(navigateToHomeView) withObject:nil waitUntilDone:YES ];
        
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:@"Error occurred while authenticating user. Please try again later." waitUntilDone:YES ];
    }
}

-(void)navigateToHomeView
{
    
    DashboardViewController *vwCont= [[DashboardViewController alloc] init];
    [self.navigationController pushViewController:vwCont animated:YES];
    
}
- (void)errorOccuredWhilePerformingOperation:(NSError *)error andTag:(NSInteger)tag
{
 [APP_DELEGATE performSelectorOnMainThread:@selector(hideLoader) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:error.localizedDescription waitUntilDone:YES ];
}


-(void)showAlertWithMessage:(NSString *)strMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!!" message:strMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    alert = nil;
    
}
@end
