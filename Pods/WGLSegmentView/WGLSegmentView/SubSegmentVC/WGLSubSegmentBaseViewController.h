//
//  WGLSubSegmentBaseViewController.h
//  WGLKit
//
//  Created by wugl on 2018/5/25.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

//此类为分页控件的子控制器的父类(处理了scroll滑动手势冲突)

#import <UIKit/UIKit.h>
#import "WGLSegmentMainTableView.h"

typedef void(^HYSubSegmentBaseVCDidScrollCallback)(UIScrollView *scrollView);
typedef void(^HYIsSegmentTabBarLeaveTopBlock)(BOOL isLeaveTopBlock);

@interface WGLSubSegmentBaseViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) HYSubSegmentBaseVCDidScrollCallback didScrollCallback;
@property (nonatomic, copy) HYIsSegmentTabBarLeaveTopBlock isLeaveTopBlock;

/**
 最底层WGLSegmentMainTableView，弱指针的方式传递给WGLSubSegmentBaseViewController
 WGLSubSegmentBaseViewController需要实时地知道WGLSegmentMainTableView是否可以滚动状态？以及其它状态
 */
@property (nonatomic, weak) WGLSegmentMainTableView *mainTableView;

//分页tab是否固定（default NO）
@property (nonatomic, assign) BOOL isSegmentTabFix;

//更新scrollView的大小
- (void)resetScrollViewFrame:(CGRect)frame;

//告知subSegment可以滚动
- (void)allowSubSegmentViewScroll;

//subSegment恢复offsetZero
- (void)setSubSegmentViewOffsetZero;

@end
