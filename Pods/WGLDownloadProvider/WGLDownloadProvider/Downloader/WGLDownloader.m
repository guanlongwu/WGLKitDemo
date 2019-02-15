//
//  WGLDownloader.m
//  WGLDownloadProvider
//
//  Created by wugl on 2018/12/21.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#define kKeepDiskSpace      (20)      //预留给用户的磁盘缓存空间大小20MB
static const double kBufferSize = (1); //每下载1 MB数据则写一次磁盘

#import "WGLDownloader.h"

@interface WGLDownloader ()
@property (nonatomic, copy) NSString *downloadFilePath;
@property (nonatomic, assign) uint64_t downloadFileSize;
@property (nonatomic, assign) WGLDownloadState downloadState;

@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, assign) uint64_t expectedDataLength;
@property (nonatomic, assign) uint64_t receivedDataLength;
@property (nonatomic, strong) NSFileHandle *fileHandle;

//默认下载目录NSTemporaryDirectory()
@property (nonatomic, copy) NSString *defaultDirectory;

@end

@implementation WGLDownloader

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)start {
    if (self.downloadState == WGLDownloadStateReady
        || self.downloadState == WGLDownloadStateDownloading) {
        //已经处在下载中状态
        return;
    }
    
    //先清除旧的下载
    [self cancel];
    
    //下载准备
    [self prepare];
    
    //开始新的下载
    self.downloadState = WGLDownloadStateReady;
    self.receiveData = [[NSMutableData alloc] init];
    [self initConnection];
}

- (void)cancel {
    if (self.connection
        && self.downloadState == WGLDownloadStateDownloading) {
        //正处于下载中状态，则取消下载
        [self.connection cancel];
    }
    self.downloadState = WGLDownloadStateCancelled;
    self.receiveData = nil;
    self.connection = nil;
}

- (void)initConnection {
    if (self.urlString.length == 0) {
        return;
    }
    self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    
    //Invalid URL
    if (![NSURLConnection canHandleRequest:self.request]) {
        if ([self.delegate respondsToSelector:@selector(downloadDidFail:errorType:)]) {
            [self.delegate downloadDidFail:self errorType:WGLDownloadErrorTypeInvalidURL];
        }
        [self cancel];
        return;
    }
    
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:(id<NSURLConnectionDelegate>)self startImmediately:NO];
    [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.connection start];
}

