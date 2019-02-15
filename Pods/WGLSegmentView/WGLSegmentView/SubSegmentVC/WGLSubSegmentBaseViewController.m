//
//  WGLSubSegmentBaseViewController.m
//  WGLKit
//
//  Created by wugl on 2018/5/25.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#import "WGLSubSegmentBaseViewController.h"

@interface WGLSubSegmentBaseViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL canScroll;   //是否可以滚动
@end

@implementation WGLSubSegmentBaseViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //子控制器视图到达顶部的通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"goTop" object:nil];
    //    //子控制器视图离开顶部的通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
}

#pragma mark - notification

//- (void)acceptMsg:(NSNotification *)notification {
//    NSString *notificationName = notification.name;
//    if ([notificationName isEqualToString:@"goTop"]) {
//        NSDictionary *userInfo = notification.userInfo;
//        NSString *canScroll = userInfo[@"canScroll"];
//        if ([canScroll isEqualToString:@"1"]) {
//            _canScroll = YES;
//            self.tableView.showsVerticalScrollIndicator = YES;
//        }
//    }
//    else if([notificationName isEqualToString:@"leaveTop"]){
//        _canScroll = NO;
//        self.tableView.contentOffset = CGPointZero;
//        self.tableView.showsVerticalScrollIndicator = NO;
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /**
     注意：
     如果外层scroll是不允许滚动/没有反弹效果bounces=NO的话，有可能一开始offsetY就等于0.0f，这个时候，一开始滚动，就会发送通知，从而设置_canScroll=NO；
     最终导致内层scroll一开始就不能滚动了。
     */
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat criticalY = 0.5f;
    CGFloat criticalY_2 = 20.0f;
    
    //判断最外层scroll是否可以滚动
    //如果分页tab固定不动，则只允许内层scroll滚动，外层scroll不滚动
    if (self.isSegmentTabFix) {
        if (self.didScrollCallback) {
            self.didScrollCallback(scrollView);
        }
    }
    else {
        if (!_canScroll) {
            [scrollView setContentOffset:CGPointZero];
        }
        if (offsetY <= criticalY) {
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil userInfo:@{@"canScroll":@"1"}];
            if (self.isLeaveTopBlock) {
                self.isLeaveTopBlock(YES);
            }
        }
        else if (offsetY > criticalY_2) {
            if (self.didScrollCallback) {
                self.didScrollCallback(scrollView);
            }
        }
    }
}

#pragma mark - 告知subSegment可以滚动

- (void)allowSubSegmentViewScroll {
    _canScroll = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
}

#pragma mark - subSegment恢复offsetZero

- (void)setSubSegmentViewOffsetZero {
    _canScroll = NO;
    self.tableView.contentOffset = CGPointZero;
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - 更新scroll大小

- (void)resetScrollViewFrame:(CGRect)frame {
    if (self.tableView) {
        self.tableView.frame = frame;
    }
}

#pragma mark -

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}


@end
