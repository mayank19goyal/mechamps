//
//  ChangePasswordViewController.h
//  Appathon
//
//  Created by Shreyansh Bhardwaj on 10/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import "AppthoneBaseViewController.h"
#import "ChangePasswordView.h"

@interface ChangePasswordViewController : AppthoneBaseViewController<ChangePasswordView_Delegate>
{
    ChangePasswordView *vwPasswordView;

}
@end
