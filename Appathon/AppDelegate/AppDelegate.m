//
//  AppDelegate.m
//  Appathon
//
//  Created by Shreyansh Bhardwaj on 09/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    UIView *vwLoader;
    UIActivityIndicatorView *loader;
}
@end

@implementation AppDelegate
@synthesize isServerReachable;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self configureReachability];

    return YES;
}

#pragma mark Reachability
-(void)configureReachability
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    
    self.serverReachability = [Reachability reachabilityForInternetConnection];
    [self.serverReachability startNotifier];
    [self updateInterfaceWithReachability:self.serverReachability];
}

- (void)reachabilityChanged:(NSNotification*)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability*)curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
            self.isServerReachable = NO;
            break;
        case ReachableViaWWAN:
            self.isServerReachable = YES;
            break;
        case ReachableViaWiFi:
            self.isServerReachable = YES;
            break;
    }
}




-(void)showNoInternetAlert
{
    [self hideLoader];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles: nil];
    [alert show];
    alert = nil;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)showLaoder
{
    if(vwLoader)
    {
        [self hideLoader];
    }
    
    vwLoader = [[UIView alloc] initWithFrame:self.window.bounds];
    vwLoader.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.6];
    [self.window addSubview:vwLoader];
    
    
    
    loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loader.hidesWhenStopped = YES;
    loader.center = vwLoader.center;
    [vwLoader addSubview:loader];
    [loader startAnimating];
    
}
-(void)hideLoader
{
    [loader stopAnimating];
    loader = nil;
    [vwLoader removeFromSuperview];
    vwLoader = nil;
}
@end
