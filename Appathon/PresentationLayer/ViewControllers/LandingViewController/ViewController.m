//
//  ViewController.m
//  Appathon
//
//  Created by Shreyansh Bhardwaj on 09/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import "ViewController.h"
#import "WalletViewController.h"
#import "constants.h"
#import "WalletStatementsViewController.h"
#import "LoginViewController.h"
#import "DashboardView.h"
#import "SKSplashIcon.h"
#import "SKSplashView.h"

#import "SignupViewController.h"

#define tag_BtnDashboard 8989

@interface ViewController ()<SKSplashDelegate>
{
    UIView *vwDashboard;
    UIView *vwBottomBucket;
    UIButton *btnShowDashboard;
}
- (IBAction)showHideDashboard:(id)sender;
@property (strong, nonatomic) SKSplashView *splashView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self twitterSplash];

    // Testing push
    self.loginButton.layer.cornerRadius = 5.0;
    self.loginButton.backgroundColor = kThemeColor;
    
    self.signupButton.layer.cornerRadius = 5.0;
    self.signupButton.backgroundColor = kThemeColor;
    

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES];
}

- (void) twitterSplash
{
    //Setting the background
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"twitter background.png"];
    [self.view addSubview:imageView];
    //Twitter style splash
    SKSplashIcon *twitterSplashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"LogoSplash.png"] animationType:SKIconAnimationTypeBounce];
    UIColor *twitterColor = [UIColor colorWithRed:18.0/255.0    green:60.0/255.0 blue:131.0/255.0 alpha:1.0];
    _splashView = [[SKSplashView alloc] initWithSplashIcon:twitterSplashIcon backgroundColor:twitterColor animationType:SKSplashAnimationTypeNone];
    _splashView.delegate = self; //Optional -> if you want to receive updates on animation beginning/end
    _splashView.animationDuration = 2; //Optional -> set animation duration. Default: 1s
    [self.view addSubview:_splashView];
    [_splashView startAnimation];
}

- (void) splashViewDidEndAnimating: (SKSplashView *) splashView
{
    [self addMainInterface];
    
}

-(void)addMainInterface
{
    
    //    firstrun-background
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 50, CGRectGetWidth(self.view.frame)-80, 150)];
    imageView.image = [UIImage imageNamed:@"Logo.png"];
    [self.view addSubview:imageView];

    
    
    UIImageView *imageViewForAnimation = [[UIImageView alloc] initWithImage:nil];
    imageViewForAnimation.backgroundColor = [UIColor clearColor];
    imageViewForAnimation.userInteractionEnabled = YES;
    [imageViewForAnimation setImage:[UIImage imageNamed:@"OPenBox@2x"]];
    imageViewForAnimation.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2 - 50, CGRectGetHeight(self.view.frame)-130, 100, 100);
    imageViewForAnimation.alpha = 1.0f;
    CGRect imageFrame = imageViewForAnimation.frame;
    //Your image frame.origin from where the animation need to get start
    CGPoint viewOrigin = imageViewForAnimation.frame.origin;
    viewOrigin.y = viewOrigin.y + imageFrame.size.height / 2.0f;
    viewOrigin.x = viewOrigin.x + imageFrame.size.width / 2.0f;
    
    imageViewForAnimation.frame = imageFrame;
    imageViewForAnimation.layer.position = viewOrigin;
    [self.view addSubview:imageViewForAnimation];
    
    
    
