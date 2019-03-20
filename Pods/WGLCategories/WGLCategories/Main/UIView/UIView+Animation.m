//
//  UIView+Animation.m
//  WGLCategories
//
//  Created by wugl on 2019/3/20.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)rotateAnimationWithAngle:(CGFloat)angle duration:(NSTimeInterval)duration {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:angle];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
