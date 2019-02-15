//
//  WGLSegmentView.m
//  WGLKit
//
//  Created by wugl on 2018/5/24.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#import "WGLSegmentView.h"

@interface WGLSegmentView ()
@property (nonatomic, assign) NSInteger numberOfSection;
@property (nonatomic, assign) BOOL isNeedCalculate;    //是否需要重新计算
@property (nonatomic, assign) CGFloat topHeightForSegment;  //分页顶部高度

@property (nonatomic, assign) BOOL canScroll;//mainTableView是否可以滚动
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;//到达顶部(临界点)不能移动mainTableView
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;//到达顶部(临界点)不能移动子控制器的tableView
@end

@implementation WGLSegmentView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initData];
//        [self addNotification];
        [self setupUI];
    }
    return self;
}

- (void)initData {
    _numberOfSection = 1;
    _canScroll = YES;
    _isTopIsCanNotMoveTabView = NO;
    _isNeedCalculate = YES;
}

#pragma mark - UI

- (void)setupUI {
    [self addSubview:self.mainTableView];
}

//主tableView(上面section展示自定义section和cell，最后一个section固定展示分页组件segmentView)
- (WGLSegmentMainTableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[WGLSegmentMainTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _mainTableView.delegate = (id<UITableViewDelegate>)self;
        _mainTableView.dataSource = (id<UITableViewDataSource>)self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#ifdef __IPHONE_11_0
        if ([_mainTableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            if (@available(iOS 11.0, *)) {
                [_mainTableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
            } else {
                // Fallback on earlier versions
            }
        }
#endif
    }
    return _mainTableView;
}

//mainTableView的最后一个section固定展示的分页组件
- (WGLCenterSegmentView *)centerSegmentView {
    if (!_centerSegmentView) {
        _centerSegmentView = [[WGLCenterSegmentView alloc] initWithFrame:self.bounds];
        _centerSegmentView.dataSource = (id<WGLCenterSegmentViewDataSource>)self;
        _centerSegmentView.delegate = (id<WGLCenterSegmentViewDelegate>)self;
        
        _centerSegmentView.mainTableView = self.mainTableView;
        
        __weak typeof(self) weakSelf = self;
        _centerSegmentView.isCanScrollBlock = ^(BOOL isCanScroll) {
            if (YES == isCanScroll) {
                weakSelf.mainTableView.scrollEnabled = YES;
            }
            else {
                weakSelf.mainTableView.scrollEnabled = NO;
            }
        };
        
        _centerSegmentView.isLeaveTopBlock = ^(BOOL isLeaveTop) {
            if (YES == isLeaveTop) {
                weakSelf.canScroll = YES;
            }
        };
    }
    return _centerSegmentView;
}

#pragma mark - 刷新UI

- (void)reloadData {
    self.isNeedCalculate = YES;
    [self.mainTableView reloadData];
    [self.centerSegmentView reloadData];
    
    //触发scrollView滚动代理方法，调整segmentView联动临界点
    [self scrollViewDidScroll:self.mainTableView];
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    self.mainTableView.frame = self.bounds;
    self.centerSegmentView.frame = self.bounds;
    
    [self reloadData];
}

#pragma mark - 处理联动

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //当前偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    //临界点偏移量(吸顶临界点)
    CGFloat tabyOffset = [self getTopHeightForSegment];
    
    //注意：先解决mainTableView的bance问题，如果不用下拉头部刷新/下拉头部放大/为了实现subTableView下拉刷新
    //1. 不用下拉顶部刷新、不用下拉头部放大、使用subTableView下拉顶部刷新， 可在mainTableView初始化时禁用bance；
    //2. 如果做下拉顶部刷新、下拉头部放大，就需要对bance做处理，不然当视图滑动到底部后，内外层的scrollView的bance都会起作用，导致视觉上的幻觉(刚滑动到底部/触发内部scrollView的bance的时候，再去点击cell/item/button, 你会发现竟然不管用，再次点就好了，刚开始还以为是点击事件和滑动事件的冲突，后来通过offset的log，发现当内部bance触发的时候，你感觉不到外层bance的变化，并且你会看见，当前列表已经停止滚动了，但是外层scrollView的offset还在变，所以导致首次点击事件失效)
//    if (yOffset > self.mainTableView.contentSize.height) {
//        scrollView.bounces = NO;
//    }else {
//        scrollView.bounces = YES;
//    }
    
    //利用contentOffset处理内外层scrollView的滑动冲突问题
    if (yOffset - tabyOffset >= -0.5) {
        //当分页视图滑动至导航栏时，禁止外层tableView滑动
//        NSLog(@"分页选择部分保持在顶端，禁止外层tableView滑动 : %f", tabyOffset);
        scrollView.contentOffset = CGPointMake(0, tabyOffset);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        //当分页视图和顶部导航栏分离时，允许外层tableView滑动
        _isTopIsCanNotMoveTabView = NO;
    }
    
    //取反
    _isTopIsCanNotMoveTabViewPre = !_isTopIsCanNotMoveTabView;
    
    if (_isTopIsCanNotMoveTabView) {
//        NSLog(@"分页选择部分滑动到顶端");
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
        [self.centerSegmentView allowSubSegmentViewScroll];
        _canScroll = NO;
    }else {
//        NSLog(@"页面滑动到底部后开始下拉");
        if (!_canScroll) {
//            NSLog(@"分页选择部分保持在顶端 : %f", tabyOffset);
            _mainTableView.contentOffset = CGPointMake(0, tabyOffset);
        }
    }
    
    if (YES == _canScroll) {
        if ([self.delegate respondsToSelector:@selector(segmentView:didScroll:)]) {
            [self.delegate segmentView:self didScroll:scrollView];
        }
    }
}

#pragma mark - notification

//- (void)addNotification {
//    //注册允许外层tableView滚动通知-解决和分页视图的上下滑动冲突问题
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
//    //注册允许外层tableView滚动通知-解决子视图左右滑动和外层tableView上下滑动的冲突问题
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsgOfSubView:) name:@"isScroll" object:nil];
//}

