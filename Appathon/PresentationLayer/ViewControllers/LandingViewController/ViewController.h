//
//  ViewController.h
//  Appathon
//
//  Created by Shreyansh Bhardwaj on 09/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTHPasscodeViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "AppthoneBaseViewController.h"
@interface ViewController : AppthoneBaseViewController<LTHPasscodeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;

@end

