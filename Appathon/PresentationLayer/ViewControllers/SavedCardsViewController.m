//
//  SavedCardsViewController.m
//  Appathon
//
//  Created by Kuldeep Saini on 10/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import "SavedCardsViewController.h"
#import "CoverFlowObject.h"
#import "ScanPayViewController.h"
#import "ScanPayViewController_Extras.h"
#import "constants.h"


#define tag_CardAddedSuccessfully   5678
#define monthYearSeparator  @"-"


#define tag_GetCards    1000
#define tag_CreateCards    1001


@interface SavedCardsViewController ()<iCarouselDataSource,iCarouselDelegate,BaseWebAccessLayerDelegate>
{
    WebAccessLayer *webLayer;
    CoverFlowObject *objectToBeAdded;
}
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation SavedCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.items = [NSMutableArray array];
    CoverFlowObject *obj = [CoverFlowObject new];
    obj.strTitle = @"Add credit or debit card";
    obj.strSubTitle = @"All major credit and debit cards supported";
    [self.items addObject:obj];
    obj = nil;
    
    _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0 , 100, self.view.frame.size.width, 250)];
    _carousel.tag = 111;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeLinear;
    [self.view addSubview:_carousel];
    _carousel.clipsToBounds= YES;
    self.view.clipsToBounds = YES;
    
    

    [self getCardsForUser];
}

-(void)getCardsForUser
{
    [APP_DELEGATE showLaoder];
    
    NSString *body = [NSString stringWithFormat:@"{\"userId\":\"%@\"}", [[UserBO sharedObject] userId]];
    // 9599765900 // 123456
    if([APP_DELEGATE isServerReachable])
    {
        if(webLayer)
        {
            webLayer.callBack = nil;
            webLayer = nil;
        }
        webLayer = [WebAccessLayer new];
        webLayer.callBack = self;
        [webLayer getDataFromWeService:YES withURL:HOME_URL(@"getCards") withBody:body withTag:tag_GetCards];
    }
    else
    {
        [APP_DELEGATE showNoInternetAlert];
    }
 
}


-(void)createCardsForUserWithObject:(CoverFlowObject *)obj
{
    [APP_DELEGATE showLaoder];
    
    NSString *body = [NSString stringWithFormat:@"{\"userId\":\"%@\", \"cardNo\":\"%@\", \"cardType\":\"%@\", \"cardExpiry\":\"%@\", \"cardName\":\"%@\"}", [[UserBO sharedObject] userId],obj.strCardNumber,[NSString stringWithFormat:@"%li",obj.cardType],[NSString stringWithFormat:@"%@%@%@",obj.strMonth,monthYearSeparator,obj.strYear],obj.strCardHolderName];
    // 9599765900 // 123456
    if([APP_DELEGATE isServerReachable])
    {
        if(webLayer)
        {
            webLayer.callBack = nil;
            webLayer = nil;
        }
        webLayer = [WebAccessLayer new];
        webLayer.callBack = self;
        [webLayer getDataFromWeService:YES withURL:HOME_URL(@"createCard") withBody:body withTag:tag_CreateCards];
    }
    else
    {
        [APP_DELEGATE showNoInternetAlert];
    }
    
}
-(void)addDummyData
{
    CoverFlowObject *obj = [CoverFlowObject new];
    [self.items addObject:obj];
    obj = nil;
    
    obj = [CoverFlowObject new];
    obj.strTitle = @"Citi Master Card";
    obj.strSubTitle = @"Current balance : ";
    obj.strCardNumber = @"3765 330572 51007";
    obj.strMonth = @"07";
    obj.strYear = @"18";
    obj.cardType = 1;
    obj.strCardHolderName = @"Mayank Goyal";
    [self.items addObject:obj];
    obj = nil;
    
    obj = [CoverFlowObject new];
    obj.strTitle = @"Citi Master Card";
    obj.strSubTitle = @"Current balance : ";
    [self.items addObject:obj];
    obj = nil;
    
    obj = [CoverFlowObject new];
    obj.strTitle = @"Citi Master Card";
    obj.strSubTitle = @"Current balance : ";
    [self.items addObject:obj];
    obj = nil;
    
    obj = [CoverFlowObject new];
    obj.strTitle = @"Citi Master Card";
    obj.strSubTitle = @"Current balance : ";
    [self.items addObject:obj];
    obj = nil;
}

