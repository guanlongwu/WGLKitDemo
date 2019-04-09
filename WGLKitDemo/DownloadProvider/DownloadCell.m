//
//  DownloadCell.m
//  WGLKitDemo
//
//  Created by wugl on 2019/2/18.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "DownloadCell.h"
#import "UIView+Extensions.h"
#import "UIControl+Block.h"

@interface DownloadCell ()
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
        [self.progressView addSubview:self.progressLabel];
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
        __weak typeof(self) weakSelf = self;
        [_startBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            if (weakSelf.clickHandler) {
                weakSelf.clickHandler(weakSelf, weakSelf.url);
            }
        }];
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
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:13];
        _progressLabel.textColor = [UIColor redColor];
    }
    return _progressLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100, 0, 50, 50);
    self.progressLabel.frame = self.progressView.bounds;
    self.startBtn.frame = CGRectMake(self.progressView.left-50, 0, 50, 50);
    self.nameL.frame = CGRectMake(20, 0, self.startBtn.left-20, self.contentView.frame.size.height);
}

//下载进度值
- (void)setProgress:(CGFloat)progress {
    //下载中状态，则显示现在进度
    self.progressView.progress = progress;
}

#pragma mark - deprecated method

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


@end
