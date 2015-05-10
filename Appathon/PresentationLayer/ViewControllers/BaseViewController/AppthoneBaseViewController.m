//
//  AppthoneBaseViewController.m
//  Appathon
//
//  Created by Manoj Kumar Das on 09/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import "AppthoneBaseViewController.h"
#import "constants.h"

@interface AppthoneBaseViewController ()

@end

@implementation AppthoneBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    

    //    firstrun-background
    UIImageView *imgBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"firstrun-background.png"]];
    imgBG.backgroundColor = [UIColor clearColor];
    imgBG.userInteractionEnabled = YES;
    imgBG.frame = self.view.frame;
    [self.view addSubview:imgBG];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar@2x.png"] forBarMetrics:UIBarMetricsDefault] ;
    
    UIImageView *imgHeder=    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerLogo"]];
    imgHeder.frame = CGRectMake(0, 10, 120, 44);
    imgHeder.contentMode=UIViewContentModeScaleAspectFit;
    [self.navigationItem setTitleView:imgHeder];
    
}

-(void)addPopertiesToButton:(UIButton*)btnSender
{
    btnSender.layer.cornerRadius = 6.0;
    btnSender.clipsToBounds = YES;
}

-(void)addPaddingToTextField:(UITextField*)txtFld
{
    txtFld.borderStyle = UITextBorderStyleNone;

    txtFld.layer.borderColor = kTextFieldBorderColor;
    txtFld.layer.borderWidth = 1.0;
    txtFld.clipsToBounds = YES;
    
    UIView *paddingTxtfieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 42)];// what ever you want
    txtFld.leftView = paddingTxtfieldView;
    txtFld.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
