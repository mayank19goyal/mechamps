
//
//  WalletStatements.m
//  Appathon
//
//  Created by Shreyansh Bhardwaj on 09/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import "WalletStatementsViewController.h"
#import "constants.h"
#import "TransactionsBO.h"


#define deteFormat_TopDate  @"MMM dd"
#define deteFormat_time     @"HH mm"

@interface WalletStatementsViewController() <BaseWebAccessLayerDelegate>
{
    WebAccessLayer *webLayer;
    NSMutableArray *arrTransactions;
}
@end


@implementation WalletStatementsViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"mPay Wallet Statement";
    self.navigationController.navigationBar.titleTextAttributes= kDashboardTitleColor;

    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    arrTransactions = [NSMutableArray new];
    [self getAllTransactions];
}

-(void)getAllTransactions
{
    [APP_DELEGATE showLaoder];
    
    NSString *body = [NSString stringWithFormat:@"{\"userId\":\"%@\"}", [[UserBO sharedObject] userId]];
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
        [webLayer getDataFromWeService:YES withURL:HOME_URL(@"getTransactionList") withBody:body withTag:1];
    }
    else
    {
        [APP_DELEGATE showNoInternetAlert];
    }
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrTransactions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    TransactionsBO *obj = arrTransactions[indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    /*
     strAmount;
     strDate;
     strFromUserId;
     strLoginUserName
     strToUserId;
     strToUserName;
     paymentType;
     */
    UILabel *dateLabel = (UILabel*)[cell viewWithTag:1];
    dateLabel.layer.masksToBounds = YES;
    dateLabel.layer.cornerRadius = 5.0;
    dateLabel.layer.borderWidth = 1.0;
    dateLabel.layer.borderColor = kmPayThemeColorCGColor;
    
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [formatter dateFromString:[[obj.strDate componentsSeparatedByString:@"."] firstObject]];
    [formatter setDateFormat:deteFormat_TopDate];
    dateLabel.text = [formatter stringFromDate:date];

    
    
    UILabel *timeLabel = (UILabel*)[cell viewWithTag:2];
    [formatter setDateFormat:deteFormat_time];
    timeLabel.text = [formatter stringFromDate:date];

    
    UIImageView *image = (UIImageView*)[cell viewWithTag:8];
    image.layer.masksToBounds = YES;
    image.layer.cornerRadius = 5.0;
    image.layer.borderWidth = 1.0;
    image.layer.borderColor = kmPayThemeColorCGColor;

    
    UILabel *paidFor = (UILabel*)[cell viewWithTag:3];
    UILabel *amount = (UILabel*)[cell viewWithTag:6];
    amount.text = obj.strAmount;
    
    if(obj.paymentType == 0) // Self wallet
    {
        paidFor.text = [NSString stringWithFormat:@"Added to My Wallet"];
        [image setImage:[UIImage imageNamed:@"cashwallet"]];
    }
    else if(obj.paymentType == 1) // P2P
    {
        paidFor.text = [NSString stringWithFormat:@"Paid to %@",obj.strToUserName];
        [image setImage:[UIImage imageNamed:@"sendcash"]];
    }
    else // recieved
    {
        paidFor.text = [NSString stringWithFormat:@"Wallet Recieved"];
        [image setImage:[UIImage imageNamed:@"getcash"]];
    }
    
    
    
    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransactionsBO *obj = arrTransactions[indexPath.row];
    if(obj.paymentType == 0) // Self wallet
    {
    }
    else if(obj.paymentType == 1) // P2P
    {
    }
    else // recieved
    {
    }
    
    
    

}
#pragma WebAccessLayer Delegate Methods

- (void)operationCompletedSuccessfully:(id)result andOperationTag:(NSInteger)tag
{
    [APP_DELEGATE performSelectorOnMainThread:@selector(hideLoader) withObject:nil waitUntilDone:YES];
    
    NSLog(@"%@", (NSDictionary *)result);
    if([result isKindOfClass:[NSArray class]])
    {
        NSArray *arrResponse = (NSArray *)result;
        for (NSDictionary *dictData in arrResponse)
        {
            TransactionsBO *obj = [[TransactionsBO alloc] init];
            if([[dictData objectForKey:@"amount"] isKindOfClass:[NSNumber class]])
            {
                obj.strAmount = [NSString stringWithFormat:@"%li",[[dictData objectForKey:@"amount"] integerValue]];
            }
            else
            {
                obj.strAmount = [NSString stringWithFormat:@"%@",[dictData objectForKey:@"amount"]];
            }

            obj.strDate = [dictData objectForKey:@"date"];
            obj.strFromUserId = [dictData objectForKey:@"fromUserId"];
            obj.strLoginUserName = [dictData objectForKey:@"loginUserName"];
            obj.strToUserId = [dictData objectForKey:@"toUserId"];
            obj.strToUserName = [dictData objectForKey:@"toUserName"];
            obj.strToUserEmail = [dictData objectForKey:@"toEmailId"];
            obj.strToUserMob = [dictData objectForKey:@"toMobNo"];
            obj.paymentType = [[dictData valueForKey:@"type"] integerValue];
            [arrTransactions addObject:obj];
            
            /*
             toEmailId = "p@g.com";
             toMobNo = 123456678;

             */
        }
        

        /*
         "_id" = 554eda4c7961ac31004ede56;
         amount = 5000;
         date = "2015-05-10T04:10:52.752Z";
         fromUserId = LqQr3839;
         loginUserName = P;
         toUserId = LqQr3839;
         toUserName = P;
         type = 0;
         

         */
        
        [self performSelectorOnMainThread:@selector(parsingDataDone) withObject:nil waitUntilDone:YES ];
        
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:@"Error occurred while etching transactions list. Please try again later." waitUntilDone:YES ];
    }
}

-(void)parsingDataDone
{
    [_walletTableView reloadData];
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
