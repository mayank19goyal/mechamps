//
//  UserBO.m
//  Appathon
//
//  Created by Manoj Kumar Das on 10/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import "UserBO.h"

@implementation UserBO


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (UserBO *)sharedObject {
    static UserBO *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}



@end
