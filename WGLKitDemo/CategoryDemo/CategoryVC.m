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
#import "NSTimerVC.h"
#import "NSDataVC.h"
#import "NSFileManagerVC.h"
#import "NSDateVC.h"
#import "UIDeviceVC.h"

@interface CategoryVC ()
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) NSArray <NSString *> *controlViews;
@end

@implementation CategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"类别组件";
    
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
           @"UIImage", @"NSString", @"NSTimer", @"NSData",
           @"NSFileManager", @"NSDate", @"UIDevice", @"UIScreen",
           @"NSArray", @"NSDictionary", @"UIControl", @"UIGestureRecognizer",
           @"UIView", @"NSBundle", @"UIScrollView", @"UIColor",
           ] mutableCopy];
    }
    return _titles;
}

- (NSArray <NSString *> *)controlViews {
    if (!_controlViews) {
        _controlViews =
        [@[
           NSStringFromClass([UIImageVC class]),
           NSStringFromClass([NSStringVC class]),
           NSStringFromClass([NSTimerVC class]),
           NSStringFromClass([NSDataVC class]),
           NSStringFromClass([NSFileManagerVC class]),
           NSStringFromClass([NSDateVC class]),
           NSStringFromClass([UIDeviceVC class]),
           ] mutableCopy];
    }
    return _controlViews;
}


@end
