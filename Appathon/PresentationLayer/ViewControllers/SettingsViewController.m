//
//  SettingsViewController.m
//  SampleDashboard
//
//  Created by Manoj Kumar Das on 09/05/15.
//  Copyright (c) 2015 MySelf. All rights reserved.
//

#import "SettingsViewController.h"
#import "ChangePasswordView.h"
#import "ChangePasswordViewController.h"
#import "ViewController.h"
#import "constants.h"

#define tagAlertSignOut 12345
@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate,ChangePasswordView_Delegate>
{
    UITableView *tblSettings;
    NSString *strName;
    NSString *strEmail;
    NSString *strMobile;
    NSString *strWallet;
    NSString *strChangePassword;
    NSString *strSignOut;
    
    ChangePasswordView *vwPasswordView;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setValuesToLocalInstance];
    [self designInterface];
}

-(void)setValuesToLocalInstance
{
    strName  = [[UserBO sharedObject] firstName];
    strEmail  = [[UserBO sharedObject] email];
    strMobile  = [[UserBO sharedObject] mobileNumber];
    strWallet  = [[UserBO sharedObject] myWallet];
    strChangePassword  = @"Change Password";
    strSignOut  = @"Sign Out";
}
-(void)designInterface
{
    tblSettings = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64) style:UITableViewStyleGrouped];
    tblSettings.delegate = self;
    tblSettings.dataSource = self;
    tblSettings.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tblSettings];
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




#pragma mark - UITableView Delegate and Datasource
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;// Name Email Contact
            break;
        case 1:
            return 1;// Wallet
            break;
        case 2:
            return 2;// Change Password, Sign Out
            break;
            
        default:
            break;
    }
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Profile";// Name Email Contact
            break;
        case 1:
            return @"Wallet";// Wallet
            break;
        case 2:
            return @"Other Activity";// Change Password, Sign Out
            break;
            
        default:
            break;
    }
    return @"";

}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strReuseIdentifier = @"cell_reuseIdentifier";
    UITableViewCell *cell =  (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:strReuseIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:strReuseIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor blackColor];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0)
            {
                cell.textLabel.text = @"Name";

                cell.detailTextLabel.text = strName;
            }
            else if(indexPath.row == 1)
            {
                cell.textLabel.text = @"Email ID";

                cell.detailTextLabel.text = strEmail;
            }
            else
            {
                cell.textLabel.text = @"Mobile";

                cell.detailTextLabel.text = strMobile;
            }
        }
            break;
        case 1:
            cell.textLabel.text = @"Amount";
            cell.detailTextLabel.text = strWallet;
            break;
        case 2:
        {
            cell.detailTextLabel.text = @"";

            if(indexPath.row == 0)
            {
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.textLabel.text = strChangePassword;
            }
            else
            {
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.textLabel.text = strSignOut;
                cell.textLabel.textColor = [UIColor redColor];
            }
        }
            break;
            
        default:
            break;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 2:
        {
            if(indexPath.row == 0)
            {
                [self showChangePasswordView];
            }
            else
            {
                UIAlertView *alertSignOut = [[UIAlertView alloc] initWithTitle:@"Warning!!" message:@"Are you sure, you want sign out?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                alertSignOut.tag = tagAlertSignOut;
                [alertSignOut show];
            }
        }
            break;
            
        default:
            break;
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if(alertView.tag == tagAlertSignOut)
  {
      if(alertView.cancelButtonIndex != buttonIndex)
      {
          [self signOutCurrentUser];
      }
  }
}


-(void)signOutCurrentUser
{
//    [self.navigationController popViewControllerAnimated:YES];
    
    for (UIViewController *vwC in self.navigationController.viewControllers)
    {
        if([vwC isKindOfClass:[ViewController class]])
        {
            [self.navigationController popToViewController:vwC animated:YES];
        }

    }
    
}

-(void)showChangePasswordView
{
    
    ChangePasswordViewController *vwCont = [[ChangePasswordViewController alloc] init];
    [self.navigationController pushViewController:vwCont animated:YES];
    
//    vwPasswordView = [ChangePasswordView sharedDashboard];
//    vwPasswordView.delegate = self;
//    [vwPasswordView showChangePasswordView:self.view];
}

/**
 * Delegate method to be called back from Change password view.
 * Before this all the validations are already made. Just hit the server and update user's password.
 */
-(void)updatePassword:(NSString*)strOldPass withNewPassword:(NSString *)strNewPass
{
    [vwPasswordView hideChangePasswordView];
}
@end
