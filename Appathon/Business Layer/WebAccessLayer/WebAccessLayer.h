//
//  WebAccessLayer.h
//  WebService
//
//  Created by Mayank Goyal on 09/05/15.
//  Copyright (c) 2015 Mayank Goyal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BaseWebAccessLayerDelegate;

@interface WebAccessLayer : NSObject

@property (nonatomic, retain) id <BaseWebAccessLayerDelegate>callBack;

-(void)getDataFromWeService:(BOOL)isPost withURL:(NSString *)url withBody:(NSString *)body withTag:(NSInteger)tag;

@end


@protocol BaseWebAccessLayerDelegate <NSObject>

@optional
- (void)errorOccuredWhilePerformingOperation:(NSError *)error andTag:(NSInteger)tag;
- (void)operationCompletedSuccessfully:(id)result andOperationTag:(NSInteger)tag;

@end
