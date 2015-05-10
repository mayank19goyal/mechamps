//
//  AppDelegate.h
//  Appathon
//
//  Created by Shreyansh Bhardwaj on 09/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

#define APP_DELEGATE  (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define HOME_URL(xx) [NSString stringWithFormat:@"http://appathonhackers.mybluemix.net/%@",xx]


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL isServerReachable;
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic)         BOOL isServerReachable;
@property (nonatomic, strong) Reachability *serverReachability;

-(void)showNoInternetAlert;

-(void)showLaoder;
-(void)hideLoader;

@end

