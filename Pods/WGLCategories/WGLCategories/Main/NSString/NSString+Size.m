//
//  NSString+Size.m
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)safeSizeWithFont:(UIFont *)font {
    return [self safeSizeWithFont:font
                constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                    lineBreakMode:NSLineBreakByCharWrapping];
}

- (CGSize)safeSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    CGSize inSize = CGSizeZero;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        CGRect frame = [self boundingRectWithSize:size
                                          options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName : font}
                                          context:nil];
        inSize = CGSizeMake(ceilf(frame.size.width), ceilf(frame.size.height));
    }
    
    if (!isnormal(inSize.width)) {
        inSize.width = 0.0;
    }
    return inSize;
}

@end
