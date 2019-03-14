//
//  UIDevice+DiskMemory.h
//  WGLUtils
//
//  Created by wugl on 2019/3/14.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (DiskMemory)

#pragma mark - Disk Space

/**
 磁盘空间的总字节数bytes
 (-1 when error occurs)
 */
@property (nonatomic, readonly) int64_t diskSpace;

/**
 空闲的磁盘空间的字节数bytes
 (-1 when error occurs)
 */
@property (nonatomic, readonly) int64_t diskSpaceFree;

/**
 已使用的磁盘空间的字节数bytes
 (-1 when error occurs)
 */
@property (nonatomic, readonly) int64_t diskSpaceUsed;


#pragma mark - Memory Information

/**
 总物理内存的总字节数bytes
 (-1 when error occurs)
 */
@property (nonatomic, readonly) int64_t memoryTotal;

/**
 已使用的物理内存字节数bytes(active + inactive + wired)
 (-1 when error occurs)
 */
@property (nonatomic, readonly) int64_t memoryUsed;

/**
 空闲的物理内存字节数bytes
 (-1 when error occurs)
 */
@property (nonatomic, readonly) int64_t memoryFree;

/**
 活跃的物理内存字节数bytes
 (-1 when error occurs)
 */
@property (nonatomic, readonly) int64_t memoryActive;

/**
 非活跃的物理内存字节数bytes
 (-1 when error occurs)
 */
@property (nonatomic, readonly) int64_t memoryInactive;

/**
 Wired memory in byte.(-1 when error occurs)
 */
@property (nonatomic, readonly) int64_t memoryWired;

/**
 便携式存储器Purgable memory
 (-1 when error occurs)
 */
@property (nonatomic, readonly) int64_t memoryPurgable;

@end
