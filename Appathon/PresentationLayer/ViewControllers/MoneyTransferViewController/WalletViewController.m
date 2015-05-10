//
//  WalletViewController.m
//  Appathon
//
//  Created by Kuldeep Saini on 09/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import "WalletViewController.h"
#import "constants.h"
#import "UIPlaceHolderTextView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


#define tag_AddToWallet     1000
#define tag_P2PTransfer     1001
#define tag_GetWalletAmount 1003


@interface WalletViewController ()<UITextFieldDelegate,UITextViewDelegate,ABPeoplePickerNavigationControllerDelegate,BaseWebAccessLayerDelegate>
{
    UILabel *lblWalletBalance;
    UISegmentedControl *segmentPayment;
    
    UIView *vwAddMoney;
    UIView *vwSendMoney;
    
    UITextField *txtFldAddMoney;
    
    UITextField *txtFldContact;
    UITextField *txtFldAmount;
    
    UILabel *lblSelectedUSer;
    UIPlaceHolderTextView *txtVwComments;
    
    WebAccessLayer *webLayer;

}

@property (nonatomic, assign) ABAddressBookRef addressBook;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Wallet";
    
    [self designInterface];
    [self getWalletValue];
    
}

-(void)designInterface
{
    // Design Header View To Show Wallet Amount
    
    CGFloat xPos = 0;
    CGFloat yPos = 64;
    CGFloat width = CGRectGetWidth(self.view.frame);
    
    UIImageView *imgBanner = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, yPos, width, 100)];
    imgBanner.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:imgBanner];
    
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 60)];
    lblHeader.text = @"Your Wallet Balance";
    lblHeader.textAlignment = NSTextAlignmentCenter;
    lblHeader.font = [UIFont systemFontOfSize:18.0];
    lblHeader.textColor = [UIColor darkGrayColor];
    [imgBanner addSubview:lblHeader];

    
    lblWalletBalance = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, width, 40)];
    lblWalletBalance.text = @"0";
    lblWalletBalance.textAlignment = NSTextAlignmentCenter;
    lblWalletBalance.font = [UIFont boldSystemFontOfSize:20.0];
    lblWalletBalance.textColor = kNewThemeColor;
    [imgBanner addSubview:lblWalletBalance];
    
    yPos+=120;
    
    xPos = 20;
    
    segmentPayment = [[UISegmentedControl alloc] initWithItems:@[@"Add Money",@"Send Money"]];

    segmentPayment.frame = CGRectMake(xPos, yPos, width-(2*xPos), 40);
    [segmentPayment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentPayment];
    segmentPayment.selectedSegmentIndex = 0;
    segmentPayment.tintColor=kNewThemeColor;
    [self segmentChanged:segmentPayment];
    
}


-(void)segmentChanged:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex) {

        case 0:
            [self addMoneyToWallet];
            break;
            
        case 1:
            [self sendMoneyToContacts];
            break;

            
        default:
            break;
    }
}


-(void)removeExistingViewFirst
{
    if(vwSendMoney){
        [vwSendMoney removeFromSuperview];
        vwSendMoney = nil;
    }

    if(vwAddMoney){
        [vwAddMoney removeFromSuperview];
        vwAddMoney = nil;
    }
}

