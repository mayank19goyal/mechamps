//
//  SignupViewController.m
//  Appathon
//
//  Created by Shreyansh Bhardwaj on 09/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import "SignupViewController.h"
#import "constants.h"
#import "DashboardViewController.h"


@interface SignupViewController() <BaseWebAccessLayerDelegate>
{
    WebAccessLayer *webLayer;
}

@end


@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Testing push
    
    [self.navigationController setNavigationBarHidden:NO];

    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

    self.signupButton.layer.cornerRadius = 5.0;
    self.signupButton.backgroundColor = kmPayThemeColor;

    self.navigationItem.title = @"Signup";
    self.navigationController.navigationBar.titleTextAttributes= kDashboardTitleColor;
    self.firstname.layer.borderWidth = 1.0;
    self.firstname.layer.borderColor = kTextFieldBorderColor;

    self.lastname.layer.borderWidth = 1.0;
    self.lastname.layer.borderColor = kTextFieldBorderColor;

    self.email.layer.borderWidth = 1.0;
    self.email.layer.borderColor = kTextFieldBorderColor;

    self.mobileNo.layer.borderWidth = 1.0;
    self.mobileNo.layer.borderColor = kTextFieldBorderColor;

    self.password.layer.borderWidth = 1.0;
    self.password.layer.borderColor = kTextFieldBorderColor;
    self.password.secureTextEntry = YES;
    
    self.verifyPassword.layer.borderWidth = 1.0;
    self.verifyPassword.layer.borderColor = kTextFieldBorderColor;
    self.verifyPassword.secureTextEntry = YES;
}

- (IBAction)setPasscodeTapped:(id)sender {
    [[LTHPasscodeViewController sharedUser] setIsSimple:NO inViewController:self asModal:YES];
    [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self asModal:YES];
    [LTHPasscodeViewController sharedUser].delegate = self;
    [LTHPasscodeViewController sharedUser].maxNumberOfAllowedFailedAttempts = 5;
}

- (IBAction)useTouchIDTapped:(id)sender {
    LAContext *localAuthenticationContext = [[LAContext alloc] init];
    __autoreleasing NSError *authenticatingError;
    NSString *localizedReasonString = NSLocalizedString(@"Goto Dashboard", @"Touch ID for "Appathon"");
    localAuthenticationContext.localizedFallbackTitle = @"Enter Passcode";
    if ([localAuthenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authenticatingError]) {
        [localAuthenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReasonString reply:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"success");
                //Goto to dashboard
            } else {
                if (error.code == LAErrorUserFallback) {
                    [self setPasscodeTapped:self];
                }
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"Touch ID Not available for this device, use passcode" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
//        [self setPasscodeTapped:self];
    }
}
- (IBAction)signupButtonTapped:(id)sender {
    
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    if(_firstname.text.length == 0 || _email.text.length == 0 || _mobileNo.text.length == 0 || _password.text.length == 0 || _verifyPassword.text.length == 0)
    {
        [self showAlertWithMessage:@"Please enter all the fields."];
        return;
    }
    
    else if(![self NSStringIsValidEmail:_email.text])
    {
        [self showAlertWithMessage:@"Please enter valid email address."];
        return;
    }
    
    else if ([_mobileNo.text rangeOfCharacterFromSet:notDigits].location != NSNotFound)
    {
        [self showAlertWithMessage:@"Please enter valid mobile number."];
        return;
    }
    else if(![_password.text isEqualToString:_verifyPassword.text])
    {
        [self showAlertWithMessage:@"Password and confirm password do not match."];
        return;
    }
    
    [APP_DELEGATE showLaoder];
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *body = [NSString stringWithFormat:@"{\"mobileNo\": \"%@\", \"emailId\": \"%@\", \"firstName\": \"%@\", \"lastName\": \"%@\", \"password\": \"%@\" }", _mobileNo.text , _email.text, _firstname.text, _lastname.text, _password.text];
    
    
    if([APP_DELEGATE isServerReachable])
    {
        if(webLayer)
        {
            webLayer.callBack = nil;
            webLayer = nil;
        }
        webLayer = [WebAccessLayer new];
        webLayer.callBack = self;
        [webLayer getDataFromWeService:YES withURL:HOME_URL(@"createUser") withBody:body withTag:1];
    }
    else
    {
        [APP_DELEGATE showNoInternetAlert];
    }

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
    
    NSString *strResponse = [result objectForKey:@"response"];
    NSString *strMessage = [result objectForKey:@"Message"];
    
    if([strResponse isKindOfClass:[NSString class]])
    {
        NSDictionary *ditcData = (NSDictionary *)result;
        [[UserBO sharedObject] setUserId:strResponse];
        [[UserBO sharedObject] setEmail:_email.text];
        [[UserBO sharedObject] setFirstName:_firstname.text];
        [[UserBO sharedObject] setLastName:_lastname.text];
        [[UserBO sharedObject] setMobileNumber:_mobileNo.text];
        [[UserBO sharedObject] setPassword:_password.text];
        
        [self performSelectorOnMainThread:@selector(navigateToHomeview) withObject:nil waitUntilDone:YES ];
        
        
    }
    else if([strMessage isKindOfClass:[NSString class]])
    {
        [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:[result objectForKey:@"Message"] waitUntilDone:YES ];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:[result objectForKey:@"message"] waitUntilDone:YES ];
    }
}

-(void)navigateToHomeview
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!!" message:strMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    alert = nil;
    
}
@end