//    UIButton *btnDashboard = [self getButtonWithTargetFrame:imageViewForAnimation.bounds withImage:[UIImage imageNamed:@"OPenBox@2x"] withTag:tag_BtnDashboard];
//    btnDashboard.backgroundColor = [UIColor clearColor];
//    [imageViewForAnimation addSubview:btnDashboard];
    
    
    
    viewOrigin = CGPointMake(25, 25);
    
    CGPoint endPoint = CGPointMake(175, 25);
    
    float totalWidth = CGRectGetWidth(self.view.frame);
    float btnWidth = 80;
    float btnHeight = 80;
    float gapInBetween = (totalWidth - (btnWidth*2))/3;
    float gapInBetweenY = gapInBetween;
    
    float xInitialPos = gapInBetween;
    float xPos = gapInBetween;
    float yPos = 220;
    
    UIButton *btn1 = [self getButtonWithTargetFrame:CGRectMake(xPos, yPos, btnWidth, btnHeight) withImage:[UIImage imageNamed:@"Login.png"] withTag:0];
    [self.view addSubview:btn1];
    [self.view insertSubview:btn1 belowSubview:imageViewForAnimation];
    
    viewOrigin = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)-130);
    endPoint = CGPointMake(CGRectGetMidX(btn1.frame), CGRectGetMidY(btn1.frame));
    [self animateMovingObject:btn1 fromPosition:viewOrigin toPosition:endPoint duration:1.0];
    
    xPos += (btnWidth+gapInBetween);
    UIButton *btn2 = [self getButtonWithTargetFrame:CGRectMake(xPos, yPos, btnWidth, btnHeight) withImage:[UIImage imageNamed:@"SignUp@2x"] withTag:1];
    [self.view addSubview:btn2];
    [self.view insertSubview:btn2 belowSubview:imageViewForAnimation];
    btn2.hidden = YES;
    [self performSelector:@selector(addSecondButton:) withObject:btn2 afterDelay:0.5];
    
    
    //    xPos = xInitialPos;
    //    yPos += (btnHeight+gapInBetweenY);
    //    UIButton *btn3 = [self getButtonWithTargetFrame:CGRectMake(xPos, yPos, btnWidth, btnHeight) withImage:[UIImage imageNamed:@"SavedCards@2x"] withTag:1];
    //    [self.view addSubview:btn3];
    //    [self.view insertSubview:btn3 belowSubview:imageViewForAnimation];
    //    btn3.hidden = YES;
    //    [self performSelector:@selector(addSecondButton:) withObject:btn3 afterDelay:1.0];
    //
    //    xPos += (btnWidth+gapInBetween);
    //    UIButton *btn4 = [self getButtonWithTargetFrame:CGRectMake(xPos, yPos, btnWidth, btnHeight) withImage:[UIImage imageNamed:@"Setting@2x"] withTag:1];
    //    [self.view addSubview:btn4];
    //    [self.view insertSubview:btn4 belowSubview:imageViewForAnimation];
    //    btn4.hidden = YES;
    //    [self performSelector:@selector(addSecondButton:) withObject:btn4 afterDelay:1.5];
    
    
}

-(void)addSecondButton:(UIButton *)btn2
{
    btn2.hidden = NO;
    CGPoint viewOrigin = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)-130);
    
    CGPoint endPoint = CGPointMake(CGRectGetMidX(btn2.frame), CGRectGetMidY(btn2.frame));
    [self animateMovingObject:btn2 fromPosition:viewOrigin toPosition:endPoint duration:1.0];
    
}

-(UIButton *)getButtonWithTargetFrame:(CGRect)targetRect withImage:(UIImage *)img withTag:(NSInteger)tagGen
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = targetRect;
    btn.backgroundColor  =[UIColor clearColor];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTag:tagGen+1000];
    [btn addTarget:self action:@selector(btnDashboardClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 10.0;
    btn.clipsToBounds = YES;
    return btn;
}

-(void)designDashBoardView
{
    vwDashboard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 500)];
    vwDashboard.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:vwDashboard];
}
-(void)designBottomButcketView
{
    vwBottomBucket = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 500)];
    vwBottomBucket.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:vwBottomBucket];
}


-(void)addAnimationToView:(UIView *)view sourcePosition:(CGPoint)viewOrigin targetPosition:(CGPoint)targetPosition
{
    
    viewOrigin = CGPointMake(25, 25);
    targetPosition = CGPointMake(175, 25);
    CGRect imageFrame = view.frame;
    
    // Set up fade out effect
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.3]];
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.removedOnCompletion = NO;
    
    // Set up scaling
    CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    [resizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(40.0f, imageFrame.size.height * (40.0f / imageFrame.size.width))]];
    resizeAnimation.fillMode = kCAFillModeForwards;
    resizeAnimation.removedOnCompletion = NO;
    
    // Set up path movement
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, viewOrigin.x, viewOrigin.y);
    CGPathAddCurveToPoint(curvedPath, NULL, targetPosition.x, viewOrigin.y, targetPosition.x, viewOrigin.y, targetPosition.x, targetPosition.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    
    // Set up path movement
    CGPoint targetPosition2 = CGPointMake(targetPosition.x, targetPosition.y+100);
    CAKeyframeAnimation *pathAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation2.calculationMode = kCAAnimationPaced;
    pathAnimation2.fillMode = kCAFillModeForwards;
    pathAnimation2.removedOnCompletion = NO;
    CGMutablePathRef curvedPath2 = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath2, NULL, targetPosition.x, targetPosition.y);
    CGPathAddCurveToPoint(curvedPath2, NULL, targetPosition2.x, targetPosition.y, targetPosition2.x, targetPosition.y, targetPosition2.x, targetPosition2.y);
    pathAnimation2.path = curvedPath2;
    CGPathRelease(curvedPath2);
    
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    //    [group setAnimations:[NSArray arrayWithObjects:fadeOutAnimation, pathAnimation, resizeAnimation, nil]];
    [group setAnimations:[NSArray arrayWithObjects:pathAnimation,pathAnimation2, nil]];
    
    group.duration = 0.7f;
    group.delegate = self;
    [group setValue:view forKey:@"imageViewBeingAnimated"];
    
    [view.layer addAnimation:group forKey:@"savingAnimation"];
    
    
}



