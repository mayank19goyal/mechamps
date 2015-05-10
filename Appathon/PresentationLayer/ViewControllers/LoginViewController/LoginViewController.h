//
//  LoginViewController.h
//  Appathon
//
//  Created by Shreyansh Bhardwaj on 09/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (strong, nonatomic) IBOutlet CustomTextField *usernameTextField;

@property (strong, nonatomic) IBOutlet CustomTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@end