- (void)insertItem :(CoverFlowObject *)obj
{
    NSInteger index = 1;// = MAX(0, self.carousel.currentItemIndex);
    [self.items insertObject:obj atIndex:(NSUInteger)index];
    [self.carousel insertItemAtIndex:index animated:YES];
    
    [self.carousel reloadItemAtIndex:index animated:YES];
}


#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return self.items.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *lblTitle = nil;
    UILabel *lblSubTitle = nil;
    UILabel *lblCardNumber = nil;
    UILabel *lblValidThru = nil;
    UILabel *lblHolderName = nil;
    UIImageView *imgLogo = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        
        
        view.contentMode = UIViewContentModeScaleAspectFill;
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 20)];
        lblTitle.textColor = [UIColor darkGrayColor];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.font = [UIFont boldSystemFontOfSize:16];
        lblTitle.tag = 1;
        [view addSubview:lblTitle];
        
        lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, 320, 20)];
        lblSubTitle.textColor = [UIColor grayColor];
        lblSubTitle.textAlignment = NSTextAlignmentCenter;
        lblSubTitle.font = [UIFont systemFontOfSize:14];
        lblSubTitle.tag = 2;
        [view addSubview:lblSubTitle];
        
        imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(240, 150, 40, 45)];
        [view addSubview:imgLogo];
        imgLogo.tag = 3;
        
        lblCardNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 20)];
        lblCardNumber.textColor = [UIColor darkGrayColor];
        lblCardNumber.textAlignment = NSTextAlignmentCenter;
        lblCardNumber.font = [UIFont systemFontOfSize:20];
        lblCardNumber.tag = 4;
        [view addSubview:lblCardNumber];
        
        lblValidThru = [[UILabel alloc] initWithFrame:CGRectMake(40, 100, 100, 40)];
        lblValidThru.textColor = [UIColor darkGrayColor];
        lblValidThru.textAlignment = NSTextAlignmentLeft;
        lblValidThru.font = [UIFont systemFontOfSize:12];
        lblValidThru.numberOfLines = 0;
        lblValidThru.tag = 5;
        [view addSubview:lblValidThru];
        
        lblHolderName = [[UILabel alloc] initWithFrame:CGRectMake(40, 160, 100, 20)];
        lblHolderName.textColor = [UIColor darkGrayColor];
        lblHolderName.textAlignment = NSTextAlignmentLeft;
        lblHolderName.font = [UIFont systemFontOfSize:12];
        lblHolderName.numberOfLines = 0;
        lblHolderName.tag = 6;
        [view addSubview:lblHolderName];
    }
    else
    {
        lblTitle = (UILabel *)[view viewWithTag:1];
        lblSubTitle = (UILabel *)[view viewWithTag:2];
        lblCardNumber = (UILabel *)[view viewWithTag:4];
        lblValidThru = (UILabel *)[view viewWithTag:5];
        lblHolderName = (UILabel *)[view viewWithTag:6];
        imgLogo = (UIImageView *)[view viewWithTag:3];
    }
    
    if(index == 0)
    {
        ((UIImageView *)view).image = [UIImage imageNamed:@"page1.png"];
        CoverFlowObject *obj = [self.items objectAtIndex:index];
        lblTitle.text = obj.strTitle;
        lblSubTitle.text = @"";//obj.strSubTitle;
    }
    else
    {
        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        CoverFlowObject *obj = [self.items objectAtIndex:index];
        lblTitle.text = obj.strTitle;
        lblSubTitle.text =  @"";//obj.strSubTitle;
        lblCardNumber.text = obj.strCardNumber;
        lblValidThru.text = [NSString stringWithFormat:@"Valid Thru\n%@/%@", obj.strMonth, obj.strYear];
        lblHolderName.text = obj.strCardHolderName;
        
        imgLogo.image = obj.cardType == 0?[UIImage imageNamed:@"visaCard.png"]:obj.cardType == 1?[UIImage imageNamed:@"masterCard.png"]:obj.cardType == 2?[UIImage imageNamed:@"amexCard.png"]:[UIImage imageNamed:nil];
        
    }
    
    
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if(index == 0)
    {
//        objectToBeAdded = nil;
//        objectToBeAdded = [CoverFlowObject new];
//        objectToBeAdded.strTitle = @"VISA Card";
//        objectToBeAdded.strSubTitle = @"Current balance : ";
//        objectToBeAdded.strCardNumber = @"34567890987";
//        objectToBeAdded.strMonth = @"08";
//        objectToBeAdded.strYear = @"15";
//        objectToBeAdded.cardType = 1;
//        objectToBeAdded.strCardHolderName = @"Mayank Goyal";
//
//        [self createCardsForUserWithObject:objectToBeAdded];

        [self scanTouched:carousel];
    }
}

