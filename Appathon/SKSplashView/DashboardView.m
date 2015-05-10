//
//  DashboardView.m
//  SampleDashboard
//
//  Created by Manoj Kumar Das on 09/05/15.
//  Copyright (c) 2015 MySelf. All rights reserved.
//

#import "DashboardView.h"
#import <objc/runtime.h>

#define tag_Gen                 1000
#define tag_GenHideDashboard    5000
#define viewOriginx -40
#define viewOriginy 400
@interface DashboardView ()
{

}
@property (nonatomic, assign) BOOL hidingDashboard;

@end

@implementation DashboardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (DashboardView *)sharedDashboard {
    static DashboardView *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)showDashboard:(UIView *)vw
{
    self.hidingDashboard = NO;
    self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.8];
    self.frame = vw.bounds;
    CABasicAnimation *fadeInAnimation;
    fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration = 0.5;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    [fadeInAnimation setDelegate:self];
    [vw addSubview:self];
    [self.layer addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    
    
    [self performSelector:@selector(addAnimatinButtons) withObject:nil afterDelay:0.3];
}


-(void)addAnimatinButtons
{
    CGPoint viewOrigin = CGPointMake(viewOriginx, viewOriginy);
    CGPoint endPoint = CGPointMake(175, viewOriginy);
    
    float totalWidth = CGRectGetWidth(self.frame);
    float btnWidth = 80;
    float btnHeight = 80;
    float gapInBetween = (totalWidth - (btnWidth*2))/3;
    float gapInBetweenY = gapInBetween;
    float xInitialPos = gapInBetween;
    float xPos = gapInBetween;
    float yPos = 150;
    
    UIButton *btn1 = [self getButtonWithTargetFrame:CGRectMake(xPos, yPos, btnWidth, btnHeight) withImage:[UIImage imageNamed:@"Wallet@2x"] withTag:0];
    [self addSubview:btn1];
//    [self insertSubview:btn1 belowSubview:imageViewForAnimation];
    
    endPoint = CGPointMake(CGRectGetMidX(btn1.frame), CGRectGetMidY(btn1.frame));
    [self animateMovingObject:btn1 fromPosition:viewOrigin toPosition:endPoint duration:1.0 showButtons:YES];
    
    xPos += (btnWidth+gapInBetween);
    UIButton *btn2 = [self getButtonWithTargetFrame:CGRectMake(xPos, yPos, btnWidth, btnHeight) withImage:[UIImage imageNamed:@"QuickPay@2x"] withTag:1];
    [self addSubview:btn2];
//    [self insertSubview:btn2 belowSubview:imageViewForAnimation];
    btn2.hidden = YES;
    [self performSelector:@selector(addSecondButton:) withObject:btn2 afterDelay:0.5];
    
    
    xPos = xInitialPos;
    yPos += (btnHeight+gapInBetweenY);
    UIButton *btn3 = [self getButtonWithTargetFrame:CGRectMake(xPos, yPos, btnWidth, btnHeight) withImage:[UIImage imageNamed:@"SavedCards@2x"] withTag:2];
    [self addSubview:btn3];
//    [self insertSubview:btn3 belowSubview:imageViewForAnimation];
    btn3.hidden = YES;
    [self performSelector:@selector(addSecondButton:) withObject:btn3 afterDelay:1.0];
    
    xPos += (btnWidth+gapInBetween);
    UIButton *btn4 = [self getButtonWithTargetFrame:CGRectMake(xPos, yPos, btnWidth, btnHeight) withImage:[UIImage imageNamed:@"Setting@2x"] withTag:3];
    [self addSubview:btn4];
//    [self insertSubview:btn4 belowSubview:imageViewForAnimation];
    btn4.hidden = YES;
    [self performSelector:@selector(addSecondButton:) withObject:btn4 afterDelay:1.5];

}

-(void)addSecondButton:(UIButton *)btn2
{
    btn2.hidden = NO;
    CGPoint viewOrigin = CGPointMake(viewOriginx, viewOriginy);
    
    CGPoint endPoint = CGPointMake(CGRectGetMidX(btn2.frame), CGRectGetMidY(btn2.frame));
    [self animateMovingObject:btn2 fromPosition:viewOrigin toPosition:endPoint duration:1.0 showButtons:YES];
    
}

-(void)hideSecondButton:(UIButton *)btn2
{
//    btn2.hidden = NO;
    CGPoint viewOrigin = CGPointMake(CGRectGetMidX(btn2.frame), CGRectGetMidY(btn2.frame));
    
    CGPoint endPoint = CGPointMake(viewOriginx, viewOriginy);
    [self animateMovingObject:btn2 fromPosition:viewOrigin toPosition:endPoint duration:0.5 showButtons:NO];
    
}