//- (void)acceptMsg:(NSNotification *)notification {
//    NSDictionary *userInfo = notification.userInfo;
//    NSString *canScroll = userInfo[@"canScroll"];
//    if ([canScroll isEqualToString:@"1"]) {
//        _canScroll = YES;
//    }
//}
//
//- (void)acceptMsgOfSubView:(NSNotification *)notification {
//    NSDictionary *userInfo = notification.userInfo;
//    NSString *canScroll = userInfo[@"canScroll"];
//    if ([canScroll isEqualToString:@"1"]) {
//        self.mainTableView.scrollEnabled = YES;
//    }else if([canScroll isEqualToString:@"0"]) {
//        self.mainTableView.scrollEnabled = NO;
//    }
//}

#pragma mark - 获取分页控件segmentView的上面所有section和cell的总高度

//获取的这个高度值是解决上下两个scrollview的滚动冲突的临界点
- (CGFloat)getTopHeightForSegment {
    if (self.isNeedCalculate) {
        self.isNeedCalculate = NO;
        //调用reloadData则需要重新计算高度
        
        CGFloat totalHeight = 0.0f;
        for (int section = 0; section < self.numberOfSection - 1; section++) {
            NSInteger numOfRow = [self.mainTableView numberOfRowsInSection:section];
            for (int row = 0; row < numOfRow; row++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                
                float rowHeight =
                [self tableView:self.mainTableView heightForRowAtIndexPath:indexPath];
                float headerHeight =
                [self tableView:self.mainTableView heightForHeaderInSection:indexPath.section];
                float footerHeight =
                [self tableView:self.mainTableView heightForFooterInSection:indexPath.section];
                
                totalHeight += (rowHeight + headerHeight + footerHeight);
            }
        }
        self.topHeightForSegment = totalHeight;
    }
    
    return self.topHeightForSegment;
}

#pragma mark - 选中某个分页

- (void)selectSegmentAtIndex:(NSInteger)index {
    [self selectSegmentAtIndex:index animation:NO];
}

- (void)selectSegmentAtIndex:(NSInteger)index animation:(BOOL)animation {
    [self.centerSegmentView selectSegmentAtIndex:index animation:animation];
}

#pragma mark - 向上滚动到分页tab悬挂

- (void)scrollToSegmentTabSuspend {
    [self scrollToSegmentTabSuspendWithAnimation:NO];
}

- (void)scrollToSegmentTabSuspendWithAnimation:(BOOL)animation {
    CGFloat criticalY = 0.5f;
    [self.mainTableView setContentOffset:CGPointMake(0, [self getTopHeightForSegment] - criticalY) animated:animation];
}

#pragma mark - WGLCenterSegmentViewDataSource

- (NSInteger)numberOfTitlesInCenterSegmentView:(WGLCenterSegmentView *)centerSegmentView {
    NSInteger number = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfTitlesInSegmentView:)]) {
        number = [self.dataSource numberOfTitlesInSegmentView:self];
    }
    return number;
}

