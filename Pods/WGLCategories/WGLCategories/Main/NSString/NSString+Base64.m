//
//  NSString+Base64.m
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import "NSString+Base64.h"
#import "NSData+Encode.h"

@implementation NSString (Base64)

- (NSString *)base64EncodedString {
    NSString *result = [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    return result;
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData dataWithBase64EncodedString:base64EncodedString];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

@end
