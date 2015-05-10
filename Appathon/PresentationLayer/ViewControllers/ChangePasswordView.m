//
//  ChangePasswordView.m
//  SampleDashboard
//
//  Created by Manoj Kumar Das on 09/05/15.
//  Copyright (c) 2015 MySelf. All rights reserved.
//

#import "ChangePasswordView.h"
#import "constants.h"
@interface ChangePasswordView()
{
    UITextField *txtFld_OldPass;
    UITextField *txtFld_NewPass;
    UITextField *txtFld_NewPassConf;
}

@end


@implementation ChangePasswordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (ChangePasswordView *)sharedDashboard {
    static ChangePasswordView *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)showChangePasswordView:(UIView *)vw
{
//    self.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    
    
    
    self.frame = vw.bounds;
    
    
    
    CABasicAnimation *fadeInAnimation;
    fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration = 0.5;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    [fadeInAnimation setDelegate:self];
    [vw addSubview:self];
    [self.layer addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    
    
    [self designInterface];
}

-(void)designInterface
{
    
//    UIButton *btnBg = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnBg.backgroundColor = [UIColor clearColor];
//    [btnBg addTarget:self action:@selector(hideChangePasswordView) forControlEvents:UIControlEventTouchUpInside];
//    btnBg.frame = self.bounds;
//    [self addSubview:btnBg];
    
    
    UIView *vwBg = [[UIView alloc] initWithFrame:CGRectMake(0, 95, CGRectGetWidth(self.frame), 44*3)];
    vwBg.backgroundColor = [UIColor clearColor];
    vwBg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    vwBg.layer.borderWidth = 0.5;
    vwBg.clipsToBounds = YES;
    
    //    firstrun-background
    UIImageView *imgBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"firstrun-background.png"]];
    imgBG.backgroundColor = [UIColor clearColor];
    imgBG.userInteractionEnabled = YES;
    imgBG.frame = self.bounds;
    [vwBg addSubview:imgBG];

    [self addSubview:vwBg];
    
    

    float xPos = 20;
    float yPos = 0;
    float width = CGRectGetWidth(vwBg.frame)-xPos;
    float height = 44;
    
    txtFld_OldPass = [[UITextField alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
    txtFld_OldPass.backgroundColor = [UIColor clearColor];
    txtFld_OldPass.borderStyle = UITextBorderStyleNone;
    txtFld_OldPass.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtFld_OldPass.secureTextEntry = YES;
    txtFld_OldPass.placeholder = @"Current password";
    [txtFld_OldPass setFont:[UIFont systemFontOfSize:14.0]];
    [vwBg addSubview:txtFld_OldPass];
    [txtFld_OldPass becomeFirstResponder];

    yPos+=height;
    [self addSeparatorToView:vwBg atPosition:yPos-1 atXposition:xPos];

    txtFld_NewPass = [[UITextField alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
    txtFld_NewPass.backgroundColor = [UIColor clearColor];
    txtFld_NewPass.borderStyle = UITextBorderStyleNone;
    txtFld_NewPass.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtFld_NewPass.secureTextEntry = YES;
    [txtFld_NewPass setFont:[UIFont systemFontOfSize:14.0]];

    txtFld_NewPass.placeholder = @"New password";
    [vwBg addSubview:txtFld_NewPass];

    yPos+=height;
    [self addSeparatorToView:vwBg atPosition:yPos-1 atXposition:xPos];

    txtFld_NewPassConf = [[UITextField alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
    txtFld_NewPassConf.backgroundColor = [UIColor clearColor];
    txtFld_NewPassConf.borderStyle = UITextBorderStyleNone;
    txtFld_NewPassConf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [txtFld_NewPassConf setFont:[UIFont systemFontOfSize:14.0]];

    txtFld_NewPassConf.secureTextEntry = YES;
    txtFld_NewPassConf.placeholder = @"Confirm password";
    [vwBg addSubview:txtFld_NewPassConf];

//    yPos+=height;
//    [self addSeparatorToView:vwBg atPosition:yPos-1 atXposition:xPos];
    
    yPos=CGRectGetMaxY(vwBg.frame)+50;
    UIButton *btnChangePass = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChangePass.backgroundColor = kThemeColor;
    [btnChangePass setTitle:@"Change Password" forState:UIControlStateNormal];
    btnChangePass.layer.cornerRadius = 6.0;
    [btnChangePass addTarget:self action:@selector(btnChangePasswordClicked) forControlEvents:UIControlEventTouchUpInside];
    btnChangePass.frame = CGRectMake(xPos, yPos, CGRectGetWidth(vwBg.frame)-(xPos*2), 40);
    [self addSubview:btnChangePass];
}


-(void)addSeparatorToView:(UIView *)vwBg atPosition:(float)yPos atXposition:(float)xPos
{
    UIImageView *imgSep = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, yPos-1, CGRectGetWidth(self.frame)-xPos, 0.5)];
    imgSep.backgroundColor = [UIColor lightGrayColor];
    [vwBg addSubview:imgSep];
}


-(void)hideChangePasswordView
{
    CABasicAnimation *fadeInAnimation;
    fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration = 1.5;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    [fadeInAnimation setDelegate:self];
    [self removeFromSuperview];
    [self.layer addAnimation:fadeInAnimation forKey:@"animateOpacity"];
}
-(void)btnChangePasswordClicked
{
    if(txtFld_OldPass.text.length == 0 || txtFld_NewPass.text.length == 0 || txtFld_NewPass.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Sorry!!" message:@"Please enter all the fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    else if(![txtFld_NewPass.text isEqualToString:txtFld_NewPassConf.text])
    {
        [[[UIAlertView alloc] initWithTitle:@"Sorry!!" message:@"New password and confirm password do not match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(updatePassword:withNewPassword:)])
        {
            [self.delegate performSelector:@selector(updatePassword:withNewPassword:) withObject:txtFld_OldPass.text withObject:txtFld_NewPass.text];
        }
    }
}

@end
