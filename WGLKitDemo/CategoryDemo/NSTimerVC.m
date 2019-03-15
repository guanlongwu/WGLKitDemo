//
//  NSTimerVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/3/15.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "NSTimerVC.h"
#import "NSTimer+Block.h"

@interface NSTimerVC ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *label;
@end

@implementation NSTimerVC

- (void)dealloc {
    NSLog(@"NSTimer has no cycle retain");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    self.label.font = [UIFont systemFontOfSize:30];
    self.label.textColor = [UIColor redColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.label];
    
//    [self createTimer];
//    [self createTimer2];
    [self createTimer3];
    
}

- (void)createTimer {
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.label.text = [NSString stringWithFormat:@"origin_%u", arc4random() % 100];
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)createTimer2 {
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:2 block:^(NSTimer *timer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.label.text = [NSString stringWithFormat:@"block_%u", arc4random() % 100];
    } repeats:YES];
}

- (void)createTimer3 {
    //这种方式timer会对self进行强引用，导致循环引用，需要通过外部设置invalidate方式才能释放，否则不会调用dealloc
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(n_action:) userInfo:@"selector" repeats:YES];
}

- (void)n_action:(NSTimer *)timer {
    NSString *userInfo = timer.userInfo;
    self.label.text = [NSString stringWithFormat:@"%@_%u", userInfo, arc4random() % 100];
}


@end
