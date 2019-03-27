//
//  M3U8VC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/3/27.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "M3U8VC.h"
#import "WGLM3U8Processing.h"

@interface M3U8VC ()
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UILabel *label;
@end

@implementation M3U8VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"视频转码";
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 80)];
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"m3u8ToMp4" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:self
            action:@selector(n_click)
  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(100, 300, 200, 80)];
    progressView.progressTintColor = [UIColor greenColor];
    progressView.tintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(100, 400, 200, 80)];
    [self.view addSubview:self.label];
    self.label.backgroundColor = [UIColor grayColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:20];
    self.label.textAlignment = NSTextAlignmentCenter;
    
}

- (void)n_click {
    NSString *m3u8url = @"https://dco4urblvsasc.cloudfront.net/811/81095_ywfZjAuP/game/1000kbps.m3u8";
    [[WGLM3U8Processing sharedProcessing] m3u8ToMp4WithUrl:m3u8url progress:^(WGLM3U8Processing *processing, NSString *m3u8Url, float process) {
        
        self.progressView.progress = process;
        self.label.text = [NSString stringWithFormat:@"%d%%", (int)(process * 100)];
        
    } success:^(WGLM3U8Processing *processing, NSString *m3u8Url, NSString *mp4FilePath) {
        
    } failure:^(WGLM3U8Processing *processing, NSString *m3u8Url) {
        
    }];
}




@end
