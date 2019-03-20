//
//  UIView+Animation.h
//  WGLCategories
//
//  Created by wugl on 2019/3/20.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

/**
 以指定弧度和指定时长进行旋转

 @param angle 旋转弧度值
 @param duration 动画时长
 */
- (void)rotateAnimationWithAngle:(CGFloat)angle duration:(NSTimeInterval)duration;

@end