-(void)addMoneyToWallet
{
    [self removeExistingViewFirst];
    
    NSInteger yCord = segmentPayment.frame.origin.y+segmentPayment.frame.size.height+10;
    CGFloat width = CGRectGetWidth(self.view.frame);

    vwAddMoney = [[UIView alloc] initWithFrame:CGRectMake(0, yCord, width, CGRectGetHeight(self.view.frame)-yCord)];
    vwAddMoney.backgroundColor = [UIColor clearColor];
    [self.view addSubview:vwAddMoney];
    
    yCord = 20;
    
    txtFldAddMoney = [[UITextField alloc] initWithFrame:CGRectMake(0, yCord, CGRectGetWidth(vwAddMoney.frame), 40)];
    txtFldAddMoney.delegate = self;
    txtFldAddMoney.keyboardType = UIKeyboardTypeNumberPad;
    txtFldAddMoney.borderStyle = UITextBorderStyleRoundedRect;
    txtFldAddMoney.font = [UIFont systemFontOfSize:14.0];
    [self addPaddingToTextField:txtFldAddMoney];
    txtFldAddMoney.placeholder = @"Enter Amount";
    [vwAddMoney addSubview:txtFldAddMoney];
    
    yCord += 60;
    
    UIButton *btnAddMoney = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddMoney setTitle:@"Add to Wallet" forState:UIControlStateNormal];
    [btnAddMoney setBackgroundColor:kThemeColor];
    [btnAddMoney addTarget:self action:@selector(btnAddMoneyClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnAddMoney.frame = CGRectMake(20, yCord, CGRectGetWidth(vwAddMoney.frame)-40, 40);
    [self addPopertiesToButton:btnAddMoney];
    [vwAddMoney addSubview:btnAddMoney];
    
}



-(void)btnSendMoneyClicked:(UIButton*)btnSender
{
    
    
    
    //    [self checkAddressBookAccess];
    if(txtFldAmount.text.length == 0 || txtFldContact.text.length == 0 || txtVwComments.text.length == 0)
    {
        [self showAlertWithMessage:@"Please enter all the fields."];
        return;
    }
    


    if([lblWalletBalance.text intValue] < [[txtFldAmount text] intValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!!" message:@"You have insufficient amount in your wallet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert = nil;

        return;
    }
    
    BOOL isMobileNumber = NO;
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([txtFldAmount.text rangeOfCharacterFromSet:notDigits].location != NSNotFound)
    {
        // newString consists only of the digits 0 through 9
        [self showAlertWithMessage:@"Please enter valid amount."];
        return;
    }
    
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSString *trimmedReplacement = [[txtFldContact.text componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
    if(trimmedReplacement.length == 0)
    {
        [self showAlertWithMessage:@"Please enter valid amount."];
        return;
        
    }
    
    // Contact number
    
    
    
    notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([trimmedReplacement rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        // newString consists only of the digits 0 through 9
        isMobileNumber = YES;
    }
    
    if(![self NSStringIsValidEmail:txtFldContact.text] && !isMobileNumber)
    {
        [self showAlertWithMessage:@"Please enter valid email address."];
        return;
    }
    
    
    NSString *body = [NSString stringWithFormat:@"{ \"fromUserId\":\"%@\", \"comment\":\"%@\", \"amount\":%i, \"toMobileNo\":\"%@\", \"toEmailId\":\"%@\" }", [[UserBO sharedObject] userId],txtVwComments.text,[txtFldAmount.text intValue],isMobileNumber?trimmedReplacement:@"",isMobileNumber?txtFldContact.text:@""];
    
    
    [APP_DELEGATE showLaoder];
    
    
    if([APP_DELEGATE isServerReachable])
    {
        if(webLayer)
        {
            webLayer.callBack = nil;
            webLayer = nil;
        }
        webLayer = [WebAccessLayer new];
        webLayer.callBack = self;
        [webLayer getDataFromWeService:YES withURL:HOME_URL(@"sendMoneyToWallet") withBody:body withTag:tag_P2PTransfer];
    }
    else
    {
        [APP_DELEGATE showNoInternetAlert];
    }
    
    

}

-(void)getWalletValue
{
    [APP_DELEGATE showLaoder];
    NSString *body = [NSString stringWithFormat:@"{ \"userId\":\"%@\"}", [[UserBO sharedObject] userId]];
    
    
    
    if([APP_DELEGATE isServerReachable])
    {
        if(webLayer)
        {
            webLayer.callBack = nil;
            webLayer = nil;
        }
        webLayer = [WebAccessLayer new];
        webLayer.callBack = self;
        [webLayer getDataFromWeService:YES withURL:HOME_URL(@"getAmtFromWallet") withBody:body withTag:tag_GetWalletAmount];
    }
    else
    {
        [APP_DELEGATE showNoInternetAlert];
    }
    
    
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)btnAddMoneyClicked:(UIButton*)btnSender
{
    if(txtFldAddMoney.text.length == 0)
    {
        [self showAlertWithMessage:@"Please enter amount to add money to wallet."];
        return;
    }
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([txtFldAddMoney.text rangeOfCharacterFromSet:notDigits].location != NSNotFound)
    {
        // newString consists only of the digits 0 through 9
        [self showAlertWithMessage:@"Please enter valid amount."];
        return;
    }
    
    [APP_DELEGATE showLaoder];
    
    NSString *body = [NSString stringWithFormat:@"{\"amount\":%li,\"userId\":\"%@\" }", (long)[txtFldAddMoney.text integerValue],[[UserBO sharedObject] userId]];
    
    if([APP_DELEGATE isServerReachable])
    {
        if(webLayer)
        {
            webLayer.callBack = nil;
            webLayer = nil;
        }
        webLayer = [WebAccessLayer new];
        webLayer.callBack = self;
        [webLayer getDataFromWeService:YES withURL:HOME_URL(@"addAmtToWallet") withBody:body withTag:tag_AddToWallet];
    }
    else
    {
        [APP_DELEGATE showNoInternetAlert];
    }
    
}
#pragma WebAccessLayer Delegate Methods

- (void)operationCompletedSuccessfully:(id)result andOperationTag:(NSInteger)tag
{
    
    [APP_DELEGATE performSelectorOnMainThread:@selector(hideLoader) withObject:nil waitUntilDone:YES];
    NSLog(@"%@", (NSDictionary *)result);
    
    if(tag == tag_AddToWallet)
    {
        
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
                NSRange range = [[ditcData objectForKey:@"Message"] rangeOfString:@"success"];
                if(range.length)
                {
                    [self performSelectorOnMainThread:@selector(addToWalletDone:) withObject:[ditcData objectForKey:@"Message"] waitUntilDone:YES ];
                }
                else
                    [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:@"Error occurred while adding your wallet amount." waitUntilDone:YES ];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:@"Error occurred while adding your wallet amount." waitUntilDone:YES ];
                
            }
            
        }
        
        else
        {
            [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:@"Error occurred while adding your wallet amount." waitUntilDone:YES ];
        }
    }
    else if(tag == tag_P2PTransfer)
    {
        
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
                NSRange range = [[ditcData objectForKey:@"Message"] rangeOfString:@"success"];
                if(range.length)
                {
                [self performSelectorOnMainThread:@selector(P2PTransferDone:) withObject:[ditcData objectForKey:@"Message"] waitUntilDone:YES ];
                }
                else
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
    else
    {
        if([result isKindOfClass:[NSDictionary class]])
        {
            /*
             "_id" = 554e41a2569f923100bc22bd;
             amount = 600;
             userId = hzgh5196;
             */
            NSDictionary *ditcData = (NSDictionary *)result;
            NSString *strVal = @"";
            if([[ditcData objectForKey:@"amount"] isKindOfClass:[NSNumber class]])
            {
                strVal = [NSString stringWithFormat:@"%.20i",[[ditcData objectForKey:@"amount"] integerValue]];
            }
            else if([[ditcData objectForKey:@"amount"] isKindOfClass:[NSString class]])
            {
                strVal = [NSString stringWithFormat:@"%@",[ditcData objectForKey:@"amount"]];
            }
            else
            {
                strVal = [NSString stringWithFormat:@"%@",@"0"];
            }
            
            [self performSelectorOnMainThread:@selector(updateLabelValue:) withObject:strVal waitUntilDone:YES ];
            
        }
        else if([result isKindOfClass:[NSArray class]])
        {
            /*
             "_id" = 554e41a2569f923100bc22bd;
             amount = 600;
             userId = hzgh5196;
             */
            NSArray *arrResponse = (NSArray *)result;
            NSDictionary *ditcData = [arrResponse firstObject];
            
            NSString *strVal = @"";
            if([[ditcData objectForKey:@"amount"] isKindOfClass:[NSNumber class]])
            {
                strVal = [NSString stringWithFormat:@"%i",[[ditcData objectForKey:@"amount"] integerValue]];
            }
            else if([[ditcData objectForKey:@"amount"] isKindOfClass:[NSString class]])
            {
                strVal = [NSString stringWithFormat:@"%@",[ditcData objectForKey:@"amount"]];
            }
            else
            {
                strVal = [NSString stringWithFormat:@"%@",@"0"];
            }
            
            
            [self performSelectorOnMainThread:@selector(updateLabelValue:) withObject:strVal waitUntilDone:YES ];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(updateLabelValue:) withObject:[NSString stringWithFormat:@"%@",@"0"] waitUntilDone:YES ];
            
            
        }
    }
    
    //    lblWalletBalance.text = @"";
    
}

-(void)navigateToHomeView
{
    
}

-(void)updateLabelValue:(NSString *)strval
{
    lblWalletBalance.text = strval;
    [[UserBO sharedObject] setMyWallet:strval];
}

-(void)paymentDone
{
    txtFldAddMoney.text = @"";
}
- (void)errorOccuredWhilePerformingOperation:(NSError *)error andTag:(NSInteger)tag
{
    [APP_DELEGATE performSelectorOnMainThread:@selector(hideLoader) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:error.localizedDescription waitUntilDone:YES ];
}

-(void)addToWalletDone:(NSString *)strMsg
{
    int total = [lblWalletBalance.text intValue]+[[txtFldAddMoney text] intValue];
    txtFldAddMoney.text = @"";
    lblWalletBalance.text = [NSString stringWithFormat:@"%i",total];
    txtFldAddMoney.text = @"";

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats!!" message:strMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    alert = nil;
    
    
}
-(void)showAlertWithMessage:(NSString *)strMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!!" message:strMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    alert = nil;
    
}

-(void)P2PTransferDone:(NSString *)strMsg
{
    txtFldAmount.text = @"";
    txtFldContact.text = @"";
    txtVwComments.text = @"";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!!" message:strMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    alert = nil;
    
    [self subtractToWalletDone:@""];
    
}

-(void)subtractToWalletDone:(NSString *)strMsg
{
    int total = [lblWalletBalance.text intValue]-[[txtFldAmount text] intValue];
    txtFldAddMoney.text = @"";
    lblWalletBalance.text = [NSString stringWithFormat:@"%i",total];
}


-(void)sendMoneyToContacts
{
    
    [self removeExistingViewFirst];

    NSInteger yCord = segmentPayment.frame.origin.y+segmentPayment.frame.size.height+10;
    CGFloat width = CGRectGetWidth(self.view.frame);
    
    vwSendMoney = [[UIView alloc] initWithFrame:CGRectMake(0, yCord, width, CGRectGetHeight(self.view.frame)-yCord)];
    vwSendMoney.backgroundColor = [UIColor clearColor];

    [self.view addSubview:vwSendMoney];

    yCord = 0;
    
    lblSelectedUSer = [[UILabel alloc] initWithFrame:CGRectMake(10, yCord, CGRectGetWidth(vwSendMoney.frame), 30)];
    lblSelectedUSer.text = @"";
    lblSelectedUSer.font = [UIFont systemFontOfSize:13.0];
    lblSelectedUSer.textColor = kNewThemeColor;
    [vwSendMoney addSubview:lblSelectedUSer];

    yCord = 25;

    NSArray *arrPlaceHolders = [[NSArray alloc] initWithObjects:@"Mobile Number / Email",@"Amount", nil];
    
    for (int i =0; i<arrPlaceHolders.count; i++) {

       UITextField *txtFldData = [[UITextField alloc] initWithFrame:CGRectMake(0, yCord, CGRectGetWidth(vwSendMoney.frame), 40)];
        txtFldData.delegate = self;
        txtFldData.borderStyle = UITextBorderStyleRoundedRect;
        txtFldData.font = [UIFont systemFontOfSize:14.0];

        txtFldData.borderStyle = UITextBorderStyleNone;

        txtFldData.placeholder = arrPlaceHolders[i];
        [vwSendMoney addSubview:txtFldData];
        if (i==0) {
            txtFldContact = txtFldData;
        }
        else{
            txtFldAmount = txtFldData;
            txtFldAmount.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        [self addPaddingToTextField:txtFldData];

        yCord+=39;
    }
    
    UIButton *btnContact = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnContact setBackgroundColor:kThemeColor];
    [btnContact setImage:[UIImage imageNamed:@"addressBookIcon"] forState:UIControlStateNormal];
    [btnContact addTarget:self action:@selector(btnContactClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnContact.frame = CGRectMake(txtFldContact.frame.size.width-40, 10, 20,20);
    [txtFldContact addSubview:btnContact];

    
    
    txtVwComments = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, yCord, CGRectGetWidth(vwSendMoney.frame), 100)];
    txtVwComments.delegate = self;
    txtVwComments.placeholder = @"Add a comment";
    txtVwComments.layer.cornerRadius = 3.0;
    txtVwComments.backgroundColor = [UIColor clearColor];
    txtVwComments.font = [UIFont systemFontOfSize:14.0];
    txtVwComments.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtVwComments.layer.borderWidth = 1.0;
    [vwSendMoney addSubview:txtVwComments];
    
    
    yCord += 120;
    
    UIButton *btnSendMoney = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSendMoney setTitle:@"Send Money" forState:UIControlStateNormal];
    [btnSendMoney setBackgroundColor:kThemeColor];
    [btnSendMoney addTarget:self action:@selector(btnSendMoneyClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnSendMoney.frame = CGRectMake(20, yCord, CGRectGetWidth(vwSendMoney.frame)-40, 40);
    [self addPopertiesToButton:btnSendMoney];
    [vwSendMoney addSubview:btnSendMoney];
    

}

-(void)btnContactClicked:(UIButton*)sender
{
    [self checkAddressBookAccess];

}
-(void)showPeoplePickerController
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    // Display only a person's phone, email, and birthdate
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
    
    
    picker.displayedProperties = displayedItems;
    // Show the picker
    [self presentViewController:picker animated:YES completion:nil];
}
// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0);
{
    NSString* name = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString* lastname = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);

    ABMultiValueRef emailMultiValue = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSArray *emailAddresses = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emailMultiValue) ;
    
    
    ABMultiValueRef phoneNumber = (ABMultiValueRef)ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSArray * phoneNumbers =(__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumber) ;

    
    lblSelectedUSer.text = [NSString stringWithFormat:@"%@",name];
    
    if(emailAddresses.count){
         txtFldContact.text = [emailAddresses objectAtIndex:0];
    }
    else if (phoneNumbers.count){
        txtFldContact.text = [phoneNumbers objectAtIndex:0];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return NO;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

#pragma mark -
#pragma mark Address Book Access
// Check the authorization status of our application for Address Book
-(void)checkAddressBookAccess
{
    switch (ABAddressBookGetAuthorizationStatus())
    {
            // Update our UI if the user has granted access to their Contacts
        case  kABAuthorizationStatusAuthorized:
            [self accessGrantedForAddressBook];
            break;
            // Prompt the user for access to Contacts if there is no definitive answer
        case  kABAuthorizationStatusNotDetermined :
            [self requestAddressBookAccess];
            break;
            // Display a message if the user has denied or restricted access to Contacts
        case  kABAuthorizationStatusDenied:
        case  kABAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Contacts."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

// Prompt the user for access to their Address Book data
-(void)requestAddressBookAccess
{
    WalletViewController * __weak weakSelf = self;
    
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error)
                                             {
                                                 if (granted)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [weakSelf accessGrantedForAddressBook];
                                                         
                                                     });
                                                 }
                                             });
}

// This method is called when the user has granted access to their address book data.
-(void)accessGrantedForAddressBook
{
    // Load data from the plist file
    [self showPeoplePickerController];
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
