//
//  NSData+Encode.h
//  WGLKitDemo
//
//  Created by wugl on 2019/3/15.
//  Copyright © 2019年 huya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Encode)

#pragma mark - Encode/Decode

/**
 返回一个UTF8解码的字符串.
 */
- (nullable NSString *)utf8String;

/**
 返回一个大写的HEX十六进制的字符串.
 */
- (nullable NSString *)hexString;

/**
 将HEX十六进制的字符串，转化成NSData.
 */
+ (nullable NSData *)dataWithHexString:(NSString *)hexString;


#pragma mark - Base64Encode/Base64Decode

/**
 返回一个base64编码的字符串.
 */
- (nullable NSString *)base64EncodedString;

/**
 将base64编码的字符串，转化成NSData.
 */
+ (nullable NSData *)dataWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 返回已解码的NSData的NSDictionary或NSArray.
 */
- (nullable id)jsonValueDecoded;

@end

NS_ASSUME_NONNULL_END

