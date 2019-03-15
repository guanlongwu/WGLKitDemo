//
//  NSString+Base64.h
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)

/**
 将普通字符串转换成base64字符串
 */
- (NSString *)base64EncodedString;

/**
 将base64字符串转换成普通字符串
 */
+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString;

@end
