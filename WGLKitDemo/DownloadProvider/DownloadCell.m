//
//  DownloadCell.m
//  WGLKitDemo
//
//  Created by wugl on 2019/2/18.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "DownloadCell.h"
#import "WGLCircleProgressView.h"
#import "WGLDownloadProvider.h"
#import "WGLFileCache.h"
#import "WGLNetworkMonitor.h"
#import "UIView+Extensions.h"

@interface DownloadCell ()
@property (nonatomic, strong) WGLDownloadProvider *downloadProvider;
@property (nonatomic, strong) WGLCircleProgressView *progressView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIButton *startBtn;
@end

@implementation DownloadCell

- (void)dealloc {
    NSLog(@"");
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.nameL];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.progressLabel];
        [self.contentView addSubview:self.startBtn];
        
        NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dir = paths[0];
        NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:dir];
        NSString *path = nil;
        while ((path = [fileEnumerator nextObject]) != nil) {
            NSLog(@"\n == %@ \n", path);
        }
        NSLog(@"");
    }
    return self;
}


//获取磁盘缓存中的文件数量。
- (NSUInteger)getDiskCount {
    __block NSUInteger count = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:[self getDefaultCacheDirectory]];
    count = fileEnumerator.allObjects.count;
    return count;
}

- (NSString *)getDefaultCacheDirectory {
    NSString *dir = [self getCacheDirectoryByAppendingPath:[NSString stringWithFormat:@"%@", @"defaultNameForWGLFileCache"]];
    return dir;
}

- (NSString *)getCacheDirectoryByAppendingPath:(NSString *)subPath {
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths[0] stringByAppendingPathComponent:subPath];
    return dir;
}


- (WGLDownloadProvider *)downloadProvider {
    if (!_downloadProvider) {
        _downloadProvider = [[WGLDownloadProvider alloc] init];
        _downloadProvider.delegate = (id<WGLDownloadProviderDelegate>)self;
        _downloadProvider.dataSource = (id<WGLDownloadProviderDataSource>)self;
    }
    return _downloadProvider;
}

- (UILabel *)nameL {
    if (!_nameL) {
        _nameL = [[UILabel alloc] init];
        _nameL.textAlignment = NSTextAlignmentLeft;
        _nameL.font = [UIFont systemFontOfSize:16];
        _nameL.textColor = [UIColor redColor];
    }
    return _nameL;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [[UIButton alloc] init];
        [_startBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _startBtn.backgroundColor = [UIColor grayColor];
        [_startBtn setTitle:@"下载" forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(n_download) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (WGLCircleProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[WGLCircleProgressView alloc] initWithFrame:self.bounds];
        _progressView.circleLineColor = [UIColor grayColor];
        _progressView.circleLineWidth = 1.5;
        _progressView.userInteractionEnabled = NO;
    }
    return _progressView;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textAlignment = NSTextAlignmentLeft;
        _progressLabel.font = [UIFont systemFontOfSize:13];
        _progressLabel.textColor = [UIColor redColor];
    }
    return _progressLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 0, 50, 50);
    self.progressView.frame = CGRectMake(self.progressLabel.left-50, 0, 50, 50);
    self.startBtn.frame = CGRectMake(self.progressView.left-50, 0, 50, 50);
    self.nameL.frame = CGRectMake(20, 0, self.startBtn.left-20, self.contentView.frame.size.height);
}

//下载进度值
- (void)setProgress:(CGFloat)progress {
    //下载中状态，则显示现在进度
    self.progressView.progress = progress;
}

#pragma mark - event

- (void)n_download {
    WGLDownloadState state = [self.downloadProvider downloadStateForURL:self.url];
    if (state == WGLDownloadStateDownloading) {
        //暂停下载
        
        //判断网络是否可用
        if (NO == [WGLNetworkMonitor sharedMonitor].isReachable) {
            self.progressLabel.text = @"无网";
            return;
        }
        [self.downloadProvider cancelDownloadURL:self.url];
        
    }
    else {
        //开始下载
        BOOL exist = [[WGLFileCache sharedCache] cacheExistForURLString:self.url];
        if (exist) {
            //有缓存，则取缓存
            self.progressView.progress = 100;
            self.progressLabel.text = @"完成";
        }
        else {
            //判断网络是否可用
            if (NO == [WGLNetworkMonitor sharedMonitor].isReachable) {
                self.progressLabel.text = @"无网";
                return;
            }
            self.progressLabel.text = @"等待下载";
            [self.downloadProvider downloadWithURL:self.url];
        }
    }
}

#pragma mark - WGLDownloadProviderDataSource / delegate

//是否已缓存
- (BOOL)downloadProvider:(WGLDownloadProvider *)dlProvider existCache:(NSString *)urlString {
    BOOL exist = [[WGLFileCache sharedCache] cacheExistForURLString:urlString];
    return exist;
}

//文件下载的存放目录
- (NSString *)downloadProvider:(WGLDownloadProvider *)dlProvider getDirectory:(NSString *)urlString {
    NSString *dir = [[WGLFileCache sharedCache] getDefaultCacheDirectory];
    return dir;
}

//文件缓存的唯一key
- (NSString *)downloadProvider:(WGLDownloadProvider *)dlProvider cacheFileName:(NSString *)urlString {
    NSString *cacheName = [[WGLFileCache sharedCache] cacheFileNameForURLString:urlString];
    return cacheName;
}

//下载开始
- (void)downloadDidStart:(WGLDownloadProvider *)dlProvider urlString:(NSString *)urlString {
    if ([self.url isEqualToString:urlString]) {
        
    }
}

//下载中
- (void)downloader:(WGLDownloadProvider *)dlProvider urlString:(NSString *)urlString didReceiveLength:(uint64_t)receiveLength totalLength:(uint64_t)totalLength {
    if ([self.url isEqualToString:urlString]) {
        int progress = (int)(receiveLength * 100 / totalLength);
        self.progressView.progress = progress;
        self.progressLabel.text = [NSString stringWithFormat:@"%d%%", progress];
    }
}

//下载成功
- (void)downloadDidFinish:(WGLDownloadProvider *)dlProvider urlString:(NSString *)urlString filePath:(NSString *)filePath {
    if ([self.url isEqualToString:urlString]) {
        self.progressLabel.text = @"完成";
    }
}

//下载失败
- (void)downloadDidFail:(WGLDownloadProvider *)dlProvider urlString:(NSString *)urlString errorType:(WGLDownloadErrorType)errorType {
    if ([self.url isEqualToString:urlString]) {
        NSString *errorMsg = @"";
        switch (errorType) {
            case WGLDownloadErrorTypeHTTPError:
                errorMsg = @"HTTP请求出错";
                break;
            case WGLDownloadErrorTypeInvalidURL:
                errorMsg = @"URL不合法";
                break;
            case WGLDownloadErrorTypeInvalidRequestRange:
                errorMsg = @"下载范围不对";
                break;
            case WGLDownloadErrorTypeInvalidDirectory:
                errorMsg = @"下载目录出错";
                break;
            case WGLDownloadErrorTypeNotEnoughFreeSpace:
                errorMsg = @"磁盘空间不足";
                break;
            case WGLDownloadErrorTypeCacheInDiskError:
                errorMsg = @"下载成功缓存失败";
                break;
            default:
                break;
        }
        NSLog(@"error msg : %@", errorMsg);
        self.progressLabel.text = errorMsg;
    }
}

@end
