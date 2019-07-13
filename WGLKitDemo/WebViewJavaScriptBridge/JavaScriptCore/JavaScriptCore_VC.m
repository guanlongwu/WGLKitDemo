//
//  JavaScriptCore_VC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/7/13.
//  Copyright © 2019 huya. All rights reserved.
//

#import "JavaScriptCore_VC.h"
#import "NSArray+Safe.h"
#import "UIView+Extensions.h"
#import "UIControl+Block.h"

@interface JavaScriptCore_VC ()
@property (strong, nonatomic) UIWebView *myWeb;
@property (strong, nonatomic) JSContext *context;
@property (strong, nonatomic) UIButton *ocCallJSBtn;
@end

@implementation JavaScriptCore_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"JavaScriptCore";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupUI];
    self.context = [[JSContext alloc] init];
}

- (void)setupUI {
    [self.view addSubview:self.myWeb];
    [self jsCallOC];
    [self.view addSubview:self.ocCallJSBtn];
}

- (UIWebView *)myWeb {
    if (!_myWeb) {
        _myWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 100, self.view.width, self.view.height - 100)];
        _myWeb.backgroundColor = [UIColor redColor];
    }
    return _myWeb;
}

- (UIButton *)ocCallJSBtn {
    if (!_ocCallJSBtn) {
        _ocCallJSBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 100, 100)];
        [_ocCallJSBtn setTitle:@"oc调用js" forState:UIControlStateNormal];
        [_ocCallJSBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_ocCallJSBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf ocCallJS];
        }];
    }
    return _ocCallJSBtn;
}

#pragma mark - events

- (void)jsCallOC {
    [self loadHtml:@"JSCallOC"];
}

- (void)ocCallJS {
    NSString *js = [self loadJsFile:@"OCCallJS"];
    [self.context evaluateScript:js];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSNumber *inputNumber = [NSNumber numberWithInteger:4];
        JSValue *function = [self.context objectForKeyedSubscript:@"factorial"];
        JSValue *result = [function callWithArguments:@[inputNumber]];
        NSLog(@"jsValue: %@", [NSString stringWithFormat:@"%@", [result toNumber]]);
    });
}

#pragma mark - private

-(void)loadHtml:(NSString*)name {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];
    if (filePath) {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.myWeb loadRequest:request];
    }
}

- (NSString *)loadJsFile:(NSString*)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"js"];
    NSString *jsScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return jsScript;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 以 html title 设置 导航栏 title
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    // Undocumented access to UIWebView's JSContext
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 打印异常
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    
    // 以 JSExport 协议关联 native 的方法
    self.context[@"app"] = self;
    
    // 以 block 形式关联 JavaScript function
    self.context[@"log"] =
    ^(NSString *str) {
        NSLog(@"%@", str);
    };
    
    // 以 block 形式关联 JavaScript function
    self.context[@"alert"] =
    ^(NSString *str) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"msg from js" message:str delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    };
    
    __block typeof(self) weakSelf = self;
    self.context[@"addSubView"] =
    ^(NSString *viewname) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 500, 300, 100)];
        view.backgroundColor = [UIColor redColor];
        UISwitch *sw = [[UISwitch alloc]init];
        [view addSubview:sw];
        [weakSelf.view addSubview:view];
    };
    //多参数
    self.context[@"mutiParams"] =
    ^(NSString *a,NSString *b,NSString *c) {
        NSLog(@"%@ %@ %@",a,b,c);
    };
    
}

#pragma mark - JSExport Methods

- (void)handleFactorialCalculateWithNumber:(NSString *)number {
    NSLog(@"%@", number);
    NSNumber *result = [self calculateFactorialOfNumber:@([number integerValue])];
    
    NSLog(@"%@", result);
    [self.context[@"showResult"] callWithArguments:@[result]];
}

- (void)pushViewController:(NSString *)view title:(NSString *)title {
    Class second = NSClassFromString(view);
    id secondVC = [[second alloc]init];
    ((UIViewController*)secondVC).title = title;
    [self.navigationController pushViewController:secondVC animated:YES];
}

#pragma mark - Factorial Method

- (NSNumber *)calculateFactorialOfNumber:(NSNumber *)number {
    NSInteger i = [number integerValue];
    if (i < 0) {
        return [NSNumber numberWithInteger:0];
    }
    if (i == 0) {
        return [NSNumber numberWithInteger:1];
    }
    NSInteger r = (i * [(NSNumber *)[self calculateFactorialOfNumber:[NSNumber numberWithInteger:(i - 1)]] integerValue]);
    return [NSNumber numberWithInteger:r];
}

@end


/**
 总结：
 
 创建JSContext的方式：
 1.这种方式需要传入一个JSVirtualMachine对象，如果传nil，会导致应用崩溃的。
 JSVirtualMachine *JSVM = [[JSVirtualMachine alloc] init];
 JSContext *JSCtx = [[JSContext alloc] initWithVirtualMachine:JSVM];
 
 2.这种方式，内部会自动创建一个JSVirtualMachine对象，可以通过JSCtx.virtualMachine看其是否创建了一个JSVirtualMachine对象。
 JSContext *JSCtx = [[JSContext alloc] init];
 
 3. 通过webView的获取JSContext。
 JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
 
 JSValue介绍：
 JSValue都是通过JSContext返回或者创建的，并没有构造方法。
 JSValue包含了每一个JavaScript类型的值，
 通过JSValue可以将Objective-C中的类型转换为JavaScript中的类型，
 也可以将JavaScript中的类型转换为Objective-C中的类型。
 
 JSExport介绍：
 JSExport是一个协议类，但是该协议并没有任何属性和方法。
 怎么使用呢？
 我们可以自定义一个协议类，继承自JSExport。无论我们在JSExport里声明的属性，实例方法还是类方法，继承的协议都会自动的提供给任何 JavaScript 代码。
 So，我们只需要在自定义的协议类中，添加上属性和方法就可以了。
 
 
 关于WKWebView 与JavaScriptCore：
 由于WKWebView 不支持通过如下的KVC的方式创建JSContext：
 JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
 
 那么就不能在WKWebView中使用JavaScriptCore了。
 而且，WKWebView中有OC 和JS交互的方式，更easy 、更简洁，因此也用不着使用JavaScriptCore。
 
 */

