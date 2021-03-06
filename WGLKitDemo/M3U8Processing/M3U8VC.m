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

static NSString *const _m3u8URL = @"http://v-replay.cdn.huya.com/record/huyalive/1447023449-1447023449-6214918390000123904-100281904-10060-A-0-1_2000/2019-05-30-18:12:00_2019-05-30-18:18:34_v.m3u8";//@"https://dco4urblvsasc.cloudfront.net/811/81095_ywfZjAuP/game/1000kbps.m3u8";

@interface M3U8VC ()
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UITextView *m3u8URLView, *compURLView, *mp4URLView;
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
    [self.view addSubview:self.progressView];
    [self.progressView addSubview:self.progressLabel];
    [self.view addSubview:self.clickBtn];
    
    [self.view addSubview:self.m3u8URLView];
    [self.view addSubview:self.compURLView];
    [self.view addSubview:self.mp4URLView];
    
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.width, 50)];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor redColor];
        _tipLabel.font = [UIFont systemFontOfSize:24];
        _tipLabel.text = @"准备中...";
    }
    return _tipLabel;
}

- (WGLCircleProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[WGLCircleProgressView alloc] initWithFrame:CGRectMake((self.view.width - 80) / 2, 150, 80, 80)];
        _progressView.circleLineColor = [UIColor colorWithHexString:@"0xff0000"];
        _progressView.circleLineWidth = 1.5;
        _progressView.userInteractionEnabled = NO;
    }
    return _progressView;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [self.view addSubview:label];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        _progressLabel = label;
    }
    return _progressLabel;
}

- (UITextView *)m3u8URLView {
    if (!_m3u8URLView) {
        _m3u8URLView = [[UITextView alloc] initWithFrame:CGRectMake(20, 320, self.view.width - 40, 80)];
        _m3u8URLView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _m3u8URLView.text = _m3u8URL;
        _m3u8URLView.font = [UIFont systemFontOfSize:15];
        _m3u8URLView.clipsToBounds = YES;
        _m3u8URLView.layer.cornerRadius = 20;
    }
    return _m3u8URLView;
}

- (UITextView *)compURLView {
    if (!_compURLView) {
        _compURLView = [[UITextView alloc] initWithFrame:CGRectMake(20, 420, self.view.width - 40, 100)];
        _compURLView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _compURLView.font = [UIFont systemFontOfSize:15];
        _compURLView.clipsToBounds = YES;
        _compURLView.layer.cornerRadius = 20;
    }
    return _compURLView;
}

- (UITextView *)mp4URLView {
    if (!_mp4URLView) {
        _mp4URLView = [[UITextView alloc] initWithFrame:CGRectMake(20, 540, self.view.width - 40, 100)];
        _mp4URLView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _mp4URLView.font = [UIFont systemFontOfSize:15];
        _mp4URLView.clipsToBounds = YES;
        _mp4URLView.layer.cornerRadius = 20;
    }
    return _mp4URLView;
}

#pragma mark - 点击转码

- (UIButton *)clickBtn {
    if (!_clickBtn) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width - 100) / 2, 250, 100, 50)];
        btn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        btn.layer.cornerRadius = 10;
        btn.clipsToBounds = YES;
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
                
            } success:^(WGLM3U8Processing *processing, NSString *m3u8Url, NSString *compositeTsFilePath, NSString *mp4FilePath) {
                weakSelf.tipLabel.text = @"转码完成";
                weakSelf.progressView.progress = 1.0;
                weakSelf.progressLabel.text = [NSString stringWithFormat:@"100%%"];
                weakSelf.compURLView.text = compositeTsFilePath;
                weakSelf.mp4URLView.text = mp4FilePath;
            } failure:^(WGLM3U8Processing *processing, NSString *m3u8Url) {
                
            }];
        }];
        _clickBtn = btn;
    }
    return _clickBtn;
}


@end
