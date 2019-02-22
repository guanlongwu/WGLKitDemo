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

#define Lock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(self->_lock)

@interface WGLDownloadProvider () {
    dispatch_semaphore_t _lock;
}
@property (nonatomic, strong) NSMutableArray <WGLDownloadTask *> *tasks; //任务队列
@property (nonatomic, strong) NSMutableArray <WGLDownloader *> *downloaders; //下载队列
@end

@implementation WGLDownloadProvider

+ (instancetype)sharedProvider {
    static WGLDownloadProvider *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _lock = dispatch_semaphore_create(1);
        _maxDownloadCount = -1;
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
                Lock();
                [self.tasks removeObject:findTask];
                [self.tasks insertObject:findTask atIndex:0];
                Unlock();
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
}

- (void)addTask:(WGLDownloadTask *)task {
    if (!task) {
        return;
    }
    Lock();
    if (self.executeOrder == WGLDownloadExeOrderFIFO) {
        [self.tasks addObject:task];
    }
    else if (self.executeOrder == WGLDownloadExeOrderLIFO) {
        [self.tasks insertObject:task atIndex:0];
    }
    else {
        [self.tasks addObject:task];
    }
    Unlock();
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

#pragma mark - WGLDownloaderDelegate / datasource

- (NSString *)downloaderGetDirectory:(WGLDownloader *)downloader urlString:(NSString *)urlString {
    NSString *directory = nil;
    if ([self.dataSource respondsToSelector:@selector(downloadProvider:getDirectory:)]) {
        directory = [self.dataSource downloadProvider:self getDirectory:urlString];
    }
    return directory;
}

- (NSString *)downloaderCacheFileName:(WGLDownloader *)downloader urlString:(NSString *)urlString {
    NSString *fileName = nil;
    if ([self.dataSource respondsToSelector:@selector(downloadProvider:cacheFileName:)]) {
        fileName = [self.dataSource downloadProvider:self cacheFileName:urlString];
    }
    return fileName;
}

- (void)downloadDidStart:(WGLDownloader *)downloader {
    WGLDownloadTask *task = [self taskForUrl:downloader.urlString];
    if (!task) {
        return;
    }
    task.state = WGLDownloadTaskStateDownloading;
    task.downloadFilePath = downloader.downloadFilePath;
    task.downloadFileSize = downloader.downloadFileSize;
    
    if ([self.delegate respondsToSelector:@selector(downloadDidStart:urlString:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate downloadDidStart:self urlString:downloader.urlString];
        });
    }
}

- (void)downloader:(WGLDownloader *)downloader didReceiveLength:(uint64_t)receiveLength totalLength:(uint64_t)totalLength {
    WGLDownloadTask *task = [self taskForUrl:downloader.urlString];
    if (!task) {
        return;
    }
    task.state = WGLDownloadTaskStateDownloading;
    task.receiveLength = receiveLength;
    task.totalLength = totalLength;
    
    if ([self.delegate respondsToSelector:@selector(downloader:urlString:didReceiveLength:totalLength:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate downloader:self urlString:downloader.urlString didReceiveLength:receiveLength totalLength:totalLength];
        });
    }
}

- (void)downloadDidFinish:(WGLDownloader *)downloader filePath:(NSString *)filePath {
    WGLDownloadTask *task = [self taskForUrl:downloader.urlString];
    if (!task) {
        return;
    }
    task.state = WGLDownloadTaskStateFinish;
    task.receiveLength = task.totalLength;
    task.downloadFileSize = downloader.downloadFileSize;
    
    [self startDownload];
    
    if ([self.delegate respondsToSelector:@selector(downloadDidFinish:urlString:filePath:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate downloadDidFinish:self urlString:downloader.urlString filePath:filePath];
        });
    }
}

- (void)downloadDidFail:(WGLDownloader *)downloader errorType:(WGLDownloadErrorType)errorType {
    WGLDownloadTask *task = [self taskForUrl:downloader.urlString];
    if (!task) {
        return;
    }
    task.state = WGLDownloadTaskStateFailure;
    task.downloadFileSize = downloader.downloadFileSize;
    
    [self startDownload];
    
    if ([self.delegate respondsToSelector:@selector(downloadDidFail:urlString:errorType:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate downloadDidFail:self urlString:downloader.urlString errorType:errorType];
        });
    }
}


#pragma mark - private interface

//获取等待下载的任务
- (WGLDownloadTask *)preferredWaittingTask {
    WGLDownloadTask *findTask = nil;
    Lock();
    for (WGLDownloadTask *task in self.tasks) {
        if (task.state == WGLDownloadTaskStateWaiting) {
            findTask = task;
        }
    }
    Unlock();
    return findTask;
}

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
    Lock();
    [self.tasks enumerateObjectsUsingBlock:^(WGLDownloadTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.urlString isEqualToString:urlString]) {
            exist = YES;
            *stop = YES;
        }
    }];
    Unlock();
    return exist;
}

//获取url对应的任务
- (WGLDownloadTask *)taskForUrl:(NSString *)urlString {
    __block WGLDownloadTask *task = nil;
    Lock();
    [self.tasks enumerateObjectsUsingBlock:^(WGLDownloadTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.urlString isEqualToString:urlString]) {
            task = obj;
            *stop = YES;
        }
    }];
    Unlock();
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
    Lock();
    while (self.tasks.count > self.maxDownloadCount) {
        [self.tasks removeLastObject];
    }
    Unlock();
}


@end
