//
//  WGLSegmentHorizontalScrollView.m
//  videozone
//
//  Created by yulc on 2018/7/3.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#import "WGLSegmentHorizontalScrollView.h"

@implementation WGLSegmentHorizontalScrollView

#pragma mark - 处理滑动手势冲突

//处理左滑右滑，解决系统右划手势与ScrollView右划手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        
        if ((otherGestureRecognizer.state == UIGestureRecognizerStateBegan || otherGestureRecognizer.state == UIGestureRecognizerStatePossible)
            && self.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}


//- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
//    NSLog(@"用户触摸了scroll上的视图%@，是否开始滚动scroll", view);
//    //返回yes - 将触摸事件传递给相应的subView; 返回no - 直接滚动scrollView，不传递触摸事件到subView
//    return YES;// NO;
//}
//
//- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
//    NSLog(@"scrollView取消传递触摸事件到视图%@", view);
//    //no - 不取消，touch事件由view处理，scrollView不滚动; yes - scrollView取消，touch事件由scrollView处理，可滚动
//    return YES;// NO;
//}

@end