- (NSString *)centerSegmentView:(WGLCenterSegmentView *)centerSegmentView titleForIndex:(NSInteger)index {
    NSString *title = nil;
    if ([self.dataSource respondsToSelector:@selector(segmentView:titleForIndex:)]) {
        title = [self.dataSource segmentView:self titleForIndex:index];
    }
    return title;
}

- (UIButton *)centerSegmentView:(WGLCenterSegmentView *)centerSegmentView buttonForIndex:(NSInteger)index {
    UIButton *btn = nil;
    if ([self.dataSource respondsToSelector:@selector(segmentView:buttonForIndex:)]) {
        btn = [self.dataSource segmentView:self buttonForIndex:index];
    }
    return btn;
}

- (WGLSubSegmentBaseViewController *)centerSegmentView:(WGLCenterSegmentView *)centerSegmentView viewControllerForIndex:(NSInteger)index {
    WGLSubSegmentBaseViewController *vc = nil;
    if ([self.dataSource respondsToSelector:@selector(segmentView:viewControllerForIndex:)]) {
        vc = [self.dataSource segmentView:self viewControllerForIndex:index];
    }
    return vc;
}

- (CGFloat)heightForTabBarViewInCenterSegmentView:(WGLCenterSegmentView *)centerSegmentView {
    CGFloat height = 0;
    if ([self.dataSource respondsToSelector:@selector(heightForTabBarViewInSegmentView:)]) {
        height = [self.dataSource heightForTabBarViewInSegmentView:self];
    }
    return height;
}

- (UIButton *)leftButtonForCenterSegmentView:(WGLCenterSegmentView *)centerSegmentView {
    UIButton *btn = nil;
    if ([self.dataSource respondsToSelector:@selector(leftButtonForSegmentView:)]) {
        btn = [self.dataSource leftButtonForSegmentView:self];
    }
    return btn;
}

- (UIButton *)rightButtonForCenterSegmentView:(WGLCenterSegmentView *)centerSegmentView {
    UIButton *btn = nil;
    if ([self.dataSource respondsToSelector:@selector(rightButtonForSegmentView:)]) {
        btn = [self.dataSource rightButtonForSegmentView:self];
    }
    return btn;
}

