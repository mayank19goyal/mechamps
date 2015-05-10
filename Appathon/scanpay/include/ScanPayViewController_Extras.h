//
//  ScanPayViewController_Extras.h
//  ScanpaySDK
//
//  Created by Kévin Aujoulet on 4/25/14.
//  Copyright (c) 2014 Kévin Aujoulet. All rights reserved.
//

@interface ScanPayViewController (Extras)

/**
 @property To replace the ScanPay logo with yours. Or if you don't want any logo, simply put an empty png image.
 */
@property (nonatomic, strong) UIImage * customLogo;

/**
 @property How much time the view will stay in scan mode before automatically going to manual entry. Default is 3600 seconds.
 */
@property (nonatomic) float secondsTillGoToManualEntry;

/**
 @property Whether or not the card is in frame
 */
@property (nonatomic) BOOL shouldDisplayFakeExampleCardInFrame;

/**
 @property Color of sight when a card is detected in frame. White by default
 */
@property (nonatomic, strong) UIColor *sightColorWhenCardIsInFrame;

/**
 @property Color of the top and bottom band. Black by default
 */
@property (nonatomic, strong) UIColor *topBottomBandColor;

/**
 @property Color of the UIBarButtonItem. White by default
 */
@property (nonatomic, strong) UIColor *toolBarButtonColor;

/**
 @property Whether or not the status bar is displayed. YES by default
 */
@property (nonatomic) BOOL shouldDisplayStatusBar;

/**
 @property Whether the status bar should light or not (dark). Light by default
 */
@property (nonatomic) BOOL shouldDisplayStatusBarBeLight;

/**
 @property The name of the font you want to use, don't forget to add it to your project. Default is nil : System font is used.
 */
@property (nonatomic, strong) NSString *fontName;

/**
 @property Whether or not the tutorial (?) should be displayed. YES by default
 */
@property (nonatomic) BOOL shouldDisplayTutorial;

/**
 @property Whether or not the security sentence should be displayed. YES by default
 */
@property (nonatomic) BOOL shouldDisplaySecuritySentence;

/**
 @property Whether or not the accepted cards should be displayed. YES by default
 */
@property (nonatomic) BOOL shouldDisplayAcceptedCards;

/**
 @property Whether or not to output a UIImage* SPCreditCard.cardImageWithBlurredDigits. NO by default
 */
@property (nonatomic) BOOL shouldOutputCardImageWithBlurredDigits;


@end