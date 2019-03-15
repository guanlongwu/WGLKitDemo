//
//  NSString+Hash.h
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Hash)

/**
 返回一个md2哈希的小写string
 */
- (nullable NSString *)md2String;

/**
 返回一个md4哈希的小写string
 */
- (nullable NSString *)md4String;

/**
 返回一个md5哈希的小写string
 */
- (nullable NSString *)md5String;

/**
 返回一个sha1哈希的小写string
 */
- (nullable NSString *)sha1String;

/**
 返回一个sha224哈希的小写string
 */
- (nullable NSString *)sha224String;

/**
 返回一个sha256哈希的小写string
 */
- (nullable NSString *)sha256String;

/**
 返回一个sha384哈希的小写string
 */
- (nullable NSString *)sha384String;

/**
 返回一个sha512哈希的小写string
 */
- (nullable NSString *)sha512String;

/**
 返回一个带密钥key的md5算法的hmac小写string
*/
- (nullable NSString *)hmacMD5StringWithKey:(NSString *)key;

/**
 返回一个带密钥key的sha1算法的hmac小写string
 */
- (nullable NSString *)hmacSHA1StringWithKey:(NSString *)key;

/**
 返回一个带密钥key的sha224算法的hmac小写string
 */
- (nullable NSString *)hmacSHA224StringWithKey:(NSString *)key;

/**
 返回一个带密钥key的sha256算法的hmac小写string
 */
- (nullable NSString *)hmacSHA256StringWithKey:(NSString *)key;

/**
 返回一个带密钥key的sha384算法的hmac小写string
 */
- (nullable NSString *)hmacSHA384StringWithKey:(NSString *)key;

/**
 返回一个带密钥key的sha512算法的hmac小写string
 */
- (nullable NSString *)hmacSHA512StringWithKey:(NSString *)key;

/**
 返回一个crc32哈希的小写string.
 */
- (nullable NSString *)crc32String;

@end

NS_ASSUME_NONNULL_END

