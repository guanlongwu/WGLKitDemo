//
//  WK_WebToJS_VC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/7/8.
//  Copyright © 2019 huya. All rights reserved.
//

#import "WK_WebToJS_VC.h"
#import "NSArray+Safe.h"
#import "UIView+Extensions.h"
#import <WebKit/WebKit.h>

@interface WK_WebToJS_VC ()
@property (strong, nonatomic) WKWebView *myWeb;
@property (strong, nonatomic) NSString *someString;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@end

@implementation WK_WebToJS_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"WKWebView调用JS";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.someString = @"iOS 8引入了一个新的框架——WebKit，之后变得好起来了。在WebKit框架中，有WKWebView可以替换UIKit的UIWebView和AppKit的WebView，而且提供了在两个平台可以一致使用的接口。WebKit框架使得开发者可以在原生App中使用Nitro来提高网页的性能和表现，Nitro就是Safari的JavaScript引擎 WKWebView 不支持JavaScriptCore的方式但提供message handler的方式为JavaScript与Native通信";
    
    [self setupUI];
}

- (void)setupUI {
    
    CGFloat width = 80;
    CGFloat height = 50;
    for (int row = 0; row < 2; row++) {
        for (int column = 0; column < 4; column++) {
            CGFloat originX = 10 + column * (width + 10);
            CGFloat originY = 80 + row * (height + 30);
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
            btn.backgroundColor = [UIColor grayColor];
            [btn setTintColor:[UIColor whiteColor]];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [self.view addSubview:btn];
            [btn addTarget:self action:@selector(c_click:) forControlEvents:UIControlEventTouchUpInside];
            
            NSInteger idx = 4 * row + column;
            btn.tag = idx;
            NSString *title = [self.titles safeObjectAtIndex:idx];
            [btn setTitle:title ?: @"..." forState:UIControlStateNormal];
        }
    }
    
    [self.view addSubview:self.myWeb];
    [self loadHtml:@"WK_WebToJS"];
}

- (WKWebView *)myWeb {
    if (!_myWeb) {
        _myWeb = [[WKWebView alloc] initWithFrame:CGRectMake(0, 250, self.view.width, self.view.height - 250) configuration:[[WKWebViewConfiguration alloc] init]];
        _myWeb.UIDelegate = (id<WKUIDelegate>)self;
        _myWeb.backgroundColor = [UIColor redColor];
    }
    return _myWeb;
}

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles =
        [@[
           @"insertHTML_byTagName", @"insertHTML_byId", @"insertJS",
           @"iOS_call_jsFunc", @"changeInputElementValue", @"replaceImgSrc",
           @"reload",
           ] mutableCopy];
    }
    return _titles;
}

#pragma mark - Action

- (void)c_click:(UIButton *)sender {
    NSInteger idx = sender.tag;
    
    NSString *selString = [self.titles safeObjectAtIndex:idx];
    SEL selector = NSSelectorFromString(selString);
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:nil];
    }
}

//插入HTML（getElementsByTagName 根据html自带标签定位元素）
- (void)insertHTML_byTagName {
    
    //插入整个页面内容
    // document.getElementsByTagName('body')[0];"
    
    //替换第一个P元素内容
    NSString *tempString = [NSString stringWithFormat:@"document.getElementsByTagName('p')[0].innerHTML ='%@';", self.someString];
    [self.myWeb evaluateJavaScript:tempString completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
}

//插入HTML（根据getElementById 定位元素）
- (void)insertHTML_byId {
    //替换第id为idtest的DIV元素内容
    NSString *tempString2 = [NSString stringWithFormat:@"document.getElementById('idTest').innerHTML ='%@';",self.someString];
    [self.myWeb evaluateJavaScript:tempString2 completionHandler:^(id item, NSError * _Nullable error) {

    }];
}

//插入JS
- (void)insertJS {
    NSString *insertString =
    [NSString stringWithFormat:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function jsFunc() { "
     "var a=document.getElementsByTagName('body')[0];"
     "alert('%@');"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);", self.someString];
    
    [self.myWeb evaluateJavaScript:insertString completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
    [self.myWeb evaluateJavaScript:@"jsFunc();" completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
}

//iOS调用js方法
- (void)iOS_call_jsFunc {
    [self.myWeb evaluateJavaScript:@"showAlert(\"showAlert\");" completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
}

//修改input的值
- (void)changeInputElementValue {
    NSString *tempString = [NSString stringWithFormat:@"document.getElementsByName('wd')[0].value='%@';", self.someString];
    [self.myWeb evaluateJavaScript:tempString completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
}

//替换图片地址
- (void)replaceImgSrc {
    NSString *tempString2 = [NSString stringWithFormat:@"document.getElementsByTagName('img')[0].src ='%@';",@"light_advice.png"];
    [self.myWeb evaluateJavaScript:tempString2 completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
}

//刷新
- (void)reload {
    [self loadHtml:@"WK_WebToJS"];
}

#pragma mark - WKUIDelegate

- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

//uiwebview 中这个方法是私有方法 通过category可以拦截alert
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    
//    NSLog(@"%s", __FUNCTION__);
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }]];
//    
//    [self presentViewController:alert animated:YES completion:NULL];
//}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    
    NSLog(@"%s", __FUNCTION__);
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

    
@end
