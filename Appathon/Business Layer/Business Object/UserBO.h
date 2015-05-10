//
//  UserBO.h
//  Appathon
//
//  Created by Manoj Kumar Das on 10/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBO : NSObject
/*
 "_id" = 554e3147d7c5e9310056b0b9;
 emailId = "bansal.defi@gmail.com";
 firstName = Defi;
 lastName = Bansal;
 mobileNo = 9599765900;
 password = 123456;
 userId = hzgh5196
 */
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *mobileNumber;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *myWallet;

+ (UserBO *)sharedObject;

@end
