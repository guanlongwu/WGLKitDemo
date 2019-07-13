//
//  UI_WVJB_VC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/7/13.
//  Copyright © 2019 huya. All rights reserved.
//

#import "UI_WVJB_VC.h"
#import "UIView+Extensions.h"
#import "UIControl+Block.h"
#import <WebViewJavascriptBridge.h>

@interface UI_WVJB_VC ()
@property (nonatomic, strong) UIWebView *myWeb;
@property (nonatomic, strong) WebViewJavascriptBridge *webViewBridge;
@property (strong, nonatomic) UIButton *callJSFuncBtn;
@end

@implementation UI_WVJB_VC

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"UI_WebViewJavaScriptBridge";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupUI];
    
    [self registerNativeFunctions];
}

- (void)setupUI {
    [self.view addSubview:self.myWeb];
    [self loadHtml:@"index"];
    
    // WebViewJavascriptBridge
    self.webViewBridge = [WebViewJavascriptBridge bridgeForWebView:self.myWeb];
    [self.webViewBridge setWebViewDelegate:self];
    
    [self.view addSubview:self.callJSFuncBtn];
}

- (UIWebView *)myWeb {
    if (!_myWeb) {
        _myWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
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

#pragma mark - OC调用JS

- (void)callJSFunc {
    [self.webViewBridge callHandler:@"testJSFunction" data:@"这是一个字符串" responseCallback:^(id responseData) {
        NSLog(@"调用完JS后的回调：%@",responseData);
    }];
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

#pragma mark - private

/**
 第一步：
 HTML 中有一个必须要添加的JS 方法，然后需要自动调用一次该方法。
 该方法是：
 var WVJBIframe = document.createElement('iframe');
 WVJBIframe.style.display = 'none';
 WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
 document.documentElement.appendChild(WVJBIframe);
 
 目的是：
 加载一次wvjbscheme://__BRIDGE_LOADED__，
 来触发往HTML中注入一些已经写好的JS方法。
 */
-(void)loadHtml:(NSString*)name{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];
    if (filePath) {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.myWeb loadRequest:request];
    }
}


@end


/**
 总结：
 
 一、准备
 
 业务方的HTML 中有一个必须要添加的JS 方法，然后需要自动调用一次该方法。
 该方法是：
 var WVJBIframe = document.createElement('iframe');
 WVJBIframe.style.display = 'none';
 WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
 document.documentElement.appendChild(WVJBIframe);
 
 目的是：
 加载一次wvjbscheme://__BRIDGE_LOADED__，
 来触发往HTML中注入一些已经写好的JS方法。
 
 
 二、Native调用JS
 - callHandler
 
 Native需要调用的JS功能，也是需要先注册，然后再执行的。
 如果Native需要调用的JS功能有多个，那么这些功能都要在这里先注册，注册之后才能够被Native调用。
 1、业务方js先要注册一个方法A；
 2、业务方的方法A内部会调用WVJB_JS的registerHandler方法；
 3、该方法内部，会将业务方这个方法名handlerName和callback封装起来，这里形成一个形成键值对Key1（handlerName <-> callback），（block内部就是JS要执行的方法）
 4、当Native执行js的方法A时，会将方法名handlerName、参数data封装起来，形成键值对key2（handler <-> data）；
 5、然后webView通过stringByEvaluatingJavaScriptFromString将key2传递给js；
 6、在注入的js代码中，通过键值对Key1，可以由handlerName获取到callback（下面的handler）；
 var handler = messageHandlers[message.handlerName];
 7、最后执行callback（block内部就是JS要执行的方法）。
 
 
 三、JS调用Native
 - registerHandler
 
 第一个参数handlerName，是对这个功能起的一个别名。
 第二个参数handler，是一个block，也就是 Native 实现的功能。
 JS 要调用的 Native 实现其实就是 block 内{}内的代码功能。
 注意：
 handlerName必须是JS中已经定义好的方法！
 
 实现JS调用Native--流程：
 0、WVJB_JS这个被注入的js文件中，声明了一个callHandler方法（提供给业务方的js调用），
 业务方js声明的提供给Native注册的所有方法handlerName，其内部都会执行WVJB_JS的callHandler方法。
 同时Native中也要先注册这个方法handler，以及绑定这个方法执行的Native回调callback（block内部就是JS希望Native要执行的方法），这里形成一个键值对Key1(handlerName <-> callback)；
 1、调用业务方js的方法A；
 2、业务方的方法A内部会调用WVJB_JS的callHandler方法；
 3、该方法内部，会将业务方这个方法名handlerName和参数data封装起来，这里形成一个形成键值对Key2（handlerName <-> data），
 然后去执行iframe.src=URL；
 4、webView截获URL，再去执行注入的js方法WVJB._fetchQueue()
 （这一步会返回上面键值对对应的字符串string）；
 5、通过键值对Key1，可以由handlerName获取到callback；
 6、最后执行callback（block内部就是JS希望Native要执行的方法）。
 */
