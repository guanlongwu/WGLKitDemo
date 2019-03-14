//
//  NSString+Base64.m
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import "NSString+Base64.h"

@implementation NSString (Base64)

/**
 *  将普通字符串转换成base64字符串
 *
 *  @return base64字符串
 */
- (NSString *)toBase64String {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    
    return base64String;
}


/**
 *  将base64字符串转换成普通字符串
 *
 *  @return 普通字符串
 */
+ (NSString *)textFromBase64String:(NSString *)base64String {
    if (!base64String) {
        return nil;
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return text;
}

@end