- (WGLSegmentTabBar *)tabBarViewForCenterSegmentView:(WGLCenterSegmentView *)centerSegmentView {
    WGLSegmentTabBar *tabBar = nil;
    if ([self.dataSource respondsToSelector:@selector(tabBarViewForSegmentView:)]) {
        tabBar = [self.dataSource tabBarViewForSegmentView:self];
    }
    return tabBar;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = 1;
    
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInSegmentView:)]) {
        number = [self.dataSource numberOfSectionsInSegmentView:self];
    }
    //分页控制器，显示在最后一个section上面
    number ++;
    self.numberOfSection = number;
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (section == self.numberOfSection - 1) {
        //分页控制器，显示在最后一个section上面
        number = 1;
    }
    else {
        if ([self.dataSource respondsToSelector:@selector(segmentView:numberOfRowsInSection:)]) {
            number = [self.dataSource segmentView:self numberOfRowsInSection:section];
        }
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == self.numberOfSection - 1) {
        //分页控制器，显示在最后一个section上面
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WGLCenterSegmentView class])];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([WGLCenterSegmentView class])];
            cell.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:self.centerSegmentView];
        }
        self.centerSegmentView.frame = self.bounds;
    }
    else {
        if ([self.dataSource respondsToSelector:@selector(segmentView:cellForRowAtIndexPath:)]) {
            cell = [self.dataSource segmentView:self cellForRowAtIndexPath:indexPath];
        }
    }
    if (!cell) {
        NSString *segmentCellDefaultIdentify = [NSString stringWithFormat:@"%@_default_identify", NSStringFromClass([WGLSegmentView class])];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:segmentCellDefaultIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    if (section == self.numberOfSection - 1) {
        
    }
    else {
        if ([self.dataSource respondsToSelector:@selector(segmentView:titleForHeaderInSection:)]) {
            title = [self.dataSource segmentView:self titleForHeaderInSection:section];
        }
    }
    return title;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *title = nil;
    if (section == self.numberOfSection - 1) {
        
    }
    else {
        if ([self.dataSource respondsToSelector:@selector(segmentView:titleForFooterInSection:)]) {
            title = [self.dataSource segmentView:self titleForFooterInSection:section];
        }
    }
    return title;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.numberOfSection - 1) {
        
    }
    else {
        if ([self.delegate respondsToSelector:@selector(segmentView:willDisplayCell:forRowAtIndexPath:)]) {
            [self.delegate segmentView:self willDisplayCell:cell forRowAtIndexPath:indexPath];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == self.numberOfSection - 1) {
        
    }
    else {
        if ([self.delegate respondsToSelector:@selector(segmentView:willDisplayHeaderView:forSection:)]) {
            [self.delegate segmentView:self willDisplayHeaderView:view forSection:section];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if (section == self.numberOfSection - 1) {
        
    }
    else {
        if ([self.delegate respondsToSelector:@selector(segmentView:willDisplayFooterView:forSection:)]) {
            [self.delegate segmentView:self willDisplayFooterView:view forSection:section];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    if (indexPath.section == self.numberOfSection - 1) {
        //分页控制器的高度，设置跟segmentView高度一样
        height = self.frame.size.height;
    }
    else {
        if ([self.delegate respondsToSelector:@selector(segmentView:heightForRowAtIndexPath:)]) {
            height = [self.delegate segmentView:self heightForRowAtIndexPath:indexPath];
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    if (section == self.numberOfSection - 1) {
        
    }
    else {
        if ([self.delegate respondsToSelector:@selector(segmentView:heightForHeaderInSection:)]) {
            height = [self.delegate segmentView:self heightForHeaderInSection:section];
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    if (section == self.numberOfSection - 1) {
        
    }
    else {
        if ([self.delegate respondsToSelector:@selector(segmentView:heightForFooterInSection:)]) {
            height = [self.delegate segmentView:self heightForFooterInSection:section];
        }
    }
    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    if (section == self.numberOfSection - 1) {
        
    }
    else {
        if ([self.delegate respondsToSelector:@selector(segmentView:viewForHeaderInSection:)]) {
            view = [self.delegate segmentView:self viewForHeaderInSection:section];
        }
    }
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = nil;
    if (section == self.numberOfSection - 1) {
        
    }
    else {
        if ([self.delegate respondsToSelector:@selector(segmentView:viewForFooterInSection:)]) {
            view = [self.delegate segmentView:self viewForFooterInSection:section];
        }
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.numberOfSection - 1) {
        
    }
    else {
        if ([self.delegate respondsToSelector:@selector(segmentView:didSelectRowAtIndexPath:)]) {
            [self.delegate segmentView:self didSelectRowAtIndexPath:indexPath];
        }
    }
}

#pragma mark - 分页控件回调

- (void)centerSegmentView:(WGLCenterSegmentView *)centerSegmentView willDisplaySegmentVC:(WGLSubSegmentBaseViewController *)segmentVC forIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(segmentView:willDisplaySegmentVC:forIndex:)]) {
        [self.delegate segmentView:self willDisplaySegmentVC:segmentVC forIndex:index];
    }
}

- (void)centerSegmentView:(WGLCenterSegmentView *)centerSegmentView didDisplaySegmentVC:(WGLSubSegmentBaseViewController *)segmentVC forIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(segmentView:didDisplaySegmentVC:forIndex:)]) {
        [self.delegate segmentView:self didDisplaySegmentVC:segmentVC forIndex:index];
    }
}

- (void)centerSegmentView:(WGLCenterSegmentView *)centerSegmentView didScroll:(UIScrollView *)scrolllView {
    if ([self.delegate respondsToSelector:@selector(segmentView:didScroll:)]) {
        [self.delegate segmentView:self didScroll:scrolllView];
    }
}

//判断是否为不可滚动区域和是否可以多点滚动
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //判断是否为不可滚动区域
    if ([self.dataSource respondsToSelector:@selector(segmentView:isScrollEnable:)]) {
        NSIndexPath *indexPath = [self.mainTableView indexPathForRowAtPoint:point];
        BOOL isScroll = [self.dataSource segmentView:self isScrollEnable:indexPath];
        
        if(self.canScroll){
            self.mainTableView.scrollEnabled = isScroll;
        }
        
        self.mainTableView.isShouldRecognizeSimultaneously = isScroll;
    }
    
    //判断是否可以多点滚动
    if ([self.dataSource respondsToSelector:@selector(segmentView:isShouldRecognizeSimultaneously:)]) {
        NSIndexPath *indexPath = [self.mainTableView indexPathForRowAtPoint:point];
        BOOL isShouldRecognizeSimultaneously = [self.dataSource segmentView:self isShouldRecognizeSimultaneously:indexPath];
        
        self.mainTableView.isShouldRecognizeSimultaneously = isShouldRecognizeSimultaneously;
    }
    
    return [super hitTest:point withEvent:event];
}

@end
