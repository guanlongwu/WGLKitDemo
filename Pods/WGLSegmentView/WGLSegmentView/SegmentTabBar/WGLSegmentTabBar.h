//
//  WGLSegmentTabBar.h
//  WGLKit
//
//  Created by wugl on 2018/5/24.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WGLSegmentTabBarDataSource;

typedef void(^WGLSegmentTabBarTapHandler)(NSInteger index);

@interface WGLSegmentTabBar : UIView
@property (nonatomic, strong) UIScrollView *scrollView; //承载tab的scrollview
@property (nonatomic, copy) WGLSegmentTabBarTapHandler tapHandler;
@property (nonatomic, weak) id<WGLSegmentTabBarDataSource> dataSource;

@property (nonatomic, strong) NSMutableArray <UIButton *>* tabBarButtons;
@property (nonatomic, assign) NSInteger selectedIndex;  //当前选中的下标
@property (nonatomic, strong) UIButton *leftButton, *rightButton;//左右按钮

@property (nonatomic, strong) UIColor *buttonBgNormalColor; //默认button背景色
@property (nonatomic, strong) UIColor *buttonBgSelectedColor;   //选中button背景色

@property (nonatomic, strong) UIFont *titleNormalFont;  //默认字号
@property (nonatomic, strong) UIFont *titleSelectedFont;//选中字号
@property (nonatomic, strong) UIColor *titleNormalColor;//默认字体颜色
@property (nonatomic, strong) UIColor *titleSelectedColor;//选中字体颜色

@property (nonatomic, strong) UIView *selectedLine;   //下划线
@property (nonatomic, assign) CGFloat selectedLineWidth, selectedLineHeight; //下划线的宽、高
@property (nonatomic, assign) CGFloat selectedLineOriginY;  //下划线的y偏移(默认是贴着tabBar底部)
@property (nonatomic, strong) UIColor *selectedLineColor; //下划线的颜色
@property (nonatomic, assign) BOOL selectedLineWidthIsDynamic;  //下划线的宽度是否动态变化（YES：则与title的宽度一致）
@property (nonatomic, assign) CGFloat marginLeft, marginRight; //头部tab左右两端和边缘的间隔
@property (nonatomic, assign) CGFloat tabInterval;  //item之间的间隙
@property (nonatomic, assign) BOOL isAutoLayout;//tab是否自动布局（宽度平分，默认是NO）

- (void)reloadData;

- (void)selectTabAtIndex:(NSInteger)index;  //选中某个tab
- (void)selectTabAtIndex:(NSInteger)index animation:(BOOL)animation;

//获取文字宽高
- (CGSize)sizeOfString:(NSString *)string font:(UIFont *)font maxwidth:(CGFloat)maxwidth;

@end


@protocol WGLSegmentTabBarDataSource <NSObject>

- (NSInteger)numberOfTitlesInSegmentTabBar:(WGLSegmentTabBar *)segmentTabBar;    //Default 0
- (NSString *)segmentTabBar:(WGLSegmentTabBar *)segmentTabBar titleForIndex:(NSInteger)index;
- (UIButton *)segmentTabBar:(WGLSegmentTabBar *)segmentTabBar buttonForIndex:(NSInteger)index;

- (UIButton *)leftButtonForSegmentTabBar:(WGLSegmentTabBar *)segmentTabBar;
- (UIButton *)rightButtonForSegmentTabBar:(WGLSegmentTabBar *)segmentTabBar;

@end

