//
//  WGLCenterSegmentView.h
//  WGLKit
//
//  Created by wugl on 2018/5/24.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGLSegmentTabBar.h"
#import "WGLSubSegmentBaseViewController.h"
#import "WGLSegmentHorizontalScrollView.h"

typedef void(^HYIsMainTableViewCanScrollBlock)(BOOL isCanScroll);
typedef void(^HYIsSegmentTabBarLeaveTopBlock)(BOOL isLeaveTop);

@class WGLSegmentMainTableView;
@protocol WGLCenterSegmentViewDataSource;
@protocol WGLCenterSegmentViewDelegate;

@interface WGLCenterSegmentView : UIView

/**
 分页选择tabBar
 */
@property (nonatomic, strong) WGLSegmentTabBar *tabBarView;

/**
 内容左右切换的scrollView
 */
@property (nonatomic, strong) WGLSegmentHorizontalScrollView *segmentScrollView;

@property (nonatomic, weak) id<WGLCenterSegmentViewDataSource> dataSource;
@property (nonatomic, weak) id<WGLCenterSegmentViewDelegate> delegate;
@property (nonatomic, copy) HYIsMainTableViewCanScrollBlock isCanScrollBlock;//是否允许外层mainTableView上下滚动
@property (nonatomic, copy) HYIsSegmentTabBarLeaveTopBlock isLeaveTopBlock;//tabBar是否没有紧贴悬浮位置

/**
 最底层WGLSegmentMainTableView，弱指针的方式传递给WGLSubSegmentBaseViewController
 WGLSubSegmentBaseViewController需要实时地知道WGLSegmentMainTableView是否可以滚动状态？以及其它状态
 */
@property (nonatomic, weak) WGLSegmentMainTableView *mainTableView;

//分页tab是否固定（default NO）
@property (nonatomic, assign) BOOL isSegmentTabFix;

- (void)reloadData;

- (void)selectSegmentAtIndex:(NSInteger)index;
- (void)selectSegmentAtIndex:(NSInteger)index animation:(BOOL)animation;

//告知subSegment可以滚动
- (void)allowSubSegmentViewScroll;

@end


@protocol WGLCenterSegmentViewDataSource <NSObject>

- (NSInteger)numberOfTitlesInCenterSegmentView:(WGLCenterSegmentView *)centerSegmentView;//Default 0
- (NSString *)centerSegmentView:(WGLCenterSegmentView *)centerSegmentView titleForIndex:(NSInteger)index;
- (UIButton *)centerSegmentView:(WGLCenterSegmentView *)centerSegmentView buttonForIndex:(NSInteger)index;
- (CGFloat)heightForTabBarViewInCenterSegmentView:(WGLCenterSegmentView *)centerSegmentView;

- (WGLSubSegmentBaseViewController *)centerSegmentView:(WGLCenterSegmentView *)centerSegmentView viewControllerForIndex:(NSInteger)index;

- (UIButton *)leftButtonForCenterSegmentView:(WGLCenterSegmentView *)centerSegmentView;
- (UIButton *)rightButtonForCenterSegmentView:(WGLCenterSegmentView *)centerSegmentView;

- (WGLSegmentTabBar *)tabBarViewForCenterSegmentView:(WGLCenterSegmentView *)centerSegmentView;

@end


@protocol WGLCenterSegmentViewDelegate <NSObject>

- (void)centerSegmentView:(WGLCenterSegmentView *)centerSegmentView willDisplaySegmentVC:(WGLSubSegmentBaseViewController *)segmentVC forIndex:(NSInteger)index;

- (void)centerSegmentView:(WGLCenterSegmentView *)centerSegmentView didDisplaySegmentVC:(WGLSubSegmentBaseViewController *)segmentVC forIndex:(NSInteger)index;

- (void)centerSegmentView:(WGLCenterSegmentView *)centerSegmentView didScroll:(UIScrollView *)scrolllView;

@end


