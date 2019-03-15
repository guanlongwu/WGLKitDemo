//
//  NSData+Hash.h
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Hash)

/**
 返回一个md2哈希的小写字符串.
 */
- (NSString *)md2String;

/**
 返回一个md2哈希的NSData.
 */
- (NSData *)md2Data;

/**
 返回一个md4哈希的小写字符串.
 */
- (NSString *)md4String;

/**
 返回一个md4哈希的NSData.
 */
- (NSData *)md4Data;

/**
 返回一个md5哈希的小写字符串.
 */
- (NSString *)md5String;

/**
 返回一个md5哈希的NSData.
 */
- (NSData *)md5Data;

/**
 返回一个sha1哈希的小写字符串.
 */
- (NSString *)sha1String;

/**
 返回一个sha1哈希的NSData.
 */
- (NSData *)sha1Data;

/**
 返回一个sha224哈希的小写字符串.
 */
- (NSString *)sha224String;

/**
 返回一个sha224哈希的NSData.
 */
- (NSData *)sha224Data;

/**
 返回一个sha256哈希的小写字符串.
 */
- (NSString *)sha256String;

/**
 返回一个sha256哈希的NSData.
 */
- (NSData *)sha256Data;

/**
 返回一个sha384哈希的小写字符串.
 */
- (NSString *)sha384String;

/**
 返回一个sha384哈希的NSData.
 */
- (NSData *)sha384Data;

/**
 返回一个sha512哈希的小写字符串.
 */
- (NSString *)sha512String;

/**
 返回一个sha512哈希的NSData.
 */
- (NSData *)sha512Data;

/**
 返回一个使用带有密钥key的md5哈希的小写字符串
 */
- (NSString *)hmacMD5StringWithKey:(NSString *)key;

/**
 返回一个使用带有密钥key的md5哈希的NSData
 */
- (NSData *)hmacMD5DataWithKey:(NSData *)key;

/**
 返回一个使用带有密钥key的sha1哈希的小写字符串
 */
- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

/**
 返回一个使用带有密钥key的sha1哈希的NSData
 */
- (NSData *)hmacSHA1DataWithKey:(NSData *)key;

/**
 返回一个使用带有密钥key的sha224哈希的小写字符串
 */
- (NSString *)hmacSHA224StringWithKey:(NSString *)key;

/**
 返回一个使用带有密钥key的sha224哈希的NSData
 */
- (NSData *)hmacSHA224DataWithKey:(NSData *)key;

/**
 返回一个使用带有密钥key的sha256哈希的小写字符串
 */
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

/**
 返回一个使用带有密钥key的sha256哈希的NSData
 */
- (NSData *)hmacSHA256DataWithKey:(NSData *)key;

/**
 返回一个使用带有密钥key的sha384哈希的小写字符串
 */
- (NSString *)hmacSHA384StringWithKey:(NSString *)key;

/**
 返回一个使用带有密钥key的sha384哈希的NSData
 */
- (NSData *)hmacSHA384DataWithKey:(NSData *)key;

/**
 返回一个使用带有密钥key的sha512哈希的小写字符串
 */
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

/**
 返回一个使用带有密钥key的sha512哈希的NSData
 */
- (NSData *)hmacSHA512DataWithKey:(NSData *)key;

/**
 返回一个crc32哈希的小写字符串.
 */
- (NSString *)crc32String;

/**
 返回crc32哈希。
 */
- (uint32_t)crc32;


@end
