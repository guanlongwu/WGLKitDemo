//
//  NSData+Encrypt.h
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Encrypt)

/**
 使用AES返回加密的NSData
 @param key   长度为16,24或32的密钥（128,192或256位）.
 @param iv    初始化向量长度为16（128位），当你不想使用iv时，通过nil.
 */
- (nullable NSData *)aes256EncryptWithKey:(NSData *)key iv:(nullable NSData *)iv;

/**
 使用AES返回解密的NSData
 @param key   长度为16,24或32的密钥（128,192或256位）.
 @param iv    初始化向量长度为16（128位），当你不想使用iv时，通过nil.
 */
- (nullable NSData *)aes256DecryptWithkey:(NSData *)key iv:(nullable NSData *)iv;

@end

NS_ASSUME_NONNULL_END

