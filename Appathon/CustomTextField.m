//
//  CustomTextField.m
//  Appathon
//
//  Created by Shreyansh Bhardwaj on 10/05/15.
//  Copyright (c) 2015 Shreyansh Bhardwaj. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect ret = [super textRectForBounds:bounds];
    ret.origin.x = ret.origin.x + 15;
//    ret.size.width = ret.size.width - 8;
    return ret;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
@end
