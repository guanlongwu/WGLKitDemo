//
//  WGLDownloadProvider.m
//  WGLKit
//
//  Created by wugl on 2018/12/17.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#import "WGLDownloadProvider.h"
#import "WGLDownloadTask.h"
#import "WGLDownloader.h"

@interface WGLDownloadProvider ()
@property (nonatomic, strong) NSMutableArray <WGLDownloadTask *> *tasks; //任务队列
@property (nonatomic, strong) NSMutableArray <WGLDownloader *> *downloaders; //下载队列
@end

@implementation WGLDownloadProvider

- (instancetype)init {
    if (self = [super init]) {
        _maxDownloadCount = -1;
        _maxConcurrentDownloadCount = 2;
        _executeOrder = WGLDownloadExeOrderFIFO;
        _tasks = [[NSMutableArray alloc] init];
        _downloaders = [[NSMutableArray alloc] init];
        [self setMaxConcurrentDownloadCount:2];
    }
    return self;
}

- (void)setMaxConcurrentDownloadCount:(NSInteger)maxConcurrentDownloadCount {
    if (_maxConcurrentDownloadCount != maxConcurrentDownloadCount) {
        _maxConcurrentDownloadCount = maxConcurrentDownloadCount;
        
        //TODO：加锁
        //创建下载器队列
        for (int i=0; i<maxConcurrentDownloadCount; i++) {
            WGLDownloader *downloader = [[WGLDownloader alloc] init];
            downloader.dataSource = (id<WGLDownloaderDataSource>)self;
            downloader.delegate = (id<WGLDownloaderDelegate>)self;
            [self.downloaders addObject:downloader];
        }
    }
}

+ (dispatch_queue_t)downloadQueue {
    static dispatch_queue_t dlQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dlQueue = dispatch_queue_create("com.wugl.mobile.downloadProvider.downloadQueue", DISPATCH_QUEUE_SERIAL);
    });
    return dlQueue;
}

#pragma mark - main interface

//下载入口
- (void)downloadWithURL:(NSString *)urlString {
    dispatch_async([WGLDownloadProvider downloadQueue], ^{
        
        //是否命中缓存
        if ([self existInCache:urlString]) {
            return;
        }
        
        //已在任务队列中
        if ([self existInTasks:urlString]) {
            
            //调整下载优先级
            WGLDownloadTask *findTask = [self taskForUrl:urlString];
            if (findTask) {
                if (findTask.state == WGLDownloadTaskStateWaiting
                    && self.executeOrder == WGLDownloadExeOrderLIFO) {
                    [self.tasks removeObject:findTask];
                    [self.tasks insertObject:findTask atIndex:0];
                }
            }
            return;
        }
        
        //限制任务数
        [self limitTasksSize];
        
        //添加到任务队列
        WGLDownloadTask *task = [[WGLDownloadTask alloc] init];
        task.urlString = urlString;
        task.state = WGLDownloadTaskStateWaiting;
        [self addTask:task];
        
        //触发下载
        [self startDownload];
        
    });
}

- (void)addTask:(WGLDownloadTask *)task {
    if (!task) {
        return;
    }
    dispatch_async([WGLDownloadProvider downloadQueue], ^{
        if (self.executeOrder == WGLDownloadExeOrderFIFO) {
            [self.tasks addObject:task];
        }
        else if (self.executeOrder == WGLDownloadExeOrderLIFO) {
            [self.tasks insertObject:task atIndex:0];
        }
        else {
            [self.tasks addObject:task];
        }
    });
}

//开始下载
- (void)startDownload {
    dispatch_async([WGLDownloadProvider downloadQueue], ^{
        for (WGLDownloader *downloader in self.downloaders) {
            //正在下载中
            if (downloader.downloadState == WGLDownloadStateDownloading) {
                continue;
            }
            
            //获取等待下载的任务
            WGLDownloadTask *task = [self preferredWaittingTask];
            if (task == nil) {
                //没有等待下载的任务
                break;
            }
            
            task.state = WGLDownloadTaskStateDownloading;
            
            downloader.urlString = task.urlString;
            [downloader start];
        }
    });
}