//下载准备
- (void)prepare {
    
    //目录不存在，则创建
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:self.downloadDirectory isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:self.downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
    }
    
    //文件不存在，则创建
    BOOL fileExist = [fileManager fileExistsAtPath:self.downloadFilePath];
    if (!fileExist) {
        [fileManager createFileAtPath:self.downloadFilePath contents:nil attributes:nil];
        
        //是否设定了下载范围
        if (self.toByte > self.fromByte) {
            NSString *range = [NSString stringWithFormat:@"bytes=%lld-%lld", self.fromByte, self.toByte];
            [self.request setValue:range forHTTPHeaderField:@"Range"];
        }
    }
    else {
        //文件已存在，则断点续传下载
        
        uint64_t existFileSize = [self getFileSizeFromPath:self.downloadFilePath];
        if (existFileSize > self.fromByte
            && existFileSize < self.toByte) {
            NSString *range = [NSString stringWithFormat:@"bytes=%lld-%lld", existFileSize, self.toByte];
            [self.request setValue:range forHTTPHeaderField:@"Range"];
        }
        else if (self.toByte > self.fromByte) {
            NSString *range = [NSString stringWithFormat:@"bytes=%lld-%lld", self.fromByte, self.toByte];
            [self.request setValue:range forHTTPHeaderField:@"Range"];
        }
        
        self.receivedDataLength += existFileSize;
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    //文件总长度=已下载的长度（断点下载的情况下>0）+此次预期下载的长度
    self.expectedDataLength = self.receivedDataLength + [response expectedContentLength];
    
    //检测下载是否合法
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode >= 400) {
        self.downloadState = WGLDownloadStateFailed;
        
        if (httpResponse.statusCode == 416) {
            //1、断点下载的请求范围有问题，则选择删除本地缓存，下次取消断点下载
            
            if ([self.delegate respondsToSelector:@selector(downloadDidFail:errorType:)]) {
                [self.delegate downloadDidFail:self errorType:WGLDownloadErrorTypeInvalidRequestRange];
            }
        }
        else {
            //2、HTTP error
            
            if ([self.delegate respondsToSelector:@selector(downloadDidFail:errorType:)]) {
                [self.delegate downloadDidFail:self errorType:WGLDownloadErrorTypeHTTPError];
            }
        }
        
        [self cancel];
    }
    else {
        
        long long expected = @(self.expectedDataLength).longLongValue;
        uint64_t freeDiskSpace = [self getDiskFreeSpace];
        if (freeDiskSpace < kKeepDiskSpace
            || (freeDiskSpace < expected + kKeepDiskSpace && expected != -1)) {
            //3、Not Enough free space
            
            self.downloadState = WGLDownloadStateFailed;
            
            if ([self.delegate respondsToSelector:@selector(downloadDidFail:errorType:)]) {
                [self.delegate downloadDidFail:self errorType:WGLDownloadErrorTypeNotEnoughFreeSpace];
            }
            [self cancel];
        }
        else {
            //开始下载
            
            self.downloadState = WGLDownloadStateDownloading;
            self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.downloadFilePath];
            [self caculateDownloadFileSize];
            
            if ([self.delegate respondsToSelector:@selector(downloadDidStart:)]) {
                [self.delegate downloadDidStart:self];
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if (self.downloadState == WGLDownloadStateFailed
        || self.downloadState == WGLDownloadStateCancelled) {
        return;
    }
    self.downloadState = WGLDownloadStateDownloading;
    
    [self.receiveData appendData:data];
    self.receivedDataLength += data.length;
    
    //每下载完1MB则写入一次磁盘
    uint64_t hasReceivedLength = self.receiveData.length / 1024 / 1024;
    if (hasReceivedLength > kBufferSize) {
        [self.fileHandle writeData:self.receiveData];
        self.receiveData.data = [NSData data];
    }
    
    if ([self.delegate respondsToSelector:@selector(downloader:didReceiveLength:totalLength:)]) {
        [self.delegate downloader:self didReceiveLength:self.receivedDataLength totalLength:self.expectedDataLength];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (self.downloadState == WGLDownloadStateDownloading) {
        self.downloadState = WGLDownloadStateFinish;
        
        [self.fileHandle writeData:self.receiveData];
        self.receiveData.data = [NSData data];
        [self caculateDownloadFileSize];
        
        if ([self.delegate respondsToSelector:@selector(downloadDidFinish:filePath:)]) {
            [self.delegate downloadDidFinish:self filePath:self.downloadFilePath];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.downloadState = WGLDownloadStateFailed;
    [self caculateDownloadFileSize];

    if ([self.delegate respondsToSelector:@selector(downloadDidFail:errorType:)]) {
        [self.delegate downloadDidFail:self errorType:WGLDownloadErrorTypeHTTPError];
    }
}

#pragma mark - private

//下载文件存放的目录
- (NSString *)downloadDirectory {
    NSString *directory = nil;
    if ([self.dataSource respondsToSelector:@selector(downloader:getDirectory:)]) {
        directory = [self.dataSource downloader:self getDirectory:self.urlString];
    }
    if (directory.length < 5) {
        directory = self.defaultDirectory;
    }
    return directory;
}

//下载文件存放的路径
- (NSString *)downloadFilePath {
    NSString *path = [self.downloadDirectory stringByAppendingPathComponent:self.urlString];
    if (path.length < 5) {
        path = self.defaultFilePath;
    }
    return path;
}

//默认下载目录
- (NSString *)defaultDirectory {
    if (!_defaultDirectory) {
        _defaultDirectory = [[NSString alloc] initWithString:NSTemporaryDirectory()];
    }
    return _defaultDirectory;
}

//默认下载路径
- (NSString *)defaultFilePath {
    return [self.defaultDirectory stringByAppendingPathComponent:self.urlString];
}

//获取磁盘总容量（单位MB）
- (uint64_t)getDiskTotalSpace {
    uint64_t totalSpace = 0;
    __autoreleasing NSError *error = nil;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:path error:&error];
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue] / 1024 / 1024;
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return totalSpace;
}

//获取磁盘剩余容量（单位MB）
- (uint64_t)getDiskFreeSpace {
    uint64_t totalFreeSpace = 0;
    __autoreleasing NSError *error = nil;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:path error: &error];
    if (dictionary) {
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue] / 1024 / 1024;
    }
    else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return totalFreeSpace;
}

//获取某文件的大小
- (uint64_t)getFileSizeFromPath:(NSString *)filePath {
    if (!filePath) {
        return 0;
    }
    uint64_t fileSize = 0;
    const char *cPath = [filePath UTF8String];
    FILE *file = fopen(cPath, "r");
    if (file > 0) {
        fseek(file, 0, SEEK_END);
        fileSize = ftell(file);
        fseek(file, 0, SEEK_SET);
        fclose(file);
    }
    return fileSize;
}

//计算当前已下载文件的大小
- (void)caculateDownloadFileSize {
    uint64_t fileSize = [self getFileSizeFromPath:self.downloadFilePath];
    self.downloadFileSize = fileSize;
}

@end


