//
//  M3U8VC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/3/27.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "M3U8VC.h"
#import "UIView+Extensions.h"
#import "UIControl+Block.h"
#import "UIColor+Convertor.h"
#import "WGLCircleProgressView.h"
#import "WGLM3U8Processing.h"

static NSString *const _m3u8URL = @"https://dco4urblvsasc.cloudfront.net/811/81095_ywfZjAuP/game/1000kbps.m3u8";

@interface M3U8VC ()
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UITextView *m3u8URLView, *mp4URLView;
@property (nonatomic, strong) WGLCircleProgressView *progressView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIButton *clickBtn;
@end

@implementation M3U8VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"m3u8转码mp4";
    
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.m3u8URLView];
    [self.view addSubview:self.mp4URLView];
    [self.view addSubview:self.progressView];
    [self.progressView addSubview:self.progressLabel];
    
    [self.view addSubview:self.clickBtn];
    
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.width, 50)];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor blackColor];
    }
    return _tipLabel;
}

- (UITextView *)m3u8URLView {
    if (!_m3u8URLView) {
        _m3u8URLView = [[UITextView alloc] initWithFrame:CGRectMake(20, 150, self.view.width - 40, 100)];
        _m3u8URLView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _m3u8URLView.text = _m3u8URL;
        _m3u8URLView.font = [UIFont systemFontOfSize:18];
    }
    return _m3u8URLView;
}

- (UITextView *)mp4URLView {
    if (!_mp4URLView) {
        _mp4URLView = [[UITextView alloc] initWithFrame:CGRectMake(20, 300, self.view.width - 40, 100)];
        _mp4URLView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _mp4URLView.font = [UIFont systemFontOfSize:18];
    }
    return _mp4URLView;
}

- (WGLCircleProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[WGLCircleProgressView alloc] initWithFrame:CGRectMake(50, 450, 80, 80)];
        _progressView.circleLineColor = [UIColor colorWithHexString:@"f2f2f2"];
        _progressView.circleLineWidth = 1.5;
        _progressView.userInteractionEnabled = NO;
    }
    return _progressView;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [self.view addSubview:label];
        label.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        _progressLabel = label;
    }
    return _progressLabel;
}

#pragma mark - 点击转码

- (UIButton *)clickBtn {
    if (!_clickBtn) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 450, 100, 50)];
        btn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [btn setTitle:@"转码" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        __weak typeof(self) weakSelf = self;
        [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            
            [[WGLM3U8Processing sharedProcessing] m3u8ToMp4WithUrl:_m3u8URL downloadProgress:^(WGLM3U8Processing *processing, NSString *m3u8Url, float process) {
                weakSelf.tipLabel.text = @"下载中...";
                weakSelf.progressView.progress = process;
                weakSelf.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(process * 100)];
                
            } progress:^(WGLM3U8Processing *processing, NSString *m3u8Url, float process) {
                weakSelf.tipLabel.text = @"转码中...";
                weakSelf.progressView.progress = process;
                weakSelf.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(process * 100)];
                
            } success:^(WGLM3U8Processing *processing, NSString *m3u8Url, NSString *mp4FilePath) {
                weakSelf.mp4URLView.text = mp4FilePath;
            } failure:^(WGLM3U8Processing *processing, NSString *m3u8Url) {
                
            }];
        }];
        _clickBtn = btn;
    }
    return _clickBtn;
}




@end
