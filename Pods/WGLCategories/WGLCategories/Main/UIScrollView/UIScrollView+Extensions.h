//
//  UIScrollView+Extensions.h
//  WGLUtils
//
//  Created by wugl on 2019/3/14.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Extensions)

/**
 以动画方式将内容滚动到顶部
 */
- (void)scrollToTop;

/**
 以动画方式将内容滚动到底部
 */
- (void)scrollToBottom;

/**
 以动画方式将内容滚动到左边
 */
- (void)scrollToLeft;

/**
 以动画方式将内容滚动到右边
 */
- (void)scrollToRight;

/**
 滚动到顶部
 */
- (void)scrollToTopAnimated:(BOOL)animated;

/**
 滚动到底部
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

/**
 滚动到左边
 */
- (void)scrollToLeftAnimated:(BOOL)animated;

/**
 滚动到右边
 */
- (void)scrollToRightAnimated:(BOOL)animated;

@end
