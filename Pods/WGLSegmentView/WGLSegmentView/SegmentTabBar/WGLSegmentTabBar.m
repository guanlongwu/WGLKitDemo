//
//  WGLSegmentTabBar.m
//  WGLKit
//
//  Created by wugl on 2018/5/24.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#import "WGLSegmentTabBar.h"

@interface WGLSegmentTabBar ()

@end

@implementation WGLSegmentTabBar

#pragma mark - UI

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self reloadData];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.scrollView];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

//更新UI
- (void)reloadData {
    //button
    NSInteger numberOfTitles = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfTitlesInSegmentTabBar:)]) {
        numberOfTitles = [self.dataSource numberOfTitlesInSegmentTabBar:self];
    }
    if (numberOfTitles > 0 && numberOfTitles != self.tabBarButtons.count) {
        if (self.tabBarButtons == nil) {
            self.tabBarButtons = [NSMutableArray array];
        }
        //第一次创建、或者button个数有变化
        [self.tabBarButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.tabBarButtons removeAllObjects];
        
        for (int i = 0; i < numberOfTitles; i++) {
            UIButton *button = nil;
            if ([self.dataSource respondsToSelector:@selector(segmentTabBar:buttonForIndex:)]) {
                button = [self.dataSource segmentTabBar:self buttonForIndex:i];
            }
            if (!button) {
                button = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            button.tag = i;
            
            [button addTarget:self action:@selector(clickTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
            
//            __weak typeof(self) weakSelf = self;
//            [button bk_addEventHandler:^(id sender) {
//                __strong typeof(weakSelf) strongSelf = weakSelf;
//                self.selectedIndex = i;
//                [self reloadData];
//                if (self.tapHandler) {
//                    self.tapHandler(i);
//                }
//            } forControlEvents:UIControlEventTouchUpInside];
            
            [self.scrollView addSubview:button];
            [self.tabBarButtons addObject:button];
        }
    }
    
    __block CGFloat selectedCenterX = 0.0f;
    [self.tabBarButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = self.selectedIndex == idx;
        
        NSString *title = nil;
        if ([self.dataSource respondsToSelector:@selector(segmentTabBar:titleForIndex:)]) {
            title = [self.dataSource segmentTabBar:self titleForIndex:idx];
        }
        [obj setTitle:title forState:UIControlStateNormal];
        
        obj.titleLabel.font =
        self.selectedIndex == idx ? (self.titleSelectedFont ?: self.titleNormalFont) : self.titleNormalFont;
        if (obj.titleLabel.font == nil) {
            obj.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        }
        
        obj.backgroundColor =
        self.selectedIndex == idx ? (self.buttonBgSelectedColor ?: self.buttonBgNormalColor) : self.buttonBgNormalColor;
        [obj setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        [obj setTitleColor:(self.titleSelectedColor ?: self.titleNormalColor) forState:UIControlStateSelected];
        
        if (self.selectedIndex == idx) {
            selectedCenterX = obj.center.x;
        }
    }];
    
    //selectedLine
    if (self.selectedLine.superview == nil) {
        [self.scrollView addSubview:self.selectedLine];
    }
    [self bringSubviewToFront:self.selectedLine];
    
    self.selectedLine.frame = CGRectMake(0,
                                         self.frame.size.height - self.selectedLineHeight - self.selectedLineOriginY,
                                         self.selectedLineWidth,
                                         self.selectedLineWidth);
    self.selectedLine.backgroundColor = self.selectedLineColor;
    if (self.selectedLineWidthIsDynamic || self.selectedLineWidth < 0.1f) {
        //下划线是否自动适应文字长度
        
        NSString *title = nil;
        if ([self.dataSource respondsToSelector:@selector(segmentTabBar:titleForIndex:)]) {
            title = [self.dataSource segmentTabBar:self titleForIndex:self.selectedIndex];
        }
        UIFont *font = (self.titleSelectedFont ?: self.titleNormalFont) ?: [UIFont systemFontOfSize:[UIFont systemFontSize]];
        CGFloat width = [self sizeOfString:title font:font maxwidth:self.frame.size.width].width;
        self.selectedLine.frame = CGRectMake(self.selectedLine.frame.origin.x,
                                             self.selectedLine.frame.origin.y,
                                             width,
                                             self.selectedLine.frame.size.height);
    }
    else {
        [self layoutSubviews];
    }
    
    //左右按钮
    if ([self.dataSource respondsToSelector:@selector(leftButtonForSegmentTabBar:)]) {
        self.leftButton = [self.dataSource leftButtonForSegmentTabBar:self];
    }
    if (!self.leftButton) {
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [self addSubview:self.leftButton];
    
    if ([self.dataSource respondsToSelector:@selector(rightButtonForSegmentTabBar:)]) {
        self.rightButton = [self.dataSource rightButtonForSegmentTabBar:self];
    }
    if (!self.rightButton) {
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [self addSubview:self.rightButton];
}

- (UIView *)selectedLine {
    if (!_selectedLine) {
        _selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 5)];
    }
    return _selectedLine;
}

#pragma mark - 选中某个tab

- (void)selectTabAtIndex:(NSInteger)index {
    [self selectTabAtIndex:index animation:NO];
}

- (void)selectTabAtIndex:(NSInteger)index animation:(BOOL)animation {
    if (index >= 0 && index < self.tabBarButtons.count) {
        self.selectedIndex = index;
        [self reloadData];
    }
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger count = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfTitlesInSegmentTabBar:)]) {
        count = [self.dataSource numberOfTitlesInSegmentTabBar:self];
    }
    if (count > 0) {
        
        __block CGFloat selectedCenterX = 0.0f;
        __block CGFloat selectedWidth = self.selectedLineWidth;
        
        //所有tab占用的宽度
        CGFloat allTabWidth = self.frame.size.width - (self.marginLeft + self.marginRight);
        if (allTabWidth < 10) {
            return;
        }
        //前一个tab占用的宽度
        __block CGFloat preTabWidth = allTabWidth / count;
        //单个tab占用的宽度
        __block CGFloat tabWidth = allTabWidth / count;
        //单个tab的左边距
        __block CGFloat tabOriginX = 0;
        //scrollView的contentSize.width
        __block CGFloat scrollContentWidth = 0;
        
        [self.tabBarButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (self.tabInterval > 0) {
                //指定了tab间隙
                if (idx > 0) {
                    //计算当前tab的左偏移x
                    NSString *title = nil;
                    NSInteger preIdx = idx - 1;
                    if ([self.dataSource respondsToSelector:@selector(segmentTabBar:titleForIndex:)]) {
                        title = [self.dataSource segmentTabBar:self titleForIndex:preIdx];
                    }
                    if (title.length > 0) {
                        preTabWidth = [self sizeOfString:title font:self.titleNormalFont maxwidth:self.frame.size.width].width;
                    }
                    tabOriginX += (preTabWidth + self.tabInterval);
                }
                
                //计算当前tab的宽度
                NSString *title = nil;
                if ([self.dataSource respondsToSelector:@selector(segmentTabBar:titleForIndex:)]) {
                    title = [self.dataSource segmentTabBar:self titleForIndex:idx];
                }
                if (title.length > 0) {
                    tabWidth = [self sizeOfString:title font:self.titleNormalFont maxwidth:self.frame.size.width].width;
                }
            }
            else {
                if (idx > 0) {
                    tabOriginX += (tabWidth + self.tabInterval);
                }
            }
            
            //设置button大小
            obj.frame = CGRectMake(tabOriginX,
                                   0,
                                   tabWidth,
                                   self.scrollView.frame.size.height);
            
            scrollContentWidth = tabOriginX + tabWidth + self.tabInterval;
            
            //设置下划线位置
            if (idx == self.selectedIndex) {
                selectedCenterX = obj.center.x;
                if (self.selectedLineWidthIsDynamic || self.selectedLineWidth < 0.1f) {
                    selectedWidth = [self sizeOfString:obj.titleLabel.text font:obj.titleLabel.font maxwidth:self.frame.size.width].width;
                }
            }
        }];
        
        //scrollview
        self.scrollView.frame = CGRectMake(self.marginLeft,
                                           0,
                                           self.frame.size.width - self.marginLeft - self.marginRight,
                                           self.frame.size.height);
        self.scrollView.contentSize = CGSizeMake(scrollContentWidth, self.scrollView.frame.size.height);
        
        //选中tab定位
        if (scrollContentWidth > self.scrollView.frame.size.width) {
            
            CGFloat halfOfScrollW = self.scrollView.frame.size.width / 2;
            if (selectedCenterX < halfOfScrollW) {
                [self.scrollView setContentOffset:CGPointZero animated:YES];
            }
            else if (scrollContentWidth - selectedCenterX < halfOfScrollW) {
                CGFloat offsetX = scrollContentWidth - self.scrollView.frame.size.width;
                [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
            }
            else {
                CGFloat offsetX = selectedCenterX - halfOfScrollW;
                [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
            }
        }
        
        //选中下划线
        self.selectedLine.frame = CGRectMake(self.selectedLine.frame.origin.x,
                                             self.scrollView.frame.size.height - self.selectedLineHeight - self.selectedLineOriginY,
                                             self.selectedLine.frame.size.width,
                                             self.selectedLine.frame.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            self.selectedLine.frame = CGRectMake(self.selectedLine.frame.origin.x,
                                                 self.scrollView.frame.size.height - self.selectedLineHeight - self.selectedLineOriginY,
                                                 selectedWidth,
                                                 self.selectedLine.frame.size.height);
            self.selectedLine.center = CGPointMake(selectedCenterX, self.selectedLine.center.y);
        }];
    }
    
    //左右按钮
    self.rightButton.frame =
    CGRectMake(self.frame.size.width - self.rightButton.frame.size.width,
               self.rightButton.frame.origin.y,
               self.rightButton.frame.size.width,
               self.rightButton.frame.size.height);
}

//获取文字宽高
- (CGSize)sizeOfString:(NSString *)string font:(UIFont *)font maxwidth:(CGFloat)maxwidth {
    if(nil == string){
        return CGSizeZero;
    }
    NSRange range = [string rangeOfString:@"لُلُصّبُلُلصّبُررً"];
    if (range.length != 0) {
        return CGSizeMake(maxwidth, 20);
    }
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(maxwidth, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];
    return rect.size;
}

#pragma mark - action

- (void)clickTabBarButton:(UIButton *)button {
    NSInteger i = button.tag;
    self.selectedIndex = i;
    [self reloadData];
    if (self.tapHandler) {
        self.tapHandler(i);
    }
}


@end

