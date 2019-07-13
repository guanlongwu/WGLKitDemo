//
//  WebJSBridgeVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/7/8.
//  Copyright © 2019 huya. All rights reserved.
//

#import "WebJSBridgeVC.h"
#import "NSArray+Safe.h"
#import "UIView+Extensions.h"

@interface WebJSBridgeVC ()
@property (nonatomic, strong) NSArray <NSString *> *titles;

@end

@implementation WebJSBridgeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    
    CGFloat width = 90;
    CGFloat height = 50;
    for (int row = 0; row < 2; row++) {
        for (int column = 0; column < 4; column++) {
            CGFloat originX = 3 + column * (width + 3);
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
}

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles =
        [@[
           @"UI_WebToJS_VC", @"UI_JSToWeb_VC",
           @"WK_WebToJS_VC", @"WK_JSToWeb_VC",
           @"UI_WVJB_VC", @"WK_WVJB_VC",
           @"JavaScriptCore_VC",
           ] mutableCopy];
    }
    return _titles;
}

#pragma mark - Action

- (void)c_click:(UIButton *)sender {
    NSInteger idx = sender.tag;
    
    NSString *clsName = [self.titles safeObjectAtIndex:idx];
    Class cls = NSClassFromString(clsName);
    UIViewController *vc = [[cls alloc] init];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
