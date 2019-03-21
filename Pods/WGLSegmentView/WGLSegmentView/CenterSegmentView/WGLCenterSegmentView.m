//
//  WGLCenterSegmentView.m
//  WGLKit
//
//  Created by wugl on 2018/5/24.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#import "WGLCenterSegmentView.h"

@interface WGLCenterSegmentView ()
@property (nonatomic, strong) NSMutableArray <WGLSubSegmentBaseViewController *>*controllers;
@property (nonatomic, strong) NSMutableArray <NSString *>*titles;

@property (nonatomic, assign) NSInteger numberOfTitles;
@end

@implementation WGLCenterSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI
{
    [self addSubview:self.segmentScrollView];
}

- (void)reloadData {
    //分页tab
    // 因为懒加载时，如何在init addView datasource为nil，因此在reload方法add
    if(self.tabBarView.superview == nil){
        [self addSubview:self.tabBarView];
    }
    [self.tabBarView reloadData];
    
    //内容vc
    NSInteger numberOfTitles = [self numberOfTitlesInSegmentTabBar:self.tabBarView];
    
    self.segmentScrollView.contentSize = CGSizeMake(self.frame.size.width * numberOfTitles, self.segmentScrollView.frame.size.height);
    
    if (numberOfTitles > 0 && numberOfTitles != self.numberOfTitles) {
        self.numberOfTitles = numberOfTitles;
        
        if (self.controllers == nil) {
            self.controllers = [NSMutableArray array];
        }
        [self.controllers enumerateObjectsUsingBlock:^(WGLSubSegmentBaseViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.view removeFromSuperview];
        }];
        [self.controllers removeAllObjects];
        
        //内容ViewController
        for (int i = 0; i < numberOfTitles; i++) {
            WGLSubSegmentBaseViewController *vc = nil;
            if ([self.dataSource respondsToSelector:@selector(centerSegmentView:viewControllerForIndex:)]) {
                vc = [self.dataSource centerSegmentView:self viewControllerForIndex:i];
            }
            if (!vc) {
                vc = [[WGLSubSegmentBaseViewController alloc] init];
            }
            vc.isSegmentTabFix = self.isSegmentTabFix;
            vc.mainTableView = self.mainTableView;
            
            __weak typeof(self) weakSelf = self;
            vc.didScrollCallback = ^(UIScrollView *scrollView) {
                if ([weakSelf.delegate respondsToSelector:@selector(centerSegmentView:didScroll:)]) {
                    [weakSelf.delegate centerSegmentView:weakSelf didScroll:scrollView];
                }
            };
            
            vc.isLeaveTopBlock = ^(BOOL isLeaveTopBlock) {
                if (weakSelf.isLeaveTopBlock) {
                    weakSelf.isLeaveTopBlock(isLeaveTopBlock);
                }
                [weakSelf setSubSegmentViewOffsetZero];
            };
            
            [self.segmentScrollView addSubview:vc.view];
            [self.controllers addObject:vc];
        }
        
        //默认选中第一个分页,并回调
        [self selectSegmentAtIndex:0];
    }
    
    [self layoutSubviews];
}

//分页选择tabBar
- (WGLSegmentTabBar *)tabBarView {
    if (!_tabBarView) {
        if([self.dataSource respondsToSelector:@selector(tabBarViewForCenterSegmentView:)]){
            _tabBarView = [self.dataSource tabBarViewForCenterSegmentView:self];
        }
        
        if (!_tabBarView) {
            _tabBarView = [[WGLSegmentTabBar alloc] initWithFrame:CGRectZero];
        }
        _tabBarView.dataSource = (id<WGLSegmentTabBarDataSource>)self;
        __weak typeof(self) weakSelf = self;
        _tabBarView.tapHandler = ^(NSInteger index) {
            [weakSelf selectSegmentAtIndex:index animation:YES];
        };
    }
    return _tabBarView;
}

//分页内容scroll(左右滑动)
- (WGLSegmentHorizontalScrollView *)segmentScrollView {
    if (!_segmentScrollView) {
        _segmentScrollView = [[WGLSegmentHorizontalScrollView alloc] init];
        _segmentScrollView.showsHorizontalScrollIndicator = NO;
        _segmentScrollView.pagingEnabled = YES;
        _segmentScrollView.bounces = NO;
        _segmentScrollView.delegate = (id<UIScrollViewDelegate>)self;
    }
    return _segmentScrollView;
}

#pragma mark - 选中某个分页

- (void)selectSegmentAtIndex:(NSInteger)index {
    [self selectSegmentAtIndex:index animation:NO];
}

- (void)selectSegmentAtIndex:(NSInteger)index animation:(BOOL)animation {
    if (index >= 0 && index < self.controllers.count) {
        [self.tabBarView selectTabAtIndex:index animation:animation];
        [self.segmentScrollView setContentOffset:CGPointMake(index * self.frame.size.width, 0) animated:animation];
        if (animation == NO || index == 0) {
            //设定默认选中分页时，如果偏移不带动画，或者偏移为第一个0，则手动回调callback（否则通过scroll代理回调去执行callback）
            
            [self callbackDidEndScrollWithIndex:index];

        }
    }
}

