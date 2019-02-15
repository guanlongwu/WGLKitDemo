//
//  WGLSegmentView.h
//  WGLKit
//
//  Created by wugl on 2018/5/24.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGLCenterSegmentView.h"
#import "WGLSegmentMainTableView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol WGLSegmentViewDelegate, WGLSegmentViewDataSource;

@interface WGLSegmentView : UIView

/**
 最底下的tableView
 */
@property (nonatomic, strong) WGLSegmentMainTableView *mainTableView;

/**
 分页控件的父view(也是mainTableView上面的subView)
 分页tabBar和分页scrollView都是在这上面
 */
@property (nonatomic, strong) WGLCenterSegmentView *centerSegmentView;

@property (nonatomic, weak, nullable) id <WGLSegmentViewDelegate> delegate;
@property (nonatomic, weak, nullable) id <WGLSegmentViewDataSource> dataSource;

- (void)reloadData;

//选择分页
- (void)selectSegmentAtIndex:(NSInteger)index;
- (void)selectSegmentAtIndex:(NSInteger)index animation:(BOOL)animation;

//分页tab悬挂
- (void)scrollToSegmentTabSuspend;
- (void)scrollToSegmentTabSuspendWithAnimation:(BOOL)animation;

@end




@protocol WGLSegmentViewDataSource<NSObject>
@required
- (NSInteger)segmentView:(WGLSegmentView *)segmentView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)segmentView:(WGLSegmentView *)segmentView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInSegmentView:(WGLSegmentView *)segmentView;
- (nullable NSString *)segmentView:(WGLSegmentView *)segmentView titleForHeaderInSection:(NSInteger)section;
- (nullable NSString *)segmentView:(WGLSegmentView *)segmentView titleForFooterInSection:(NSInteger)section;

//判断点击中的indexPath是否响应滚动手势
- (BOOL)segmentView:(WGLSegmentView *)segmentView isScrollEnable:(NSIndexPath *)indexPath;


//判断点击中的indexPath是否响应多点滚动手势
- (BOOL)segmentView:(WGLSegmentView *)segmentView isShouldRecognizeSimultaneously:(NSIndexPath *)indexPath;

//分页控件
- (NSInteger)numberOfTitlesInSegmentView:(WGLSegmentView *)segmentView;//Default 0
- (NSString *)segmentView:(WGLSegmentView *)segmentView titleForIndex:(NSInteger)index;
- (UIButton *)segmentView:(WGLSegmentView *)segmentView buttonForIndex:(NSInteger)index;
- (CGFloat)heightForTabBarViewInSegmentView:(WGLSegmentView *)segmentView;

- (UIButton *)leftButtonForSegmentView:(WGLSegmentView *)segmentView;
- (UIButton *)rightButtonForSegmentView:(WGLSegmentView *)segmentView;

- (WGLSubSegmentBaseViewController *)segmentView:(WGLSegmentView *)segmentView viewControllerForIndex:(NSInteger)index;

- (WGLSegmentTabBar *)tabBarViewForSegmentView:(WGLSegmentView *)segmentView;

@end


@protocol WGLSegmentViewDelegate<NSObject, UIScrollViewDelegate>

@optional
- (void)segmentView:(WGLSegmentView *)segmentView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)segmentView:(WGLSegmentView *)segmentView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
- (void)segmentView:(WGLSegmentView *)segmentView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);

- (CGFloat)segmentView:(WGLSegmentView *)segmentView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)segmentView:(WGLSegmentView *)segmentView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)segmentView:(WGLSegmentView *)segmentView heightForFooterInSection:(NSInteger)section;

- (nullable UIView *)segmentView:(WGLSegmentView *)segmentView viewForHeaderInSection:(NSInteger)section;
- (nullable UIView *)segmentView:(WGLSegmentView *)segmentView viewForFooterInSection:(NSInteger)section;

- (void)segmentView:(WGLSegmentView *)segmentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//分页控件
- (void)segmentView:(WGLSegmentView *)segmentView willDisplaySegmentVC:(WGLSubSegmentBaseViewController *)segmentVC forIndex:(NSInteger)index;

- (void)segmentView:(WGLSegmentView *)segmentView didDisplaySegmentVC:(WGLSubSegmentBaseViewController *)segmentVC forIndex:(NSInteger)index;

- (void)segmentView:(WGLSegmentView *)segmentView didScroll:(UIScrollView *)scrolllView;

@end

NS_ASSUME_NONNULL_END