-(UIButton *)getButtonWithTargetFrame:(CGRect)targetRect withImage:(UIImage *)img withTag:(NSInteger)tagGen
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = targetRect;
    btn.backgroundColor  =[UIColor clearColor];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTag:tagGen+tag_Gen];
    [btn addTarget:self action:@selector(btnDashboardClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)animateMovingObject:(UIButton*)obj
               fromPosition:(CGPoint)startPosition
                 toPosition:(CGPoint)endPosition
                   duration:(NSTimeInterval)duration
                showButtons:(BOOL)showButtons {
    
    
    CGPoint midPoint = showButtons ? CGPointMake(endPosition.x, startPosition.y) : CGPointMake(startPosition.x, endPosition.y);
    
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
//    layer.delegate = self;
    [layer addAnimation:pathAnimation forKey:@"position"];
    
//    NSDictionary *dictInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",endPosition.x],@"xPos",[NSString stringWithFormat:@"%f",endPosition.y],@"yPos",obj,@"button", nil];
    
    obj.center = endPosition;
    return;
//    if(!showButtons)
//    {
//        obj.center = CGPointMake(-40, 40);
//    }
//    else
//    {
//        obj.center = CGPointMake(-40, 40);
//    }
//        objc_setAssociatedObject(obj, @"xPos", [NSString stringWithFormat:@"%f",endPosition.x], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        objc_setAssociatedObject(obj, @"yPos", [NSString stringWithFormat:@"%f",endPosition.y], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        
//        [self performSelector:@selector(hideComponent:) withObject:obj afterDelay:duration];
        
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    if(self.hidingDashboard)
//    {
//        
//        UIButton *btn = (UIButton *)[anim actionForLayer:<#(CALayer *)#> forKey:<#(NSString *)#>];
//        float xPos = [objc_getAssociatedObject(btn, @"xPos") floatValue];
//        float yPos = [objc_getAssociatedObject(btn, @"yPos") floatValue];
//        btn.center = CGPointMake(xPos, yPos);
//    }
}
-(void)hideComponent:(UIButton *)btn
{
    if(self.hidingDashboard)
    {
        btn.center = CGPointMake(viewOriginx, viewOriginy);;
    }

}

-(void)hideDashboard
{
    CABasicAnimation *fadeInAnimation;
    fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration = 1.5;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    [fadeInAnimation setDelegate:self];
    [self removeFromSuperview];
    [self.layer addAnimation:fadeInAnimation forKey:@"animateOpacity"];

//    if(self.delegate && [self.delegate respondsToSelector:@selector(hideDashboard)])
//    {
//        [self.delegate performSelector:@selector(hideDashboard) withObject:nil];
//        [self removeFromSuperview];
//    }
}

-(void)btnDashboardClicked:(UIButton *)btnClicked
{
    [self hideDashboardWithAnimation];
//    if(self.delegate && [self.delegate respondsToSelector:@selector(dashboardOptionSelected:)])
//    {
//        [self.delegate performSelector:@selector(dashboardOptionSelected:) withObject:btnClicked];
//    }
}

-(void)hideDashboardWithAnimation
{
    self.hidingDashboard = YES;
    UIButton *btn1= (UIButton *)[self viewWithTag:tag_Gen+0];
    UIButton *btn2 = (UIButton *)[self viewWithTag:tag_Gen+1];
    UIButton *btn3 = (UIButton *)[self viewWithTag:tag_Gen+2];
    UIButton *btn4 = (UIButton *)[self viewWithTag:tag_Gen+3];
    
    
    
    
    CGPoint endPoint = CGPointMake(viewOriginx, viewOriginy);
    CGPoint viewOrigin = CGPointMake(CGRectGetMidX(btn1.frame), CGRectGetMidY(btn1.frame));
    
    [self animateMovingObject:btn1 fromPosition:viewOrigin toPosition:endPoint duration:0.5 showButtons:NO];
    
    [self performSelector:@selector(hideSecondButton:) withObject:btn2 afterDelay:0.2];
    [self performSelector:@selector(hideSecondButton:) withObject:btn3 afterDelay:0.5];
    [self performSelector:@selector(hideSecondButton:) withObject:btn4 afterDelay:0.8];
    
    
//    viewOrigin = CGPointMake(CGRectGetMidX(btn2.frame), CGRectGetMidY(btn2.frame));
//    [self animateMovingObject:btn2 fromPosition:viewOrigin toPosition:endPoint duration:1.0 showButtons:NO];
//        viewOrigin = CGPointMake(CGRectGetMidX(btn3.frame), CGRectGetMidY(btn3.frame));
//    [self animateMovingObject:btn3 fromPosition:viewOrigin toPosition:endPoint duration:1.0 showButtons:NO];
//    viewOrigin = CGPointMake(CGRectGetMidX(btn4.frame), CGRectGetMidY(btn4.frame));
//    [self animateMovingObject:btn4 fromPosition:viewOrigin toPosition:endPoint duration:1.0 showButtons:NO];
    
    [self performSelector:@selector(hideDashboard) withObject:nil afterDelay:1.3];

}
@end
