//
//  DashboardView.h
//  SampleDashboard
//
//  Created by Manoj Kumar Das on 09/05/15.
//  Copyright (c) 2015 MySelf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DashboardView_Delegate <NSObject>
@optional
-(void)hideDashboard;
-(void)dashboardOptionSelected:(UIButton *)btnDashboard;
@end

@interface DashboardView : UIView


@property (nonatomic, assign) id<DashboardView_Delegate> delegate;




-(void)showDashboard:(UIView *)vw;
+ (DashboardView *)sharedDashboard;
@end
