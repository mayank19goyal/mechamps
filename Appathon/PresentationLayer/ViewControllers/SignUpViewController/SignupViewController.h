//
//  SignupViewController.h
//  Appathon
//
//  Created by Shreyansh Bhardwaj on 09/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTHPasscodeViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "CustomTextField.h"

@interface SignupViewController : UIViewController<LTHPasscodeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet CustomTextField *firstname;
@property (strong, nonatomic) IBOutlet CustomTextField *lastname;

@property (strong, nonatomic) IBOutlet CustomTextField *email;
@property (strong, nonatomic) IBOutlet CustomTextField *mobileNo;
@property (strong, nonatomic) IBOutlet CustomTextField *password;
@property (strong, nonatomic) IBOutlet CustomTextField *verifyPassword;

//@property (strong, nonatomic) IBOutlet UIButton *setPasscode;
//@property (strong, nonatomic) IBOutlet UIButton *useTouchID;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;


@end
