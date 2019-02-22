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
    }
    return self;
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
    self.nameL.frame = CGRectMake(20, 0, 140, self.contentView.frame.size.height);
    self.startBtn.frame = CGRectMake(160, 0, 50, 50);
    
    self.progressView.frame = CGRectMake(220, 0, 50, 50);
    self.progressLabel.frame = CGRectMake(280, 0, 200, 50);
}

//下载进度值
- (void)setProgress:(CGFloat)progress {
    //下载中状态，则显示现在进度
    self.progressView.progress = progress;
}

#pragma mark - event

- (void)n_download {
    BOOL exist = [[WGLFileCache sharedCache] cacheExistForURLString:self.url];
    if (exist) {
        self.progressView.progress = 100;
        self.progressLabel.text = @"完成";
    }
    else {
        [self.downloadProvider downloadWithURL:self.url];
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
