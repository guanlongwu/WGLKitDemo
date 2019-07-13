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

/**
 总结：
 
 JS 调用原生 OC
 我们可以利用 JS 发起一个假的 URL 请求，然后利用 UIWebView 的代理方法拦截这次请求，然后再做相应的处理。
 
 问题：
 为什么定义一个loadURL方法，不直接使用window.location.href?
 答：
 因为如果当前网页正在使用window.location.href加载网页的同时，调用window.location.href去调用 OC 原生方法，会导致加载网页的操作被取消掉。
 同样的，如果连续使用window.location.href执行两次 OC 原生调用，也有可能导致第一次的操作被取消掉。
 所以我们使用自定义的loadURL，来避免这个问题。
 JS用打开一个iFrame的方式替代直接用document.location的方式，以避免多次请求，被替换覆盖的问题。
 
 JS代码如下：
function loadURL(url) {
    var iFrame;
    iFrame = document.createElement("iframe");
    iFrame.setAttribute("src", url);
    iFrame.setAttribute("style", "display:none;");
    iFrame.setAttribute("height", "0px");
    iFrame.setAttribute("width", "0px");
    iFrame.setAttribute("frameborder", "0");
    document.body.appendChild(iFrame);
    // 发起请求后这个 iFrame 就没用了，所以把它从 dom 上移除掉
    iFrame.parentNode.removeChild(iFrame);
    iFrame = null;
    }
 
 
*/
