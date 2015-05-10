//
//  TransactionsBO.h
//  Appathon
//
//  Created by Shreyansh Bhardwaj on 10/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionsBO : NSObject

@property (nonatomic, strong) NSString *strAmount;
@property (nonatomic, strong) NSString *strDate;
@property (nonatomic, strong) NSString *strFromUserId;
@property (nonatomic, strong) NSString *strLoginUserName;
@property (nonatomic, strong) NSString *strToUserId;
@property (nonatomic, strong) NSString *strToUserName;
@property (nonatomic, strong) NSString *strToUserEmail;
@property (nonatomic, strong) NSString *strToUserMob;
@property (nonatomic, assign) NSInteger paymentType;

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

@end
