//
//  NSFileManager+Extensions.h
//  WGLUtils
//
//  Created by wugl on 2019/3/13.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Extensions)

/// 程序沙盒的Documents文件夹路径
@property (nonatomic, readonly) NSURL *documentsURL;
@property (nonatomic, readonly) NSString *documentsPath;

/// 程序沙盒的Caches文件夹路径
@property (nonatomic, readonly) NSURL *cachesURL;
@property (nonatomic, readonly) NSString *cachesPath;

/// 程序沙盒的Library文件夹路径
@property (nonatomic, readonly) NSURL *libraryURL;
@property (nonatomic, readonly) NSString *libraryPath;

@end
