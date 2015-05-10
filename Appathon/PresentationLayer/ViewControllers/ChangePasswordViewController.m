//
//  ChangePasswordViewController.m
//  Appathon
//
//  Created by Shreyansh Bhardwaj on 10/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import "ChangePasswordViewController.h"

@implementation ChangePasswordViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showChangePasswordView];
    
}

-(void)showChangePasswordView
{
    vwPasswordView = [ChangePasswordView sharedDashboard];
    vwPasswordView.delegate = self;
    [vwPasswordView showChangePasswordView:self.view];
}


-(void)updatePassword:(NSString*)strOldPass withNewPassword:(NSString *)strNewPass
{
    [[[UIAlertView alloc] initWithTitle:@"In Progress!!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

//    [vwPasswordView hideChangePasswordView];
}

@end
