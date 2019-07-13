//
//  WK_WVJB_VC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/7/13.
//  Copyright © 2019 huya. All rights reserved.
//

#import "WK_WVJB_VC.h"
#import "UIView+Extensions.h"
#import "UIControl+Block.h"
#import <WebKit/WebKit.h>
#import <WKWebViewJavascriptBridge.h>

@interface WK_WVJB_VC () <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *myWeb;
@property (nonatomic, strong) WKWebViewJavascriptBridge *webViewBridge;
@property (strong, nonatomic) UIButton *callJSFuncBtn;
@property (strong, nonatomic) UIProgressView *progressView;
@end

@implementation WK_WVJB_VC

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"WK_WebViewJavaScriptBridge";
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setupUI];
    
    [self registerNativeFunctions];
    
    [self addObserver];
}

- (void)setupUI {
    [self.view addSubview:self.myWeb];
    [self loadHtml:@"index"];
    
    self.webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.myWeb];
    [self.webViewBridge setWebViewDelegate:self];
    
    [self.view addSubview:self.callJSFuncBtn];
    [self.view addSubview:self.progressView];
}

- (WKWebView *)myWeb {
    if (!_myWeb) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 30.0;
        configuration.preferences = preferences;
        
        _myWeb = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _myWeb.UIDelegate = self;
        
        // UIWebView 滚动的比较慢，这里设置为正常速度
        _myWeb.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _myWeb.backgroundColor = [UIColor redColor];
    }
    return _myWeb;
}

- (UIButton *)callJSFuncBtn {
    if (!_callJSFuncBtn) {
        _callJSFuncBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 350, 100, 60)];
        _callJSFuncBtn.backgroundColor = [UIColor grayColor];
        [_callJSFuncBtn setTitle:@"OC调用JS" forState:UIControlStateNormal];
        [_callJSFuncBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_callJSFuncBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf callJSFunc];
        }];
    }
    return _callJSFuncBtn;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
        _progressView.tintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor lightGrayColor];
    }
    return _progressView;
}

#pragma mark - OC调用JS

- (void)callJSFunc {
    [self.webViewBridge callHandler:@"testJSFunction" data:@"这是一个字符串" responseCallback:^(id responseData) {
        NSLog(@"调用完JS后的回调：%@",responseData);
    }];
}

#pragma mark - 监听

- (void)addObserver {
    [self.myWeb addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 注册原生方法（JS调用OC）

- (void)registerNativeFunctions {
    [self registShareFunction];
    
    [self registLocationFunction];
    
    [self registPayFunction];
}

- (void)registShareFunction {
    [self.webViewBridge registerHandler:@"shareClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        // data 的类型与 JS中传的参数有关
        NSDictionary *tempDic = data;
        // 在这里执行分享的操作
        NSString *title = [tempDic objectForKey:@"title"];
        NSString *content = [tempDic objectForKey:@"content"];
        NSString *url = [tempDic objectForKey:@"url"];
        NSLog(@"JS 传递给 OC 的参数:%@",[NSString stringWithFormat:@"分享成功:%@,%@,%@",title,content,url]);
        
        // 将分享的结果返回到JS中
        NSString *result = [NSString stringWithFormat:@"分享成功:%@,%@,%@",title,content,url];
        responseCallback(result);
    }];
}

- (void)registLocationFunction {
    [self.webViewBridge registerHandler:@"locationClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 获取位置信息
        
        // 将结果返回给 JS
        NSString *location = @"广东省广州市白云区豪泉大厦";
        responseCallback(location);
    }];
}

- (void)registPayFunction {
    [self.webViewBridge registerHandler:@"payClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        // data 的类型与 JS中传的参数有关
        NSDictionary *tempDic = data;
        
        NSString *orderNo = [tempDic objectForKey:@"order_no"];
        long long amount = [[tempDic objectForKey:@"amount"] longLongValue];
        NSString *subject = [tempDic objectForKey:@"subject"];
        NSString *channel = [tempDic objectForKey:@"channel"];
        // 支付操作...
        NSLog(@"支付操作:%@", [NSString stringWithFormat:@"支付成功:%@,%@,%@,%lld",orderNo,subject,channel,amount]);
        
        // 将分享的结果返回到JS中
        NSString *result = [NSString stringWithFormat:@"支付成功:%@,%@,%@",orderNo,subject,channel];
        responseCallback(result);
    }];
}

#pragma mark - KVO

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.myWeb && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
        } else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}


#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - private

-(void)loadHtml:(NSString*)name{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];
    if (filePath) {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.myWeb loadRequest:request];
    }
}


@end
