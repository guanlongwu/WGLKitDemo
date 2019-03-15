//
//  CategoryVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/3/12.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "CategoryVC.h"
#import "NSArray+Safe.h"

#import "UIImageVC.h"
#import "NSStringVC.h"

@interface CategoryVC ()
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) NSArray <UIViewController *> *controlViews;
@end

@implementation CategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = 80;
    CGFloat height = 50;
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 4; column++) {
            CGFloat originX = 10 + column * (width + 10);
            CGFloat originY = 80 + row * (height + 30);
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
            btn.backgroundColor = [UIColor grayColor];
            [btn setTintColor:[UIColor whiteColor]];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [self.view addSubview:btn];
            [btn addTarget:self action:@selector(c_category:) forControlEvents:UIControlEventTouchUpInside];
            
            NSInteger idx = 4 * row + column;
            btn.tag = idx;
            NSString *title = [self.titles safeObjectAtIndex:idx];
            [btn setTitle:title ?: @"..." forState:UIControlStateNormal];
        }
    }
}

- (void)c_category:(UIButton *)sender {
    NSInteger idx = sender.tag;
    UIViewController *vc = [self.controlViews safeObjectAtIndex:idx];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles =
        [@[
           @"UIImage", @"NSString", @"UIScrollView", @"NSTimer",
           @"NSArray", @"NSDictionary", @"UIColor", @"UIView",
           @"NSBundle", @"NSData", @"NSDate", @"NSFileManager",
           @"UIControl", @"UIDevice", @"UIGestureRecognizer", @"UIScreen",
           ] mutableCopy];
    }
    return _titles;
}

- (NSArray <UIViewController *> *)controlViews {
    if (!_controlViews) {
        _controlViews =
        [@[
           [UIImageVC new],
           [NSStringVC new],
           ] mutableCopy];
    }
    return _controlViews;
}


@end
