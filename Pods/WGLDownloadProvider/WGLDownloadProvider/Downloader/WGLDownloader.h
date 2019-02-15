//
//  WGLDownloader.h
//  WGLDownloadProvider
//
//  Created by wugl on 2018/12/21.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WGLDownloaderInfo;
@protocol WGLDownloaderDataSource;
@protocol WGLDownloaderDelegate;

typedef NS_ENUM(NSInteger, WGLDownloadErrorType) {
    WGLDownloadErrorTypeHTTPError,              //http网络错误
    WGLDownloadErrorTypeInvalidURL,             //非法URL
    WGLDownloadErrorTypeInvalidDirectory,       //非法下载目录
    WGLDownloadErrorTypeInvalidRequestRange,    //非法下载请求范围
    WGLDownloadErrorTypeNotEnoughFreeSpace,     //下载空间不足
};

typedef NS_ENUM(NSInteger, WGLDownloadState) {
    WGLDownloadStateReady = 0,
    WGLDownloadStateDownloading,
    WGLDownloadStateFinish,
    WGLDownloadStateCancelled,
    WGLDownloadStateFailed,
};

@interface WGLDownloader : NSObject

@property (nonatomic, weak) id <WGLDownloaderDataSource> dataSource;
@property (nonatomic, weak) id <WGLDownloaderDelegate> delegate;

/**
 下载地址url
 */
@property (nonatomic, copy) NSString *urlString;

/**
 下载范围
 */
@property (nonatomic, assign) uint64_t fromByte, toByte;

/**
 下载文件存放路径
 */
@property (nonatomic, readonly) NSString *downloadFilePath;

/**
 下载文件大小
 */
@property (nonatomic, readonly) uint64_t downloadFileSize;

/**
 下载状态
 */
@property (nonatomic, readonly) WGLDownloadState downloadState;

/**
 开始下载
 */
- (void)start;

/**
 取消下载
 */
- (void)cancel;


@end


@protocol WGLDownloaderDataSource <NSObject>

//获取下载文件存放的目录
- (NSString *)downloader:(WGLDownloader *)downloader getDirectory:(NSString *)urlString;

@end


@protocol WGLDownloaderDelegate <NSObject>

//下载开始
- (void)downloadDidStart:(WGLDownloader *)downloader;

//下载中
- (void)downloader:(WGLDownloader *)downloader didReceiveLength:(uint64_t)receiveLength totalLength:(uint64_t)totalLength;

//下载成功
- (void)downloadDidFinish:(WGLDownloader *)downloader filePath:(NSString *)filePath;

//下载失败
- (void)downloadDidFail:(WGLDownloader *)downloader errorType:(WGLDownloadErrorType)errorType;

@end