#pragma mark - 告知subSegment可以滚动

- (void)allowSubSegmentViewScroll {
    [self.controllers enumerateObjectsUsingBlock:^(WGLSubSegmentBaseViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj allowSubSegmentViewScroll];
    }];
}

- (void)setSubSegmentViewOffsetZero {
    [self.controllers enumerateObjectsUsingBlock:^(WGLSubSegmentBaseViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setSubSegmentViewOffsetZero];
    }];
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //分页tab大小
    CGFloat heightForTabBar = 0;
    if ([self.dataSource respondsToSelector:@selector(heightForTabBarViewInCenterSegmentView:)]) {
        heightForTabBar = [self.dataSource heightForTabBarViewInCenterSegmentView:self];
    }
    self.tabBarView.frame = CGRectMake(0, 0, self.frame.size.width, heightForTabBar);
    
    //左右scroll长度
    self.segmentScrollView.frame = CGRectMake(0, heightForTabBar, self.frame.size.width, self.frame.size.height-heightForTabBar);
    
    //内容vc大小
    [self.controllers enumerateObjectsUsingBlock:^(WGLSubSegmentBaseViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.view.frame = CGRectMake(self.frame.size.width * idx, 0, self.frame.size.width, self.segmentScrollView.frame.size.height);
        [obj resetScrollViewFrame:CGRectMake(0, 0, self.frame.size.width, self.segmentScrollView.frame.size.height)];
    }];
}

#pragma mark - scrollview滑动互斥

//segmentScrollView左右滑动时和外层tableView上下滑动需要做互斥处理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isCanScrollBlock) {
        self.isCanScrollBlock(NO);
    }
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"isScroll" object:nil userInfo:@{@"canScroll":@"0"}];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isCanScrollBlock) {
        self.isCanScrollBlock(YES);
    }
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"isScroll" object:nil userInfo:@{@"canScroll":@"1"}];
}

//滑动下方分页View时的事件处理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.segmentScrollView) {
        NSInteger index = scrollView.contentOffset.x / self.frame.size.width;
        
        [self.tabBarView selectTabAtIndex:index animation:YES];
        [self.segmentScrollView setContentOffset:CGPointMake(index * self.frame.size.width, 0) animated:YES];
        
        //回调
        [self callbackDidEndScrollWithIndex:index];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.segmentScrollView) {
        NSInteger index = scrollView.contentOffset.x / self.frame.size.width;
        
        //回调
        [self callbackDidEndScrollWithIndex:index];
    }
}

//滚动结束回调 刷新 segmentVC
- (void)callbackDidEndScrollWithIndex:(NSInteger)index {
    if (self.controllers.count > index) {
        WGLSubSegmentBaseViewController *segmentVC = self.controllers[index];
        
        if ([self.delegate respondsToSelector:@selector(centerSegmentView:didDisplaySegmentVC:forIndex:)]) {
            [self.delegate centerSegmentView:self didDisplaySegmentVC:segmentVC forIndex:index];
        }
    }
}

#pragma mark - WGLSegmentTabBarDataSource

- (NSInteger)numberOfTitlesInSegmentTabBar:(WGLSegmentTabBar *)segmentTabBar {
    NSInteger number = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfTitlesInCenterSegmentView:)]) {
        number = [self.dataSource numberOfTitlesInCenterSegmentView:self];
    }
    return number;
}

- (NSString *)segmentTabBar:(WGLSegmentTabBar *)segmentTabBar titleForIndex:(NSInteger)index {
    NSString *title = nil;
    if ([self.dataSource respondsToSelector:@selector(centerSegmentView:titleForIndex:)]) {
        title = [self.dataSource centerSegmentView:self titleForIndex:index];
    }
    return title;
}

- (UIButton *)segmentTabBar:(WGLSegmentTabBar *)segmentTabBar buttonForIndex:(NSInteger)index {
    UIButton *button = nil;
    if ([self.dataSource respondsToSelector:@selector(centerSegmentView:buttonForIndex:)]) {
        button = [self.dataSource centerSegmentView:self buttonForIndex:index];
    }
    return button;
}

- (UIButton *)leftButtonForSegmentTabBar:(WGLSegmentTabBar *)segmentTabBar {
    UIButton *button = nil;
    if ([self.dataSource respondsToSelector:@selector(leftButtonForCenterSegmentView:)]) {
        button = [self.dataSource leftButtonForCenterSegmentView:self];
    }
    return button;
}

- (UIButton *)rightButtonForSegmentTabBar:(WGLSegmentTabBar *)segmentTabBar {
    UIButton *button = nil;
    if ([self.dataSource respondsToSelector:@selector(rightButtonForCenterSegmentView:)]) {
        button = [self.dataSource rightButtonForCenterSegmentView:self];
    }
    return button;
}


@end