- (void)animateMovingObject:(UIView*)obj
               fromPosition:(CGPoint)startPosition
                 toPosition:(CGPoint)endPosition
                   duration:(NSTimeInterval)duration {
    
    
    CGPoint midPoint = CGPointMake(startPosition.x, endPosition.y);
    
    NSArray * pathArray = @[
                            [NSValue valueWithCGPoint:startPosition],
                            [NSValue valueWithCGPoint:midPoint],
                            [NSValue valueWithCGPoint:endPosition]
                            ];
    
    // Create animation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    pathAnimation.values = pathArray;
    
    // Add relative timing for each position
    pathAnimation.keyTimes = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.0], nil];
    
    // Define animation type for each frame
    pathAnimation.timingFunctions = [NSArray arrayWithObjects:
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn], // from keyframe 1 to keyframe 2
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], // from keyframe 2 to keyframe 3
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn], nil]; // from keyframe 3 to keyframe 4
    
    // Set duration for whole animation
    pathAnimation.duration = duration;
    
    // Perform repeat
    pathAnimation.repeatCount = 1;
    
    // Add animation
    CALayer *layer = obj.layer;
    [layer addAnimation:pathAnimation forKey:@"position"];
    
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showHideDashboard:(id)sender {
}



-(void)btnDashboardClicked:(UIButton *)btnClicked
{
    if(btnClicked.tag - 1000 == 0)
    {
        [self showLoginViewController];
    }
    else{
        [self showSignupViewController];
    }
}


-(void)showDashboardView
{
    [[DashboardView sharedDashboard] showDashboard:self.view];
    
    //    if(vwDashboard)
    //    {
    //        [vwDashboard.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //        [vwDashboard removeFromSuperview];
    //    }
    //    vwDashboard = [[UIView alloc] initWithFrame:self.view.bounds];
    //    vwDashboard.backgroundColor = [UIColor clearColor];
    //    [self.view addSubview:vwDashboard];
    //
    //
    //
    //    UIImageView *imgTransparent = [[UIImageView alloc] initWithFrame:vwDashboard.bounds];
    //    imgTransparent.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.8];
    
    
}

- (IBAction)btnLoginClicked:(id)sender {
    WalletViewController *vwCont = [[WalletViewController alloc] init];
    [self.navigationController pushViewController:vwCont animated:YES];
}




- (void)checkPasscode{
    [[LTHPasscodeViewController sharedUser] setIsSimple:NO inViewController:self asModal:YES];
    [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self asModal:YES];
    [LTHPasscodeViewController sharedUser].delegate = self;
    [LTHPasscodeViewController sharedUser].maxNumberOfAllowedFailedAttempts = 5;
}

-(void) showWalletStatmentsViewController {
    WalletStatementsViewController *walletStatementsViewController = (WalletStatementsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"WalletStatementsViewController"];
    [self.navigationController pushViewController:walletStatementsViewController animated:YES];
}


-(void)showSignupViewController
{
    SignupViewController *loginViewController = (SignupViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self.navigationController pushViewController:loginViewController animated:YES];

}


-(void) showLoginViewController {
    LoginViewController *loginViewController = (LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginViewController animated:YES];

}

- (IBAction)loginButtonTapped:(id)sender {
    [self showLoginViewController];
//    [self showWalletStatmentsViewController];
/*    LAContext *localAuthenticationContext = [[LAContext alloc] init];
    __autoreleasing NSError *authenticatingError;
    NSString *localizedReasonString = NSLocalizedString(@"Goto Dashboard", @"Touch ID for "Appathon"");
    localAuthenticationContext.localizedFallbackTitle = @"Enter Passcode";
    if ([localAuthenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authenticatingError]) {
        [localAuthenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReasonString reply:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"success");
                //Goto to dashboard
                [self showLoginViewController];
//                [self showWalletStatmentsViewController];
            } else {
                if (error.code == LAErrorUserFallback) {
                    [self checkPasscode];
                }
            }
        }];
    } else {
        [self checkPasscode];
    }
 */
}

@end
