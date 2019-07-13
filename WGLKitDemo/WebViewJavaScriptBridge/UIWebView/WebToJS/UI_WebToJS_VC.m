//
//  UI_WebToJS_VC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/7/8.
//  Copyright © 2019 huya. All rights reserved.
//

#import "UI_WebToJS_VC.h"
#import "NSArray+Safe.h"
#import "UIView+Extensions.h"

@interface UI_WebToJS_VC ()
@property (strong, nonatomic) UIWebView *myWeb;
@property (strong, nonatomic) NSString *someString;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@end

@implementation UI_WebToJS_VC

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"UIWebView调用JS";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.someString = @"UIWebView是iOS最常用的SDK之一，它有一个stringByEvaluatingJavaScriptFromString方法可以将javascript嵌入页面中，通过这个方法我们可以在iOS中与UIWebView中的网页元素交互";
    
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
    [self loadHtml:@"UI_WebToJS"];
}

- (UIWebView *)myWeb {
    if (!_myWeb) {
        _myWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 250, self.view.width, self.view.height - 250)];
        _myWeb.backgroundColor = [UIColor redColor];
    }
    return _myWeb;
}

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles =
        [@[
           @"insertHTML_byTagName", @"insertHTML_byId", @"insertJS_CallFunc",
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
    [self.myWeb stringByEvaluatingJavaScriptFromString:tempString];
}

//插入HTML（根据getElementById 定位元素）
- (void)insertHTML_byId {
    //替换第id为idtest的DIV元素内容
    NSString *tempString2 = [NSString stringWithFormat:@"document.getElementById('idTest').innerHTML ='%@';",self.someString];
    [self.myWeb stringByEvaluatingJavaScriptFromString:tempString2];
}

//插入JS
- (void)insertJS_CallFunc {
    NSString *insertString =
    [NSString stringWithFormat:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function jsFunc() { "
     "var a=document.getElementsByTagName('body')[0];"
     "alert('%@');"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);", self.someString];
    
//    NSLog(@"insert string : %@",insertString);
    [self.myWeb stringByEvaluatingJavaScriptFromString:insertString];
    [self.myWeb  stringByEvaluatingJavaScriptFromString:@"jsFunc();"];
}

//iOS调用js方法
- (void)iOS_call_jsFunc {
    //    [self.myWeb stringByEvaluatingJavaScriptFromString:@"showAlert(\"showAlert\");"];
    [self.myWeb stringByEvaluatingJavaScriptFromString:@"asyncAlert(\"asyncAlert\");"];
}

//修改input的值
- (void)changeInputElementValue {
    NSString *tempString = [NSString stringWithFormat:@"document.getElementsByName('wd')[0].value='%@';", self.someString];
    [self.myWeb stringByEvaluatingJavaScriptFromString:tempString];
}

//替换图片地址
- (void)replaceImgSrc {
    NSString *tempString2 = [NSString stringWithFormat:@"document.getElementsByTagName('img')[0].src ='%@';",@"light_advice.png"];
    [self.myWeb stringByEvaluatingJavaScriptFromString:tempString2];
}

//刷新
- (void)reload {
    [self loadHtml:@"UI_WebToJS"];
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
