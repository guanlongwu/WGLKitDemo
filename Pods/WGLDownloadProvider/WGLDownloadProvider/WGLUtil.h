//
//  WGLUtil.h
//  WGLDownloadProvider
//
//  Created by wugl on 2019/2/19.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#ifndef WGLUtil_h
#define WGLUtil_h

typedef NS_ENUM(NSInteger, WGLDownloadErrorType) {
    WGLDownloadErrorTypeHTTPError,              //http网络错误
    WGLDownloadErrorTypeInvalidURL,             //非法URL
    WGLDownloadErrorTypeInvalidDirectory,       //非法下载目录
    WGLDownloadErrorTypeInvalidRequestRange,    //非法下载请求范围
    WGLDownloadErrorTypeNotEnoughFreeSpace,     //下载空间不足
    WGLDownloadErrorTypeCacheInDiskError,       //磁盘缓存失败
};

typedef NS_ENUM(NSInteger, WGLDownloadState) {
    WGLDownloadStateUnknow,             //未知
    WGLDownloadStateReady = 1,          //下载准备中
    WGLDownloadStateDownloading,        //正在下载中
    WGLDownloadStateFinish,             //下载完成
    WGLDownloadStateCancelled,          //下载取消
    WGLDownloadStateFailed,             //下载失败
};

#endif /* WGLUtil_h */