- (void)scanTouched:(iCarousel*)carosel
{
    ScanPayViewController * scanPayViewController = [[ScanPayViewController alloc] initWithToken:@"c8ac2df03503d80f545fdb95" useConfirmationView:YES useManualEntry:YES];
    scanPayViewController.shouldDisplayFakeExampleCardInFrame = NO;
    scanPayViewController.shouldDisplayStatusBar = YES;
    scanPayViewController.customLogo = [UIImage imageNamed:nil];
    scanPayViewController.shouldDisplayStatusBarBeLight = YES;
    scanPayViewController.fontName = @"TescoDisplayLt-Regular";
    scanPayViewController.shouldDisplayTutorial = YES;
    scanPayViewController.shouldOutputCardImageWithBlurredDigits = YES;
    
    
    // If you want to use your own color for set sight
    [scanPayViewController setSightColor:[UIColor colorWithRed:97 / 255.f green:170 / 255.f blue:219 / 255.f alpha:1.0]];
    
    [scanPayViewController startScannerWithViewController:self success:^(SPCreditCard * card){
        
        // You will be notified of the user interaction through this block
        NSLog(@"%@ Expire %@/%@ CVC: %i", card.number, card.month, card.year, card.type);
        
        objectToBeAdded = nil;
        objectToBeAdded = [CoverFlowObject new];
        objectToBeAdded.strTitle = card.type == 0?@"VISA Card":card.type == 1?@"Master Card":card.type == 2?@"American Express Card":@"Others";
        objectToBeAdded.strSubTitle = @"Current balance : ";
        objectToBeAdded.strCardNumber = card.number;
        objectToBeAdded.strMonth = card.month;
        objectToBeAdded.strYear = card.year;
        objectToBeAdded.cardType = card.type;
        objectToBeAdded.strCardHolderName = [NSString stringWithFormat:@"%@ %@",[[UserBO sharedObject] firstName],[[UserBO sharedObject] lastName]];
        
        [self createCardsForUserWithObject:objectToBeAdded];
        
//        [self.items addObject:obj];
//        
//        [self insertItem:obj];
//        obj = nil;
        
        
        
    } cancel:^{
        
        // You will be notified when the user has canceled through this block
        NSLog(@"User cancel");
    }];
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        if(value > 1)
            return value * 1.05;
        else
            return value;
    }
    return value;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma WebAccessLayer Delegate Methods

