//
//  ViewController.m
//  WGLKitDemo
//
//  Created by wugl on 2018/11/15.
//  Copyright © 2018年 huya. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+Safe.h"

#import "SegmentVC.h"
#import "DownloadVC.h"
#import "CategoryVC.h"
#import "M3U8VC.h"
#import "UploadVC.h"
#import "WebJSBridgeVC.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) NSArray <NSString *> *controlViews;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
            [btn addTarget:self action:@selector(c_kitDemo:) forControlEvents:UIControlEventTouchUpInside];
            
            NSInteger idx = 4 * row + column;
            btn.tag = idx;
            NSString *title = [self.titles safeObjectAtIndex:idx];
            [btn setTitle:title ?: @"..." forState:UIControlStateNormal];
        }
    }
}

- (void)c_kitDemo:(UIButton *)sender {
    NSInteger idx = sender.tag;
    NSString *clsName = [self.controlViews safeObjectAtIndex:idx];
    Class cls = NSClassFromString(clsName);
    UIViewController *vc = [[cls alloc] init];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles =
        [@[
           @"SegmentView", @"Downloader", @"Categories", @"M3U8Processing",
           @"Uploader", @"WebJSBridge",
           ] mutableCopy];
    }
    return _titles;
}

- (NSArray <NSString *> *)controlViews {
    if (!_controlViews) {
        _controlViews =
        [@[
           NSStringFromClass([SegmentVC class]),
           NSStringFromClass([DownloadVC class]),
           NSStringFromClass([CategoryVC class]),
           NSStringFromClass([M3U8VC class]),
           NSStringFromClass([UploadVC class]),
           NSStringFromClass([WebJSBridgeVC class]),
           ] mutableCopy];
    }
    return _controlViews;
}

#pragma mark - 测试commit

- (void)commit
{
    // commit 0
    NSLog(@"commit 0");
}


@end
