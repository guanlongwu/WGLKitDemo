//
//  WK_JSToWeb_VC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/7/8.
//  Copyright © 2019 huya. All rights reserved.
//

#import "WK_JSToWeb_VC.h"
#import "NSArray+Safe.h"
#import "UIView+Extensions.h"
#import "UIControl+Block.h"
#import <WebKit/WebKit.h>

@interface WK_JSToWeb_VC () <WKUIDelegate, WKScriptMessageHandler>
@property (strong, nonatomic) WKWebView *myWeb;
@property (strong, nonatomic) NSString *someString;
@property (strong, nonatomic) UIButton *insertJSBtn;
@end

@implementation WK_JSToWeb_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"JS调用WKWebView";
    
    self.someString = @"iOS 8引入了一个新的框架——WebKit，之后变得好起来了。在WebKit框架中，有WKWebView可以替换UIKit的UIWebView和AppKit的WebView，而且提供了在两个平台可以一致使用的接口。WebKit框架使得开发者可以在原生App中使用Nitro来提高网页的性能和表现，Nitro就是Safari的JavaScript引擎 WKWebView 不支持JavaScriptCore的方式但提供message handler的方式为JavaScript与Native通信";
    
    [self setupUI];
}

- (void)setupUI {
    
    [self.view addSubview:self.myWeb];
    [self.view addSubview:self.insertJSBtn];
    [self loadHtml:@"WK_JSToWeb"];
}

- (WKWebView *)myWeb {
    if (!_myWeb) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];
        
        _myWeb = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) configuration:config];
        _myWeb.UIDelegate = (id<WKUIDelegate>)self;
        _myWeb.backgroundColor = [UIColor redColor];
    }
    return _myWeb;
}

- (UIButton *)insertJSBtn {
    if (!_insertJSBtn) {
        _insertJSBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 100, 100)];
        [_insertJSBtn setTitle:@"注入JS" forState:UIControlStateNormal];
        [_insertJSBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_insertJSBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSString *insertString =
            [NSString stringWithFormat:
             @"var script = document.createElement('script');"
             "script.type = 'text/javascript';"
             "script.text = \"function jsFunc() { "
             "callMobile('MyApp','MyFunc','MyParams');"
             "}\";"
             "document.getElementsByTagName('head')[0].appendChild(script);"];
            [strongSelf.myWeb evaluateJavaScript:insertString completionHandler:^(id item, NSError * _Nullable error) {
                NSLog(@"");
            }];
            [strongSelf.myWeb evaluateJavaScript:@"jsFunc()" completionHandler:^(id item, NSError * _Nullable error) {
                NSLog(@"");
            }];
        }];
    }
    return _insertJSBtn;
}

#pragma mark - 内存释放

- (void)dealloc {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.myWeb.configuration.userContentController removeScriptMessageHandlerForName:@"Native"];
    [self.myWeb.configuration.userContentController removeScriptMessageHandlerForName:@"Pay"];
    [self.myWeb.configuration.userContentController removeScriptMessageHandlerForName:@"MyApp"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /**
     addScriptMessageHandler 很容易导致循环引用.
     1、控制器 强引用了WKWebView,WKWebView copy(强引用了）configuration，
     2、configuration copy （强引用了）userContentController.
     3、userContentController 强引用了 self （控制器）
     */
    /**
     声明WKScriptMessageHandler 协议
     - addScriptMessageHandler:name:有两个参数，
     第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象
     */
    
    //注入JS对象
    [self.myWeb.configuration.userContentController addScriptMessageHandler:self name:@"Native"];
    [self.myWeb.configuration.userContentController addScriptMessageHandler:self name:@"Pay"];
    [self.myWeb.configuration.userContentController addScriptMessageHandler:self name:@"MyApp"];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSDictionary *bodyParam = (NSDictionary*)message.body;
    NSString *func = [bodyParam objectForKey:@"function"];
    NSDictionary *params = [bodyParam objectForKey:@"parameters"];
    
    NSLog(@"MessageHandler Name:%@", message.name);
    NSLog(@"MessageHandler Body:%@", message.body);
    NSLog(@"MessageHandler Function:%@",func);
    
    //本人喜欢只定义一个MessageHandler协议 当然可以定义其他MessageHandler协议
    
    if ([message.name isEqualToString:@"Native"]) {
        NSDictionary *parameters = [bodyParam objectForKey:@"parameters"];
        //调用本地函数1
        if([func isEqualToString:@"addSubView"]) {
            Class tempClass =  NSClassFromString([parameters objectForKey:@"view"]);
            CGRect frame = CGRectFromString([parameters objectForKey:@"frame"]);
            
            if(tempClass && [tempClass isSubclassOfClass:[UIWebView class]]) {
                UIWebView *tempObj = [[tempClass alloc] initWithFrame:frame];
                tempObj.tag = [[parameters objectForKey:@"tag"] integerValue];
                
                NSURL *url = [NSURL URLWithString:[parameters objectForKey:@"urlstring"]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [tempObj loadRequest:request];
                [self.myWeb addSubview:tempObj];
            }
        }
        //调用本地函数2
        else if([func isEqualToString:@"alert"]) {
            [self showMessage:@"来自网页的提示" message:[parameters description]];
        }
        //调用本地函数3
        else if([func isEqualToString:@"callFunc"]) {
            [self.myWeb evaluateJavaScript:@"callMobile('Native', 'testFunc', 'wugl')" completionHandler:^(id item, NSError * _Nullable error) {
                
            }];
        }
        //调用本地函数4
        else if([func isEqualToString:@"testFunc"]) {
            NSLog(@"params : %@", parameters);
        }
    }
    else if ([message.name isEqualToString:@"Pay"]) {
        //如果是自己定义的协议, 再截取协议中的方法和参数, 判断无误后在这里进行逻辑处理
        NSLog(@"params : %@", params);
    }
    else if ([message.name isEqualToString:@"dosomething"]) {
        //........
    }
    else if ([message.name isEqualToString:@"MyApp"]) {
        if([func isEqualToString:@"MyFunc"]) {
            [self showMessage:@"注入JS" message:params.description];
        }
    }
}

#pragma mark - WKUIDelegate

- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

//uiwebview 中这个方法是私有方法 通过category可以拦截alert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    NSLog(@"%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - private

-(void)loadHtml:(NSString *)name {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];
    if (filePath) {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.myWeb loadRequest:request];
    }
}

-(void)showMessage:(NSString *)title message:(NSString *)message {
    if (message == nil) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:[message description]
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

@end



/**
 总结：
 
 使用WKNavigationDelegate中的代理方法，拦截自定义的 URL 来实现 JS 调用 OC 方法。
 
 如果实现了这个代理方法，就必须得调用decisionHandler这个 block，否则会导致 app 奔溃。
 block参数是一个枚举值，WKNavigationActionPolicyCancel代表取消加载，
 相当于UIWebView的代理方法return NO的情况；
 WKNavigationActionPolicyAllow代表允许加载，相当于UIWebView的代理方法中 return YES的情况。
 
 注意：
 如果在WKWebView中使用alert、confirm 等弹窗，就得实现WKWebView的WKUIDelegate中相应的代理方法，
 否则alert 并不会弹出。
 
 - addScriptMessageHandler:name:有两个参数，
 第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象。
 所以要使用MessageHandler功能，就必须要实现WKScriptMessageHandler协议。
 
 使用MessageHandler的好处：
 在JS中写起来简单，不用再用创建URL的方式那么麻烦了。
 
 */