//获取等待下载的任务
- (WGLDownloadTask *)preferredWaittingTask {
    for (WGLDownloadTask *task in self.tasks) {
        if (task.state == WGLDownloadTaskStateWaiting) {
            return task;
        }
    }
    return nil;
}

#pragma mark - WGLDownloaderDelegate

- (NSString *)downloader:(WGLDownloader *)downloader getDirectory:(NSString *)urlString {
    return nil;
}

- (void)downloadDidStart:(WGLDownloader *)downloader {
    dispatch_async([WGLDownloadProvider downloadQueue], ^{
        WGLDownloadTask *task = [self taskForUrl:downloader.urlString];
        if (!task) {
            return;
        }
        task.state = WGLDownloadTaskStateDownloading;
        task.downloadFilePath = downloader.downloadFilePath;
        task.downloadFileSize = downloader.downloadFileSize;
    });
}

- (void)downloader:(WGLDownloader *)downloader didReceiveLength:(uint64_t)receiveLength totalLength:(uint64_t)totalLength {
    dispatch_async([WGLDownloadProvider downloadQueue], ^{
        WGLDownloadTask *task = [self taskForUrl:downloader.urlString];
        if (!task) {
            return;
        }
        task.state = WGLDownloadTaskStateDownloading;
        task.receiveLength = receiveLength;
        task.totalLength = totalLength;
    });
}

- (void)downloadDidFinish:(WGLDownloader *)downloader filePath:(NSString *)filePath {
    dispatch_async([WGLDownloadProvider downloadQueue], ^{
        WGLDownloadTask *task = [self taskForUrl:downloader.urlString];
        if (!task) {
            return;
        }
        task.state = WGLDownloadTaskStateFinish;
        task.receiveLength = task.totalLength;
        task.downloadFileSize = downloader.downloadFileSize;
        
        [self startDownload];
    });
}

- (void)downloadDidFail:(WGLDownloader *)downloader errorType:(WGLDownloadErrorType)errorType {
    dispatch_async([WGLDownloadProvider downloadQueue], ^{
        WGLDownloadTask *task = [self taskForUrl:downloader.urlString];
        if (!task) {
            return;
        }
        task.state = WGLDownloadTaskStateFailure;
        task.downloadFileSize = downloader.downloadFileSize;
        
        [self startDownload];
    });
}


#pragma mark - private interface

//缓存是否命中
- (BOOL)existInCache:(NSString *)urlString {
    BOOL exist = NO;
    if ([self.dataSource respondsToSelector:@selector(downloadProvider:existCache:)]) {
        exist = [self.dataSource downloadProvider:self existCache:urlString];
    }
    return exist;
}

//已在任务队列
- (BOOL)existInTasks:(NSString *)urlString {
    __block BOOL exist = NO;
    [self.tasks enumerateObjectsUsingBlock:^(WGLDownloadTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.urlString isEqualToString:urlString]) {
            exist = YES;
            *stop = YES;
        }
    }];
    return exist;
}

//获取url对应的任务
- (WGLDownloadTask *)taskForUrl:(NSString *)urlString {
    __block WGLDownloadTask *task = nil;
    [self.tasks enumerateObjectsUsingBlock:^(WGLDownloadTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.urlString isEqualToString:urlString]) {
            task = obj;
            *stop = YES;
        }
    }];
    return task;
}

//限制任务数
- (void)limitTasksSize {
    if (self.maxDownloadCount == -1) {
        //不受限制
        return;
    }
    if (self.tasks.count <= self.maxDownloadCount) {
        return;
    }
    dispatch_async([WGLDownloadProvider downloadQueue], ^{
        while (self.tasks.count > self.maxDownloadCount) {
            [self.tasks removeLastObject];
        }
    });
}


@end
