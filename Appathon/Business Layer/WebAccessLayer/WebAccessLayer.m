//
//  WebAccessLayer.m
//  WebService
//
//  Created by Mayank Goyal on 09/05/15.
//  Copyright (c) 2015 Mayank Goyal. All rights reserved.
//

#import "WebAccessLayer.h"

@interface WebAccessLayer ()
{
    NSMutableData *receiveData;
}

@end

@implementation WebAccessLayer


-(void)getDataFromWeService:(BOOL)isPost withURL:(NSString *)url withBody:(NSString *)body withTag:(NSInteger)tag
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod: isPost?@"POST":@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil)
         {
             if(self !=nil && [self  respondsToSelector:@selector(parseTheData:andResponseTag:)])
             {
                 [self parseTheData:data andResponseTag:tag];
             }
             
             if(error!=nil)
             {
                 if(self.callBack!=nil && [self.callBack respondsToSelector:@selector(errorOccuredWhilePerformingOperation:andTag:)])
                 {
                     [self.callBack errorOccuredWhilePerformingOperation:error andTag:tag];
                 }
                 NSLog(@"json error:%@",error);
             }
         }
         
     }];
}

// downloaded the data decide the step
-(void)parseTheData:(NSData *)data andResponseTag:(NSInteger)tag
{
    NSError *error = nil;
    NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"strResponse.. %@",strResponse);
    
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if(!error)
    {
        if(self.callBack!=nil && [self.callBack respondsToSelector:@selector(operationCompletedSuccessfully:andOperationTag:)])
        {
            [self.callBack operationCompletedSuccessfully:object andOperationTag:tag];
        }
    }
    else
    {
        if(self.callBack!=nil && [self.callBack respondsToSelector:@selector(errorOccuredWhilePerformingOperation:andTag:)])
        {
            [self.callBack errorOccuredWhilePerformingOperation:error andTag:tag];
        }
    }
}


@end
