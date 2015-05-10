//
//  ChangePasswordView.h
//  SampleDashboard
//
//  Created by Manoj Kumar Das on 09/05/15.
//  Copyright (c) 2015 MySelf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangePasswordView_Delegate <NSObject>
@optional
-(void)updatePassword:(NSString*)strOldPass withNewPassword:(NSString *)strNewPass;

@end

@interface ChangePasswordView : UIView

@property (nonatomic, assign) id<ChangePasswordView_Delegate> delegate;

+ (ChangePasswordView *)sharedDashboard;
-(void)showChangePasswordView:(UIView *)vw;
-(void)hideChangePasswordView;
@end
