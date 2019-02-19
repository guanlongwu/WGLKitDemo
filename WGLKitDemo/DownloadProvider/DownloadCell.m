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

@interface DownloadCell ()
@property (nonatomic, strong) WGLCircleProgressView *progressView;
@property (nonatomic, strong) WGLDownloadProvider *downloadProvider;
@property (nonatomic, strong) UIButton *startBtn;
@end

@implementation DownloadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.nameL];
        [self.contentView addSubview:self.progressView];
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
        _startBtn.titleLabel.text = @"下载";
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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameL.frame = CGRectMake(20, 0, 200, self.contentView.frame.size.height);
    self.progressView.frame = CGRectMake(self.contentView.frame.size.width - 80 - 20, 0, 80, 80);
    
    self.startBtn.frame = CGRectMake(200, 0, 80, 80);
}

//下载进度值
- (void)setProgress:(CGFloat)progress {
    //下载中状态，则显示现在进度
    self.progressView.progress = progress;
}

#pragma mark - event

- (void)n_download {
    [self.downloadProvider downloadWithURL:self.url];
}

#pragma mark - WGLDownloadProviderDataSource / delegate

- (BOOL)downloadProvider:(WGLDownloadProvider *)dlProvider existCache:(NSString *)urlString {
    return NO;
}

//下载开始
- (void)downloadDidStart:(WGLDownloadProvider *)dlProvider urlString:(NSString *)urlString {
    if ([self.url isEqualToString:urlString]) {
        
    }
}

//下载中
- (void)downloader:(WGLDownloadProvider *)dlProvider urlString:(NSString *)urlString didReceiveLength:(uint64_t)receiveLength totalLength:(uint64_t)totalLength {
    if ([self.url isEqualToString:urlString]) {
        
    }
}

//下载成功
- (void)downloadDidFinish:(WGLDownloadProvider *)dlProvider urlString:(NSString *)urlString filePath:(NSString *)filePath {
    if ([self.url isEqualToString:urlString]) {
        
    }
}

//下载失败
- (void)downloadDidFail:(WGLDownloadProvider *)dlProvider urlString:(NSString *)urlString errorType:(WGLDownloadErrorType)errorType {
    if ([self.url isEqualToString:urlString]) {
        
    }
}

@end
