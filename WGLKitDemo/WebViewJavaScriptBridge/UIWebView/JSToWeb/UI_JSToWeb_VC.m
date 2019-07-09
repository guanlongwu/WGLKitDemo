//
//  UI_JSToWeb_VC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/7/8.
//  Copyright © 2019 huya. All rights reserved.
//

#import "UI_JSToWeb_VC.h"
#import "NSArray+Safe.h"
#import "UIView+Extensions.h"

@interface UI_JSToWeb_VC ()
@property (strong, nonatomic) UIWebView *myWeb;
@property (strong, nonatomic) NSString *someString;
@end

@implementation UI_JSToWeb_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"JS调用UIWebView";
    
    self.someString = @"UIWebView是iOS最常用的SDK之一，它有一个stringByEvaluatingJavaScriptFromString方法可以将javascript嵌入页面中，通过这个方法我们可以在iOS中与UIWebView中的网页元素交互";
    
    [self setupUI];
}

- (void)setupUI {
    
    [self.view addSubview:self.myWeb];
    [self loadHtml:@"UI_JSToWeb"];
}

- (UIWebView *)myWeb {
    if (!_myWeb) {
        _myWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _myWeb.delegate = (id<UIWebViewDelegate>)self;
        _myWeb.backgroundColor = [UIColor redColor];
    }
    return _myWeb;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad: (UIWebView *) webView {
    //重定义web的alert方法,捕获webview弹出的原生alert  可以修改标题和内容等等
    [webView stringByEvaluatingJavaScriptFromString:@"window.alert = function(message) { window.location = \"myapp:&func=alert&message=\" + message; }"];
}

/*
  * 方法的返回值是BOOL值。
  * 返回YES：表示让浏览器执行默认操作，比如某个a链接跳转
  * 返回NO：表示不执行浏览器的默认操作，这里因为通过url协议来判断js执行native的操作，肯定不是浏览器默认操作，故返回NO
  */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *sourceUrlString = [[request URL]  absoluteString];
    NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    if ([requestString hasPrefix:@"myapp:"]) {
        //如果是自己定义的协议, 再截取协议中的方法和参数, 判断无误后在这里手动调用oc方法
        NSMutableDictionary *param = [self queryStringToDictionary:requestString];
        NSLog(@"get param:%@", [param description]);
        
        NSString *func = [param objectForKey:@"func"];
        
        //调用本地函数1
        if([func isEqualToString:@"addSubView"]) {
            Class tempClass =  NSClassFromString([param objectForKey:@"view"]);
            CGRect frame = CGRectFromString([param objectForKey:@"frame"]);
            if(tempClass && [tempClass isSubclassOfClass:[UIWebView class]]) {
                UIWebView *tempObj = [[tempClass alloc] initWithFrame:frame];
                tempObj.tag = [[param objectForKey:@"tag"] integerValue];
                
                NSURL *url = [NSURL URLWithString:[param objectForKey:@"urlstring"]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [tempObj loadRequest:request];
                [self.myWeb addSubview:tempObj];
            }
        }
        //调用本地函数2
        else if([func isEqualToString:@"alert"]) {
//            [self showMessage:@"来自网页的提示" message:[param objectForKey:@"message"]];
            NSLog(@"alert : 来自网页的提示-- %@", [param objectForKey:@"message"]);
        }
        //调用本地函数3
        else if([func isEqualToString:@"callFunc"]) {
            [self testFunc:[param objectForKey:@"first"] withParam2:[param objectForKey:@"second"] andParam3:[param objectForKey:@"third"] ];
        }
        //调用本地函数4
        else if([func isEqualToString:@"testFunc"]) {
            [self testFunc:[param objectForKey:@"param1"] withParam2:[param objectForKey:@"param2"] andParam3:[param objectForKey:@"param3"] ];
        }
        return NO;
    }
    return YES;
}

- (void)testFunc:(NSString*)param1 withParam2:(NSString*)param2 andParam3:(NSString*)param3{
    NSLog(@"callFunc : %@ %@ %@", param1, param2, param3);
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

//get参数转字典
- (NSMutableDictionary*)queryStringToDictionary:(NSString*)string {
    NSMutableArray *elements = (NSMutableArray*)[string componentsSeparatedByString:@"&"];
    [elements removeObjectAtIndex:0];
    NSMutableDictionary *retval = [NSMutableDictionary dictionaryWithCapacity:[elements count]];
    for(NSString *e in elements) {
        NSArray *pair = [e componentsSeparatedByString:@"="];
        [retval setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
    }
    return retval;
}

@end
