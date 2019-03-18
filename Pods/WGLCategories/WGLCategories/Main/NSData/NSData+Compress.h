//
//  NSData+Compress.h
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Compress)

/**
 从gzip数据中解压缩出的数据（解压）
 */
- (nullable NSData *)gzipInflate;

/**
 将数据压缩成默认压缩级别的gzip数据（压缩）
 */
- (nullable NSData *)gzipDeflate;

/**
 从zlib数据中解压缩出的数据（解压）
 */
- (nullable NSData *)zlibInflate;

/**
 将数据压缩成默认压缩级别的zlib数据（压缩）
 */
- (nullable NSData *)zlibDeflate;

@end
