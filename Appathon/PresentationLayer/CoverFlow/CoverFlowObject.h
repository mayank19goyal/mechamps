//
//  CoverFlowObject.h
//  CoverFlow
//
//  Created by Mayank Goyal on 10/05/15.
//  Copyright (c) 2015 Mayank Goyal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoverFlowObject : NSObject

@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSString *strSubTitle;
@property (strong, nonatomic) NSString *strCardNumber;
@property (strong, nonatomic) NSString *strCVV;
@property (strong, nonatomic) NSString *strMonth;
@property (strong, nonatomic) NSString *strYear;
@property (strong, nonatomic) NSString *strCardHolderName;
@property (assign, nonatomic) NSInteger cardType;

@end