- (void)operationCompletedSuccessfully:(id)result andOperationTag:(NSInteger)tag
{
    [APP_DELEGATE performSelectorOnMainThread:@selector(hideLoader) withObject:nil waitUntilDone:YES];
    
    NSLog(@"%@", (NSDictionary *)result);
    
    if(tag == tag_GetCards)
    {
        
        if([result isKindOfClass:[NSArray class]])
        {
            NSArray *arrResponse = (NSArray *)result;
            
            for (NSDictionary *dict in arrResponse) {

                CoverFlowObject *obj = [CoverFlowObject new];
                obj.cardType = [[dict objectForKey:@"cardType"] intValue];

                /*
                 "_id" = 554ed8b74e5044310027eace;
                 cardExpiry = "01-78";
                 cardName = "P L";
                 cardNo = 376533057251007;
                 cardType = 2;
                 userId = LqQr3839;

                 */
                obj.strMonth = [[[dict objectForKey:@"cardExpiry"] componentsSeparatedByString:monthYearSeparator] firstObject];;
                obj.strYear = [[[dict objectForKey:@"cardExpiry"] componentsSeparatedByString:monthYearSeparator] lastObject];;
                obj.strCardHolderName = [dict objectForKey:@"cardName"];
                obj.strCardNumber = [dict objectForKey:@"cardNo"];


                obj.strTitle = obj.cardType == 0?@"VISA Card":obj.cardType == 1?@"Master Card":obj.cardType == 2?@"American Express Card":@"Others";
                [self.items addObject:obj];
                obj = nil;

            }
            
            [self performSelectorOnMainThread:@selector(parsingDone) withObject:nil waitUntilDone:YES ];
            
        }
        else
        {
            [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:@"Error occurred while authenticating user. Please try again later." waitUntilDone:YES ];
        }
        
    }
    else
    {
        if([result isKindOfClass:[NSDictionary class]])
        {
            /*
             "_id" = 554e3147d7c5e9310056b0b9;
             emailId = "bansal.defi@gmail.com";
             firstName = Defi;
             lastName = Bansal;
             mobileNo = 9599765900;
             password = 123456;
             userId = hzgh5196
             */
            
            NSDictionary *ditcData = (NSDictionary *)result;
            NSString *str = [ditcData objectForKey:@"Message"];
            NSRange range = [str rangeOfString:@"success"];
            if([str isKindOfClass:[NSString class]] && range.length)
            {
                [self performSelectorOnMainThread:@selector(cardAddedSuccessfully:) withObject:[ditcData objectForKey:@"Message"] waitUntilDone:YES ];
            }
            else
            {
                [[UserBO sharedObject] setUserId:[ditcData objectForKey:@"userId"]];
                [[UserBO sharedObject] setEmail:[ditcData objectForKey:@"emailId"]];
                [[UserBO sharedObject] setFirstName:[ditcData objectForKey:@"firstName"]];
                [[UserBO sharedObject] setLastName:[ditcData objectForKey:@"lastName"]];
                [[UserBO sharedObject] setMobileNumber:[ditcData objectForKey:@"mobileNo"]];
                [[UserBO sharedObject] setPassword:[ditcData objectForKey:@"password"]];
                [self performSelectorOnMainThread:@selector(parsingDone) withObject:nil waitUntilDone:YES ];
                
            }
            
        }
    }
    /*
    if([result isKindOfClass:[NSDictionary class]])
    {
     
//         "_id" = 554e3147d7c5e9310056b0b9;
//         emailId = "bansal.defi@gmail.com";
//         firstName = Defi;
//         lastName = Bansal;
//         mobileNo = 9599765900;
//         password = 123456;
//         userId = hzgh5196
     
        NSDictionary *ditcData = (NSDictionary *)result;
        if([[ditcData objectForKey:@"Message"] length])
        {
            [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:[ditcData objectForKey:@"Message"] waitUntilDone:YES ];
        }
        else
        {
            [[UserBO sharedObject] setUserId:[ditcData objectForKey:@"userId"]];
            [[UserBO sharedObject] setEmail:[ditcData objectForKey:@"emailId"]];
            [[UserBO sharedObject] setFirstName:[ditcData objectForKey:@"firstName"]];
            [[UserBO sharedObject] setLastName:[ditcData objectForKey:@"lastName"]];
            [[UserBO sharedObject] setMobileNumber:[ditcData objectForKey:@"mobileNo"]];
            [[UserBO sharedObject] setPassword:[ditcData objectForKey:@"password"]];
            [self performSelectorOnMainThread:@selector(parsingDone) withObject:nil waitUntilDone:YES ];
            
        }
        
    }
    else if([result isKindOfClass:[NSArray class]])
    {
        NSArray *arrResponse = (NSArray *)result;
        NSDictionary *ditcData = [arrResponse firstObject];
        [[UserBO sharedObject] setUserId:[ditcData objectForKey:@"userId"]];
        [[UserBO sharedObject] setEmail:[ditcData objectForKey:@"emailId"]];
        [[UserBO sharedObject] setFirstName:[ditcData objectForKey:@"firstName"]];
        [[UserBO sharedObject] setLastName:[ditcData objectForKey:@"lastName"]];
        [[UserBO sharedObject] setMobileNumber:[ditcData objectForKey:@"mobileNo"]];
        [[UserBO sharedObject] setPassword:[ditcData objectForKey:@"password"]];
        
        [self performSelectorOnMainThread:@selector(parsingDone) withObject:nil waitUntilDone:YES ];
        
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:@"Error occurred while authenticating user. Please try again later." waitUntilDone:YES ];
    }
    */
}

-(void)cardAddedSuccessfully:(NSString *)strMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!!" message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    alert.tag = tag_CardAddedSuccessfully;
    alert = nil;

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == tag_CardAddedSuccessfully)
    {
        [self addCardToCorrosal];
    }
}
-(void)addCardToCorrosal
{
//    [self.items addObject:objectToBeAdded];
    [self insertItem:objectToBeAdded];
}

-(void)parsingDone
{
    [_carousel reloadData];
//    DashboardViewController *vwCont= [[DashboardViewController alloc] init];
//    [self.navigationController pushViewController:vwCont animated:YES];
    
}
- (void)errorOccuredWhilePerformingOperation:(NSError *)error andTag:(NSInteger)tag
{
    [APP_DELEGATE performSelectorOnMainThread:@selector(hideLoader) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:error.localizedDescription waitUntilDone:YES ];
}


-(void)showAlertWithMessage:(NSString *)strMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!!" message:strMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    alert = nil;
    
}

@end
