//
//  WGLDownloadTask.h
//  WGLDownloadProvider
//
//  Created by wugl on 2018/12/17.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WGLDownloadTaskState) {
    WGLDownloadTaskStateWaiting,        //等待中
    WGLDownloadTaskStateDownloading,    //下载中
    WGLDownloadTaskStateFinish,         //下载完成
    WGLDownloadTaskStateFailure,        //下载失败
};

@interface WGLDownloadTask : NSObject

/**
 下载URL
 */
@property (nonatomic, copy) NSString *urlString;

/**
 下载文件存放路径
 */
@property (nonatomic, copy) NSString *downloadFilePath;

/**
 下载文件大小
 */
@property (nonatomic, assign) uint64_t downloadFileSize;

/**
 任务状态
 */
@property (nonatomic, assign) WGLDownloadTaskState state;

/**
 已下载大小
 */
@property (nonatomic, assign) uint64_t receiveLength;

/**
 下载文件总大小
 */
@property (nonatomic, assign) uint64_t totalLength;


@end
